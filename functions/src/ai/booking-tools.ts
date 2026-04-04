import type Anthropic from '@anthropic-ai/sdk';

export const BOOKING_TOOLS: Anthropic.Messages.Tool[] = [
  {
    name: 'check_availability',
    description:
      'Check accommodation availability for given dates and guest count.',
    input_schema: {
      type: 'object' as const,
      properties: {
        type: {
          type: 'string',
          enum: ['a_frame', 'barnhouse', 'hotel_room', 'cabin', 'dome', 'hut'],
          description: 'Type of accommodation. Omit to check all types.',
        },
        checkIn: {
          type: 'string',
          description: 'Check-in date (YYYY-MM-DD)',
        },
        checkOut: {
          type: 'string',
          description: 'Check-out date (YYYY-MM-DD)',
        },
        guests: {
          type: 'number',
          description: 'Number of guests',
        },
      },
      required: ['checkIn', 'checkOut', 'guests'],
    },
  },
  {
    name: 'create_booking',
    description: 'Create a new accommodation booking.',
    input_schema: {
      type: 'object' as const,
      properties: {
        accommodationId: { type: 'string' },
        checkIn: { type: 'string', description: 'YYYY-MM-DD' },
        checkOut: { type: 'string', description: 'YYYY-MM-DD' },
        guests: { type: 'number' },
      },
      required: ['accommodationId', 'checkIn', 'checkOut', 'guests'],
    },
  },
  {
    name: 'get_gondola_slots',
    description: 'Get available gondola time slots for a date.',
    input_schema: {
      type: 'object' as const,
      properties: {
        date: { type: 'string', description: 'Date (YYYY-MM-DD)' },
      },
      required: ['date'],
    },
  },
  {
    name: 'get_trail_info',
    description: 'Get information about trails, optionally filtered by difficulty.',
    input_schema: {
      type: 'object' as const,
      properties: {
        difficulty: {
          type: 'string',
          description: 'Filter by difficulty grade (e.g., "1B", "2A")',
        },
      },
      required: [],
    },
  },
  {
    name: 'get_weather',
    description: 'Get current weather and forecast for the park.',
    input_schema: {
      type: 'object' as const,
      properties: {},
      required: [],
    },
  },
  {
    name: 'create_pass',
    description: 'Create an entry pass for the park.',
    input_schema: {
      type: 'object' as const,
      properties: {
        type: {
          type: 'string',
          enum: ['day', 'multi_day', 'annual'],
        },
        category: {
          type: 'string',
          enum: ['citizen', 'tourist', 'child', 'student'],
        },
      },
      required: ['type', 'category'],
    },
  },
  {
    name: 'get_tours',
    description: 'Get available tours, optionally filtered by type.',
    input_schema: {
      type: 'object' as const,
      properties: {
        type: {
          type: 'string',
          enum: ['hiking', 'horse', 'climbing', 'skiing', 'photo'],
        },
        date: { type: 'string', description: 'Date (YYYY-MM-DD)' },
      },
      required: [],
    },
  },
  {
    name: 'reserve_restaurant',
    description: 'Make a restaurant reservation.',
    input_schema: {
      type: 'object' as const,
      properties: {
        restaurantId: { type: 'string' },
        date: { type: 'string' },
        time: { type: 'string', description: 'Time in HH:MM format' },
        partySize: { type: 'number' },
        specialRequests: { type: 'string' },
      },
      required: ['restaurantId', 'date', 'time', 'partySize'],
    },
  },
];
