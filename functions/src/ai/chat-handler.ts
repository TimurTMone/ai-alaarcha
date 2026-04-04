import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { Timestamp } from 'firebase-admin/firestore';
import { defineSecret } from 'firebase-functions/params';
import Anthropic from '@anthropic-ai/sdk';
import { SYSTEM_PROMPT } from './system-prompt';
import { BOOKING_TOOLS } from './booking-tools';
import { db } from '../utils/admin';

const anthropicApiKey = defineSecret('ANTHROPIC_API_KEY');

export const chatHandler = onCall(
  { secrets: [anthropicApiKey] },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Login required');

    const { chatId, message } = request.data;
    const userId = request.auth.uid;

    // Get or create chat
    let chatRef = chatId
      ? db.collection('chats').doc(chatId)
      : db.collection('chats').doc();

    if (!chatId) {
      await chatRef.set({
        userId,
        status: 'active',
        handedToHuman: false,
        createdAt: Timestamp.now(),
      });
    }

    // Save user message
    await chatRef.collection('messages').add({
      role: 'user',
      content: message,
      timestamp: Timestamp.now(),
    });

    // Get conversation history
    const messagesSnap = await chatRef
      .collection('messages')
      .orderBy('timestamp')
      .limit(50)
      .get();

    const history = messagesSnap.docs.map((doc) => ({
      role: doc.data().role as 'user' | 'assistant',
      content: doc.data().content as string,
    }));

    // Get user context
    const userDoc = await db.collection('users').doc(userId).get();
    const userLang = userDoc.data()?.language ?? 'ru';

    // Call Claude
    const client = new Anthropic({ apiKey: anthropicApiKey.value() });

    const response = await client.messages.create({
      model: 'claude-sonnet-4-6',
      max_tokens: 1024,
      system: SYSTEM_PROMPT(userLang),
      tools: BOOKING_TOOLS,
      messages: history,
    });

    // Extract text response
    const textBlock = response.content.find((b) => b.type === 'text');
    const assistantMessage = textBlock ? textBlock.text : '';

    // Save assistant response
    await chatRef.collection('messages').add({
      role: 'assistant',
      content: assistantMessage,
      timestamp: Timestamp.now(),
    });

    // Handle tool use if needed
    const toolUse = response.content.find((b) => b.type === 'tool_use');

    return {
      chatId: chatRef.id,
      message: assistantMessage,
      toolUse: toolUse ?? null,
    };
  }
);
