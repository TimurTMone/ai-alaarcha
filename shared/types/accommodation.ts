import { LocaleMap } from './common';

export type AccommodationType =
  | 'a_frame'
  | 'barnhouse'
  | 'hotel_room'
  | 'cabin'
  | 'dome'
  | 'hut';

export interface Accommodation {
  id: string;
  name: string;
  type: AccommodationType;
  description: LocaleMap;
  images: string[];
  amenities: string[];
  capacity: number;
  pricePerNight: number;
  currency: string;
  location?: { latitude: number; longitude: number };
  includesGondola: boolean;
  rating: number;
  reviewCount: number;
}
