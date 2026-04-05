'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import {
  collection,
  onSnapshot,
  orderBy,
  query,
  Timestamp,
  where,
} from 'firebase/firestore';
import { httpsCallable } from 'firebase/functions';
import { firestore, functions } from '@/lib/firebase';

interface AiVerification {
  score?: number;
  extractedAmountKgs?: number | null;
  extractedDate?: Timestamp | null;
  extractedReference?: string | null;
  notes?: string | null;
}

interface PendingBooking {
  id: string;
  userId: string;
  subjectType: string;
  subjectId: string;
  totalPriceKgs: number;
  currency: string;
  status: string;
  receiptUrl?: string | null;
  aiVerification?: AiVerification | null;
  createdAt?: Timestamp | null;
  startsAt?: Timestamp | null;
  endsAt?: Timestamp | null;
  quantity?: number | null;
  unit?: string | null;
}

export default function PendingBookingsPage() {
  const [bookings, setBookings] = useState<PendingBooking[]>([]);
  const [loading, setLoading] = useState(true);
  const [selected, setSelected] = useState<PendingBooking | null>(null);
  const [actionInFlight, setActionInFlight] = useState<string | null>(null);
  const [toast, setToast] = useState<{ kind: 'ok' | 'err'; msg: string } | null>(
    null
  );

  useEffect(() => {
    const q = query(
      collection(firestore, 'bookings'),
      where('status', '==', 'needsReview'),
      orderBy('createdAt', 'asc')
    );
    const unsub = onSnapshot(
      q,
      (snap) => {
        const rows: PendingBooking[] = snap.docs.map((d) => ({
          id: d.id,
          ...(d.data() as Omit<PendingBooking, 'id'>),
        }));
        setBookings(rows);
        setLoading(false);
      },
      (err) => {
        console.error('bookings subscription failed', err);
        setLoading(false);
        setToast({ kind: 'err', msg: err.message });
      }
    );
    return () => unsub();
  }, []);

  const handleDecision = async (
    booking: PendingBooking,
    decision: 'approve' | 'reject'
  ) => {
    let note: string | undefined;
    if (decision === 'reject') {
      const input = window.prompt('Reason for rejection (shown to user):');
      if (input === null) return; // cancelled
      note = input.trim() || 'Rejected by admin';
    }
    setActionInFlight(booking.id);
    try {
      const fn = httpsCallable(functions, 'reviewBooking');
      await fn({ bookingId: booking.id, decision, note });
      setToast({
        kind: 'ok',
        msg: decision === 'approve' ? 'Approved' : 'Rejected',
      });
      if (selected?.id === booking.id) setSelected(null);
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      setToast({ kind: 'err', msg });
    } finally {
      setActionInFlight(null);
      setTimeout(() => setToast(null), 3000);
    }
  };

  return (
    <div className="min-h-screen">
      <header className="bg-[#1B4332] text-white px-8 py-6">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div>
            <Link href="/" className="text-green-200 text-sm hover:underline">
              ← Dashboard
            </Link>
            <h1 className="text-2xl font-bold mt-1">Pending Bookings</h1>
            <p className="text-green-200 text-sm">
              Receipts flagged by AI for human review
            </p>
          </div>
          <div className="text-right">
            <div className="text-sm">In queue</div>
            <div className="text-3xl font-bold">{bookings.length}</div>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-8 py-8">
        {loading ? (
          <div className="text-gray-500">Loading…</div>
        ) : bookings.length === 0 ? (
          <EmptyState />
        ) : (
          <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-600 text-left">
                <tr>
                  <th className="px-4 py-3 font-medium">Ref</th>
                  <th className="px-4 py-3 font-medium">Subject</th>
                  <th className="px-4 py-3 font-medium">User</th>
                  <th className="px-4 py-3 font-medium">Amount</th>
                  <th className="px-4 py-3 font-medium">AI score</th>
                  <th className="px-4 py-3 font-medium">Extracted</th>
                  <th className="px-4 py-3 font-medium">Receipt</th>
                  <th className="px-4 py-3 font-medium text-right">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {bookings.map((b) => (
                  <BookingRow
                    key={b.id}
                    booking={b}
                    busy={actionInFlight === b.id}
                    onOpen={() => setSelected(b)}
                    onApprove={() => handleDecision(b, 'approve')}
                    onReject={() => handleDecision(b, 'reject')}
                  />
                ))}
              </tbody>
            </table>
          </div>
        )}
      </main>

      {selected && (
        <DetailDrawer
          booking={selected}
          busy={actionInFlight === selected.id}
          onClose={() => setSelected(null)}
          onApprove={() => handleDecision(selected, 'approve')}
          onReject={() => handleDecision(selected, 'reject')}
        />
      )}

      {toast && (
        <div
          className={`fixed bottom-6 right-6 px-4 py-3 rounded-lg shadow-lg text-white ${
            toast.kind === 'ok' ? 'bg-green-600' : 'bg-red-600'
          }`}
        >
          {toast.msg}
        </div>
      )}
    </div>
  );
}

