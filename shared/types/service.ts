import { LocaleMap } from './common';

export type ServiceCategory =
  | 'entrance'
  | 'hotel'
  | 'venue'
  | 'recreation'
  | 'rental'
  | 'extra';

export type PriceUnit =
  | 'perNight'
  | 'perHour'
  | 'perDay'
  | 'perPerson'
  | 'perTable'
  | 'perItem'
  | 'perVehicle'
  | 'flat';

export interface Service {
  id: string;
  name: LocaleMap;
  description: LocaleMap;
  category: ServiceCategory;
  priceKgs: number;
  unit: PriceUnit;
  capacity?: number;
  venue?: string;
  images: string[];
  phone?: string;
  isActive: boolean;
}
