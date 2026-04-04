export type PassType = 'day' | 'multi_day' | 'annual';
export type PassCategory = 'citizen' | 'tourist' | 'child' | 'student';
export type PassStatus = 'active' | 'used' | 'expired' | 'refunded';

export interface ParkPass {
  id: string;
  userId: string;
  type: PassType;
  category: PassCategory;
  validFrom: Date;
  validTo: Date;
  qrCode: string;
  status: PassStatus;
  price: number;
  currency: string;
  paymentId?: string;
  scannedAt?: Date;
  scannedBy?: string;
}