function BookingRow({
  booking,
  busy,
  onOpen,
  onApprove,
  onReject,
}: {
  booking: PendingBooking;
  busy: boolean;
  onOpen: () => void;
  onApprove: () => void;
  onReject: () => void;
}) {
  const score = booking.aiVerification?.score ?? null;
  const extractedAmount = booking.aiVerification?.extractedAmountKgs ?? null;
  const shortRef = booking.id.slice(0, 6).toUpperCase();

  return (
    <tr className="hover:bg-gray-50">
      <td className="px-4 py-3">
        <button
          onClick={onOpen}
          className="font-mono text-xs text-[#1B4332] hover:underline"
        >
          {shortRef}
        </button>
      </td>
      <td className="px-4 py-3">
        <div className="text-gray-900">{booking.subjectType}</div>
        <div className="text-xs text-gray-500 truncate max-w-[160px]">
          {booking.subjectId}
        </div>
      </td>
      <td className="px-4 py-3 text-gray-700 font-mono text-xs">
        {booking.userId.slice(0, 8)}…
      </td>
      <td className="px-4 py-3 font-medium">
        {booking.totalPriceKgs.toLocaleString()} {booking.currency}
      </td>
      <td className="px-4 py-3">
        {score !== null ? (
          <span
            className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${
              score >= 0.7
                ? 'bg-yellow-100 text-yellow-800'
                : 'bg-red-100 text-red-800'
            }`}
          >
            {Math.round(score * 100)}%
          </span>
        ) : (
          <span className="text-gray-400">—</span>
        )}
      </td>
      <td className="px-4 py-3 text-xs text-gray-600">
        {extractedAmount !== null
          ? `${extractedAmount.toLocaleString()} KGS`
          : '—'}
        {booking.aiVerification?.extractedReference && (
          <div className="text-gray-500 font-mono truncate max-w-[140px]">
            {booking.aiVerification.extractedReference}
          </div>
        )}
      </td>
      <td className="px-4 py-3">
        {booking.receiptUrl ? (
          <button onClick={onOpen}>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={booking.receiptUrl}
              alt="receipt"
              className="w-12 h-12 object-cover rounded border border-gray-200"
            />
          </button>
        ) : (
          <span className="text-gray-400 text-xs">none</span>
        )}
      </td>
      <td className="px-4 py-3 text-right">
        <div className="inline-flex gap-2">
          <button
            onClick={onReject}
            disabled={busy}
            className="px-3 py-1.5 text-xs font-medium rounded border border-red-200 text-red-700 hover:bg-red-50 disabled:opacity-50"
          >
            Reject
          </button>
          <button
            onClick={onApprove}
            disabled={busy}
            className="px-3 py-1.5 text-xs font-medium rounded bg-[#1B4332] text-white hover:bg-[#143528] disabled:opacity-50"
          >
            {busy ? '…' : 'Approve'}
          </button>
        </div>
      </td>
    </tr>
  );
}

function DetailDrawer({
  booking,
  busy,
  onClose,
  onApprove,
  onReject,
}: {
  booking: PendingBooking;
  busy: boolean;
  onClose: () => void;
  onApprove: () => void;
  onReject: () => void;
}) {
  const ai = booking.aiVerification;
  const createdAt = booking.createdAt?.toDate();
  return (
    <div className="fixed inset-0 z-50 flex">
      <button
        aria-label="Close"
        onClick={onClose}
        className="flex-1 bg-black/40"
      />
      <aside className="w-[480px] bg-white h-full overflow-y-auto shadow-2xl">
        <div className="px-6 py-4 border-b flex items-center justify-between sticky top-0 bg-white">
          <div>
            <div className="text-xs text-gray-500">Booking</div>
            <div className="font-mono text-sm">
              {booking.id.slice(0, 6).toUpperCase()}
            </div>
          </div>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-900 text-2xl leading-none"
          >
            ×
          </button>
        </div>
        <div className="p-6 space-y-5">
          <Field label="Subject">
            {booking.subjectType} · {booking.subjectId}
          </Field>
          <Field label="User">
            <span className="font-mono text-xs">{booking.userId}</span>
          </Field>
          <Field label="Amount">
            <span className="font-semibold">
              {booking.totalPriceKgs.toLocaleString()} {booking.currency}
            </span>
          </Field>
          {booking.quantity && booking.unit && (
            <Field label="Quantity">
              {booking.quantity} × {booking.unit}
            </Field>
          )}
          {createdAt && (
            <Field label="Created">{createdAt.toLocaleString()}</Field>
          )}
          {ai && (
            <div className="rounded-lg border border-gray-200 p-4 bg-gray-50 space-y-2">
              <div className="text-xs font-medium text-gray-500">
                AI verification
              </div>
              {ai.score !== undefined && (
                <Field label="Score">
                  {Math.round((ai.score ?? 0) * 100)}%
                </Field>
              )}
              {ai.extractedAmountKgs != null && (
                <Field label="Extracted amount">
                  {ai.extractedAmountKgs.toLocaleString()} KGS
                </Field>
              )}
              {ai.extractedReference && (
                <Field label="Memo">
                  <span className="font-mono text-xs">
                    {ai.extractedReference}
                  </span>
                </Field>
              )}
              {ai.notes && <Field label="Notes">{ai.notes}</Field>}
            </div>
          )}
          {booking.receiptUrl && (
            <div>
              <div className="text-xs font-medium text-gray-500 mb-2">
                Receipt
              </div>
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={booking.receiptUrl}
                alt="receipt"
                className="w-full rounded border border-gray-200"
              />
            </div>
          )}
        </div>
        <div className="sticky bottom-0 bg-white border-t p-4 flex gap-3">
          <button
            onClick={onReject}
            disabled={busy}
            className="flex-1 py-2.5 rounded border border-red-200 text-red-700 hover:bg-red-50 font-medium disabled:opacity-50"
          >
            Reject
          </button>
          <button
            onClick={onApprove}
            disabled={busy}
            className="flex-1 py-2.5 rounded bg-[#1B4332] text-white hover:bg-[#143528] font-medium disabled:opacity-50"
          >
            {busy ? 'Working…' : 'Approve'}
          </button>
        </div>
      </aside>
    </div>
  );
}

function Field({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div className="flex justify-between items-start gap-4 text-sm">
      <span className="text-gray-500">{label}</span>
      <span className="text-right text-gray-900">{children}</span>
    </div>
  );
}

function EmptyState() {
  return (
    <div className="bg-white rounded-xl border border-gray-200 p-12 text-center">
      <div className="text-4xl mb-3">✅</div>
      <div className="font-semibold text-gray-900">Queue is clear</div>
      <p className="text-sm text-gray-500 mt-1">
        No bookings currently flagged for review.
      </p>
    </div>
  );
}

