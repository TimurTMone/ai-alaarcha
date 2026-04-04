export const ENTRY_PRICES: Record<string, number> = {
  citizen_adult: 100,
  citizen_child: 50,
  citizen_student: 70,
  tourist_adult: 500,
  tourist_child: 250,
  tourist_student: 350,
};

export const GONDOLA_PRICE_PER_PERSON = 500; // KGS

export const CURRENCY = {
  entry: 'KGS',
  accommodation: 'USD',
  gondola: 'KGS',
} as const;
