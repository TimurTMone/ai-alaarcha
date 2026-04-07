'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import {
  collection,
  deleteField,
  doc,
  onSnapshot,
  orderBy,
  query,
  setDoc,
  updateDoc,
} from 'firebase/firestore';
import { firestore } from '@/lib/firebase';

const CATEGORIES = ['entrance', 'hotel', 'venue', 'recreation', 'rental', 'extra'] as const;
const UNITS = ['perNight', 'perHour', 'perDay', 'perPerson', 'perTable', 'perItem', 'perVehicle', 'flat'] as const;

const CATEGORY_LABELS: Record<string, string> = {
  entrance: 'Park Entry',
  hotel: 'Hotels',
  venue: 'Halls & Venues',
  recreation: 'Recreation',
  rental: 'Activities & Rentals',
  extra: 'Additional Services',
};

const UNIT_LABELS: Record<string, string> = {
  perNight: '/ night',
  perHour: '/ hour',
  perDay: '/ day',
  perPerson: '/ person',
  perTable: '/ table',
  perItem: '/ item',
  perVehicle: '/ vehicle',
  flat: 'flat',
};

interface ServiceDoc {
  id: string;
  name: { en?: string; ru?: string; ky?: string };
  description: { en?: string; ru?: string; ky?: string };
  category: string;
  priceKgs: number;
  unit: string;
  capacity?: number;
  venue?: string;
  images: string[];
  phone?: string;
  isActive: boolean;
}

const EMPTY_SERVICE: Omit<ServiceDoc, 'id'> = {
  name: { en: '', ru: '', ky: '' },
  description: { en: '', ru: '', ky: '' },
  category: 'extra',
  priceKgs: 0,
  unit: 'flat',
  images: [],
  isActive: true,
};

