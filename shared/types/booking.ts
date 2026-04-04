export type BookingStatus =
  | 'pending'
  | 'confirmed'
  | 'checked_in'
  | 'completed'
  | 'cancelled';

export interface Booking {
  id: string;
  userId: string;
  accommodationId: string;
  checkIn: Date;
  checkOut: Date;
  guests: number;
  totalPrice: number;
  currency: string;
  status: BookingStatus;
  qrCode?: string;
  paymentId?: string;
  receiptUrl?: string;
  confirmedBy?: 'ai' | 'admin';
  createdAt: Date;
}
