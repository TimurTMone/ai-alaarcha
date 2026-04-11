import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/booking_provider.dart';
import '../../../core/providers/service_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../widgets/chat_bubble.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

final _messagesProvider = StateProvider<List<_ChatMessage>>((ref) => []);
final _chatSessionProvider = StateProvider<String?>((ref) => null);

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    _controller.clear();
    setState(() => _sending = true);
    final language = Localizations.localeOf(context).languageCode;

    final messages = ref.read(_messagesProvider.notifier);
    messages.state = [
      ...messages.state,
      _ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    ];
    _scrollToBottom();

    try {
      final sessionNotifier = ref.read(_chatSessionProvider.notifier);
      final sessionId =
          sessionNotifier.state ??
          'mobile-${DateTime.now().millisecondsSinceEpoch}';
      sessionNotifier.state = sessionId;

      final response = await ref
          .read(backendApiProvider)
          .sendAiChatMessage(
            sessionId: sessionId,
            message: text,
            language: language,
          );

      if (response.sessionId.isNotEmpty) {
        sessionNotifier.state = response.sessionId;
      }

      if (response.booking != null) {
        ref.read(devBookingsProvider.notifier).add(response.booking!);
      }

      messages.state = [
        ...messages.state,
        _ChatMessage(
          text: response.reply.isEmpty
              ? _fallbackReply(language)
              : response.reply,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    } catch (_) {
      messages.state = [
        ...messages.state,
        _ChatMessage(
          text: _errorReply(language),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    } finally {
      if (mounted) setState(() => _sending = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final messages = ref.watch(_messagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.landscape, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(l.aiConcierge),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.chat,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l.aiWelcome,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (_, i) => ChatBubble(
                      text: messages[i].text,
                      isUser: messages[i].isUser,
                    ),
                  ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: l.typeMessage,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sending ? null : _sendMessage,
                    icon: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _fallbackReply(String language) {
  switch (language) {
    case 'en':
      return 'I can help with services, dates, and booking. Tell me what you want to reserve.';
    case 'ky':
      return 'Кызматтарды, даталарды жана бронду тандап берүүгө жардам берем. Эмне брондойлу?';
    default:
      return 'Я могу помочь с услугами, датами и бронированием. Напишите, что хотите забронировать.';
  }
}

String _errorReply(String language) {
  switch (language) {
    case 'en':
      return 'I cannot reach the AI right now. Please try again in a moment.';
    case 'ky':
      return 'Азыр ИИ менен байланыш жок. Бир аздан кийин кайра аракет кылыңыз.';
    default:
      return 'Сейчас не получается связаться с ИИ. Попробуйте ещё раз через минуту.';
  }
}