export default function ServicesPage() {
  const [services, setServices] = useState<ServiceDoc[]>([]);
  const [loading, setLoading] = useState(true);
  const [editing, setEditing] = useState<ServiceDoc | null>(null);
  const [isNew, setIsNew] = useState(false);
  const [toast, setToast] = useState<string | null>(null);
  const [filter, setFilter] = useState<string>('all');

  useEffect(() => {
    const q = query(collection(firestore, 'services'), orderBy('category'));
    const unsub = onSnapshot(q, (snap) => {
      setServices(
        snap.docs.map((d) => ({ id: d.id, ...(d.data() as Omit<ServiceDoc, 'id'>) }))
      );
      setLoading(false);
    });
    return () => unsub();
  }, []);

  const showToast = (msg: string) => {
    setToast(msg);
    setTimeout(() => setToast(null), 2500);
  };

  const handleSave = async (svc: ServiceDoc) => {
    try {
      const { id, ...data } = svc;
      if (isNew) {
        const docId = id || `s-${Date.now().toString(36)}`;
        await setDoc(doc(firestore, 'services', docId), data);
      } else {
        await updateDoc(doc(firestore, 'services', id), data as Record<string, unknown>);
      }
      setEditing(null);
      setIsNew(false);
      showToast(isNew ? 'Service created' : 'Service updated');
    } catch (err) {
      showToast(`Error: ${err}`);
    }
  };

  const handleToggleActive = async (svc: ServiceDoc) => {
    await updateDoc(doc(firestore, 'services', svc.id), {
      isActive: !svc.isActive,
    });
    showToast(svc.isActive ? 'Disabled' : 'Enabled');
  };

  const filtered = filter === 'all'
    ? services
    : services.filter((s) => s.category === filter);

  const grouped = new Map<string, ServiceDoc[]>();
  for (const s of filtered) {
    const cat = s.category;
    if (!grouped.has(cat)) grouped.set(cat, []);
    grouped.get(cat)!.push(s);
  }

  return (
    <div className="min-h-screen">
      <header className="bg-[#1B4332] text-white px-8 py-6">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div>
            <Link href="/" className="text-green-200 text-sm hover:underline">
              ← Dashboard
            </Link>
            <h1 className="text-2xl font-bold mt-1">Services</h1>
            <p className="text-green-200 text-sm">
              {services.length} services · {services.filter((s) => s.isActive).length} active
            </p>
          </div>
          <button
            onClick={() => {
              setEditing({ id: '', ...EMPTY_SERVICE });
              setIsNew(true);
            }}
            className="px-4 py-2 bg-white text-[#1B4332] rounded-lg font-medium hover:bg-green-50"
          >
            + Add Service
          </button>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-8 py-4">
        {/* Category filter */}
        <div className="flex gap-2 flex-wrap mb-6">
          <FilterChip label="All" active={filter === 'all'} onClick={() => setFilter('all')} />
          {CATEGORIES.map((c) => (
            <FilterChip
              key={c}
              label={CATEGORY_LABELS[c]}
              active={filter === c}
              onClick={() => setFilter(c)}
            />
          ))}
        </div>

        {loading ? (
          <div className="text-gray-500">Loading…</div>
        ) : (
          [...grouped.entries()].map(([cat, items]) => (
            <div key={cat} className="mb-8">
              <h2 className="text-lg font-semibold text-gray-800 mb-3">
                {CATEGORY_LABELS[cat] ?? cat}
              </h2>
              <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
                <table className="w-full text-sm">
                  <thead className="bg-gray-50 text-gray-600 text-left">
                    <tr>
                      <th className="px-4 py-2 font-medium">Name (RU)</th>
                      <th className="px-4 py-2 font-medium">Venue</th>
                      <th className="px-4 py-2 font-medium text-right">Price</th>
                      <th className="px-4 py-2 font-medium">Unit</th>
                      <th className="px-4 py-2 font-medium text-center">Cap.</th>
                      <th className="px-4 py-2 font-medium text-center">Active</th>
                      <th className="px-4 py-2 font-medium text-right">Edit</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {items.map((s) => (
                      <tr
                        key={s.id}
                        className={`hover:bg-gray-50 ${!s.isActive ? 'opacity-40' : ''}`}
                      >
                        <td className="px-4 py-2.5 text-gray-900">
                          {s.name.ru || s.name.en || s.id}
                        </td>
                        <td className="px-4 py-2.5 text-gray-500 text-xs">
                          {s.venue ?? '—'}
                        </td>
                        <td className="px-4 py-2.5 text-right font-medium">
                          {s.priceKgs.toLocaleString()} KGS
                        </td>
                        <td className="px-4 py-2.5 text-gray-500 text-xs">
                          {UNIT_LABELS[s.unit] ?? s.unit}
                        </td>
                        <td className="px-4 py-2.5 text-center text-gray-500">
                          {s.capacity ?? '—'}
                        </td>
                        <td className="px-4 py-2.5 text-center">
                          <button
                            onClick={() => handleToggleActive(s)}
                            className={`w-9 h-5 rounded-full relative transition-colors ${
                              s.isActive ? 'bg-green-500' : 'bg-gray-300'
                            }`}
                          >
                            <span
                              className={`block w-4 h-4 rounded-full bg-white shadow absolute top-0.5 transition-transform ${
                                s.isActive ? 'translate-x-4' : 'translate-x-0.5'
                              }`}
                            />
                          </button>
                        </td>
                        <td className="px-4 py-2.5 text-right">
                          <button
                            onClick={() => {
                              setEditing(s);
                              setIsNew(false);
                            }}
                            className="text-[#1B4332] hover:underline text-xs font-medium"
                          >
                            Edit
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Edit drawer */}
      {editing && (
        <EditDrawer
          service={editing}
          isNew={isNew}
          onClose={() => {
            setEditing(null);
            setIsNew(false);
          }}
          onSave={handleSave}
        />
      )}

      {toast && (
        <div className="fixed bottom-6 right-6 px-4 py-3 rounded-lg shadow-lg text-white bg-green-600">
          {toast}
        </div>
      )}
    </div>
  );
}

// ── Filter chip ──

function FilterChip({
  label,
  active,
  onClick,
}: {
  label: string;
  active: boolean;
  onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      className={`px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
        active
          ? 'bg-[#1B4332] text-white'
          : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
      }`}
    >
      {label}
    </button>
  );
}

// ── Edit drawer ──

function EditDrawer({
  service,
  isNew,
  onClose,
  onSave,
}: {
  service: ServiceDoc;
  isNew: boolean;
  onClose: () => void;
  onSave: (s: ServiceDoc) => void;
}) {
  const [form, setForm] = useState<ServiceDoc>({ ...service });

  const update = <K extends keyof ServiceDoc>(key: K, val: ServiceDoc[K]) =>
    setForm((f) => ({ ...f, [key]: val }));

  const updateLocale = (
    field: 'name' | 'description',
    locale: 'en' | 'ru' | 'ky',
    val: string
  ) =>
    setForm((f) => ({
      ...f,
      [field]: { ...f[field], [locale]: val },
    }));

  return (
    <div className="fixed inset-0 z-50 flex">
      <button
        aria-label="Close"
        onClick={onClose}
        className="flex-1 bg-black/40"
      />
      <aside className="w-[520px] bg-white h-full overflow-y-auto shadow-2xl">
        <div className="sticky top-0 bg-white border-b px-6 py-4 flex items-center justify-between z-10">
          <h2 className="font-semibold text-lg">
            {isNew ? 'Add Service' : 'Edit Service'}
          </h2>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-900 text-2xl">
            ×
          </button>
        </div>
        <div className="p-6 space-y-5">
          {isNew && (
            <Field label="ID (optional, auto-generated if empty)">
              <input
                value={form.id}
                onChange={(e) => update('id', e.target.value)}
                className="input"
                placeholder="s-my-service"
              />
            </Field>
          )}

          {/* Name in 3 languages */}
          <div className="space-y-2">
            <div className="text-sm font-medium text-gray-700">Name</div>
            <LangInput label="RU" value={form.name.ru ?? ''} onChange={(v) => updateLocale('name', 'ru', v)} />
            <LangInput label="EN" value={form.name.en ?? ''} onChange={(v) => updateLocale('name', 'en', v)} />
            <LangInput label="KY" value={form.name.ky ?? ''} onChange={(v) => updateLocale('name', 'ky', v)} />
          </div>

          {/* Description in 3 languages */}
          <div className="space-y-2">
            <div className="text-sm font-medium text-gray-700">Description</div>
            <LangTextarea label="RU" value={form.description.ru ?? ''} onChange={(v) => updateLocale('description', 'ru', v)} />
            <LangTextarea label="EN" value={form.description.en ?? ''} onChange={(v) => updateLocale('description', 'en', v)} />
            <LangTextarea label="KY" value={form.description.ky ?? ''} onChange={(v) => updateLocale('description', 'ky', v)} />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <Field label="Category">
              <select
                value={form.category}
                onChange={(e) => update('category', e.target.value)}
                className="input"
              >
                {CATEGORIES.map((c) => (
                  <option key={c} value={c}>{CATEGORY_LABELS[c]}</option>
                ))}
              </select>
            </Field>
            <Field label="Price Unit">
              <select
                value={form.unit}
                onChange={(e) => update('unit', e.target.value)}
                className="input"
              >
                {UNITS.map((u) => (
                  <option key={u} value={u}>{UNIT_LABELS[u]}</option>
                ))}
              </select>
            </Field>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <Field label="Price (KGS)">
              <input
                type="number"
                value={form.priceKgs}
                onChange={(e) => update('priceKgs', Number(e.target.value))}
                className="input"
              />
            </Field>
            <Field label="Capacity (optional)">
              <input
                type="number"
                value={form.capacity ?? ''}
                onChange={(e) =>
                  update('capacity', e.target.value ? Number(e.target.value) : undefined)
                }
                className="input"
                placeholder="—"
              />
            </Field>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <Field label="Venue (optional)">
              <input
                value={form.venue ?? ''}
                onChange={(e) => update('venue', e.target.value || undefined)}
                className="input"
                placeholder="e.g. Ala-Archa Hotel"
              />
            </Field>
            <Field label="Phone (optional)">
              <input
                value={form.phone ?? ''}
                onChange={(e) => update('phone', e.target.value || undefined)}
                className="input"
                placeholder="+996 ..."
              />
            </Field>
          </div>

          <Field label="Active">
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={form.isActive}
                onChange={(e) => update('isActive', e.target.checked)}
                className="w-4 h-4"
              />
              <span className="text-sm text-gray-700">
                {form.isActive ? 'Visible to visitors' : 'Hidden from visitors'}
              </span>
            </label>
          </Field>
        </div>

        <div className="sticky bottom-0 bg-white border-t p-4 flex gap-3">
          <button
            onClick={onClose}
            className="flex-1 py-2.5 rounded border border-gray-200 text-gray-700 hover:bg-gray-50 font-medium"
          >
            Cancel
          </button>
          <button
            onClick={() => onSave(form)}
            className="flex-1 py-2.5 rounded bg-[#1B4332] text-white hover:bg-[#143528] font-medium"
          >
            {isNew ? 'Create' : 'Save'}
          </button>
        </div>
      </aside>

      <style jsx>{`
        .input {
          width: 100%;
          border: 1px solid #e5e7eb;
          border-radius: 8px;
          padding: 8px 12px;
          font-size: 14px;
          outline: none;
        }
        .input:focus {
          border-color: #1B4332;
          box-shadow: 0 0 0 2px rgba(27, 67, 50, 0.1);
        }
      `}</style>
    </div>
  );
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div>
      <label className="block text-sm font-medium text-gray-700 mb-1">{label}</label>
      {children}
    </div>
  );
}

function LangInput({
  label,
  value,
  onChange,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
}) {
  return (
    <div className="flex items-center gap-2">
      <span className="text-xs font-mono text-gray-400 w-5">{label}</span>
      <input
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="flex-1 border border-gray-200 rounded-lg px-3 py-1.5 text-sm outline-none focus:border-[#1B4332]"
      />
    </div>
  );
}

function LangTextarea({
  label,
  value,
  onChange,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
}) {
  return (
    <div className="flex gap-2">
      <span className="text-xs font-mono text-gray-400 w-5 pt-1.5">{label}</span>
      <textarea
        value={value}
        onChange={(e) => onChange(e.target.value)}
        rows={2}
        className="flex-1 border border-gray-200 rounded-lg px-3 py-1.5 text-sm outline-none focus:border-[#1B4332] resize-none"
      />
    </div>
  );
}
