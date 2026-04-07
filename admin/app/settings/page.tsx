'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { doc, onSnapshot, setDoc } from 'firebase/firestore';
import { firestore } from '@/lib/firebase';

interface ParkConfig {
  entryPrices: {
    adult: number;
    child_7_14: number;
    child_under_7: number;
    electric_vehicle: number;
    currency: string;
  };
  gondola: {
    adult: number;
    child: number;
    currency: string;
    operatingHours: { open: string; close: string };
    closedDay: string;
    cashlessOnly: boolean;
  };
  operatingHours: {
    office: { open: string; close: string };
    park: {
      summer: { open: string; close: string };
      winter: { open: string; close: string };
    };
  };
  contacts: {
    mainPhone: string;
    email: string;
    altEmail: string;
    checkpointPhone: string;
    address: string;
    marketing: string;
  };
  emergencyContacts: {
    parkRangers: string;
    mountainRescue: string;
    ambulance: string;
    police: string;
  };
  parkCapacity: number;
}

export default function SettingsPage() {
  const [config, setConfig] = useState<ParkConfig | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<string | null>(null);

  useEffect(() => {
    const unsub = onSnapshot(
      doc(firestore, 'park_config', 'settings'),
      (snap) => {
        if (snap.exists()) {
          setConfig(snap.data() as ParkConfig);
        }
        setLoading(false);
      }
    );
    return () => unsub();
  }, []);

  const save = async () => {
    if (!config) return;
    setSaving(true);
    try {
      await setDoc(doc(firestore, 'park_config', 'settings'), config);
      setToast('Settings saved');
      setTimeout(() => setToast(null), 2500);
    } catch (err) {
      setToast(`Error: ${err}`);
      setTimeout(() => setToast(null), 3000);
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center text-gray-500">
        Loading…
      </div>
    );
  }

  if (!config) {
    return (
      <div className="min-h-screen flex items-center justify-center text-gray-500">
        No park_config/settings found. Run the seed script first.
      </div>
    );
  }

  const u = (path: string, val: unknown) => {
    setConfig((prev) => {
      if (!prev) return prev;
      const copy = JSON.parse(JSON.stringify(prev));
      const parts = path.split('.');
      let obj = copy;
      for (let i = 0; i < parts.length - 1; i++) {
        obj = obj[parts[i]];
      }
      obj[parts[parts.length - 1]] = val;
      return copy;
    });
  };

  return (
    <div className="min-h-screen">
      <header className="bg-[#1B4332] text-white px-8 py-6">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div>
            <Link href="/" className="text-green-200 text-sm hover:underline">
              ← Dashboard
            </Link>
            <h1 className="text-2xl font-bold mt-1">Park Settings</h1>
            <p className="text-green-200 text-sm">
              Prices, hours, contacts — synced to app in real time
            </p>
          </div>
          <button
            onClick={save}
            disabled={saving}
            className="px-5 py-2.5 bg-white text-[#1B4332] rounded-lg font-medium hover:bg-green-50 disabled:opacity-50"
          >
            {saving ? 'Saving…' : 'Save All'}
          </button>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-8 py-8 space-y-8">
        {/* Entry Prices */}
        <Section title="Entry Prices (KGS)">
          <div className="grid grid-cols-2 gap-4">
            <NumberField label="Adult" value={config.entryPrices.adult} onChange={(v) => u('entryPrices.adult', v)} />
            <NumberField label="Child (7–14)" value={config.entryPrices.child_7_14} onChange={(v) => u('entryPrices.child_7_14', v)} />
            <NumberField label="Child under 7" value={config.entryPrices.child_under_7} onChange={(v) => u('entryPrices.child_under_7', v)} />
            <NumberField label="Electric Vehicle" value={config.entryPrices.electric_vehicle} onChange={(v) => u('entryPrices.electric_vehicle', v)} />
          </div>
        </Section>

        {/* Gondola */}
        <Section title="Gondola">
          <div className="grid grid-cols-2 gap-4">
            <NumberField label="Adult (KGS)" value={config.gondola.adult} onChange={(v) => u('gondola.adult', v)} />
            <NumberField label="Child (KGS)" value={config.gondola.child} onChange={(v) => u('gondola.child', v)} />
            <TextField label="Opens" value={config.gondola.operatingHours.open} onChange={(v) => u('gondola.operatingHours.open', v)} />
            <TextField label="Closes" value={config.gondola.operatingHours.close} onChange={(v) => u('gondola.operatingHours.close', v)} />
            <TextField label="Closed Day" value={config.gondola.closedDay} onChange={(v) => u('gondola.closedDay', v)} />
          </div>
        </Section>

        {/* Operating Hours */}
        <Section title="Operating Hours">
          <div className="grid grid-cols-2 gap-4">
            <TextField label="Office Opens" value={config.operatingHours.office.open} onChange={(v) => u('operatingHours.office.open', v)} />
            <TextField label="Office Closes" value={config.operatingHours.office.close} onChange={(v) => u('operatingHours.office.close', v)} />
            <TextField label="Park Summer Opens" value={config.operatingHours.park.summer.open} onChange={(v) => u('operatingHours.park.summer.open', v)} />
            <TextField label="Park Summer Closes" value={config.operatingHours.park.summer.close} onChange={(v) => u('operatingHours.park.summer.close', v)} />
            <TextField label="Park Winter Opens" value={config.operatingHours.park.winter.open} onChange={(v) => u('operatingHours.park.winter.open', v)} />
            <TextField label="Park Winter Closes" value={config.operatingHours.park.winter.close} onChange={(v) => u('operatingHours.park.winter.close', v)} />
          </div>
          <NumberField label="Park Max Capacity (daily)" value={config.parkCapacity} onChange={(v) => u('parkCapacity', v)} />
        </Section>

        {/* Contacts */}
        <Section title="Contact Information">
          <div className="grid grid-cols-2 gap-4">
            <TextField label="Main Phone" value={config.contacts.mainPhone} onChange={(v) => u('contacts.mainPhone', v)} />
            <TextField label="Checkpoint Phone" value={config.contacts.checkpointPhone} onChange={(v) => u('contacts.checkpointPhone', v)} />
            <TextField label="Email" value={config.contacts.email} onChange={(v) => u('contacts.email', v)} />
            <TextField label="Alt Email" value={config.contacts.altEmail} onChange={(v) => u('contacts.altEmail', v)} />
            <TextField label="Marketing Phone" value={config.contacts.marketing} onChange={(v) => u('contacts.marketing', v)} />
          </div>
          <TextField label="Address" value={config.contacts.address} onChange={(v) => u('contacts.address', v)} />
        </Section>

        {/* Emergency */}
        <Section title="Emergency Contacts">
          <div className="grid grid-cols-2 gap-4">
            <TextField label="Park Rangers" value={config.emergencyContacts.parkRangers} onChange={(v) => u('emergencyContacts.parkRangers', v)} />
            <TextField label="Mountain Rescue" value={config.emergencyContacts.mountainRescue} onChange={(v) => u('emergencyContacts.mountainRescue', v)} />
            <TextField label="Ambulance" value={config.emergencyContacts.ambulance} onChange={(v) => u('emergencyContacts.ambulance', v)} />
            <TextField label="Police" value={config.emergencyContacts.police} onChange={(v) => u('emergencyContacts.police', v)} />
          </div>
        </Section>
      </main>

      {toast && (
        <div className="fixed bottom-6 right-6 px-4 py-3 rounded-lg shadow-lg text-white bg-green-600">
          {toast}
        </div>
      )}
    </div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="bg-white rounded-xl border border-gray-200 p-6">
      <h3 className="text-base font-semibold text-gray-900 mb-4">{title}</h3>
      <div className="space-y-4">{children}</div>
    </div>
  );
}

function TextField({
  label,
  value,
  onChange,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
}) {
  return (
    <div>
      <label className="block text-sm text-gray-600 mb-1">{label}</label>
      <input
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm outline-none focus:border-[#1B4332]"
      />
    </div>
  );
}

function NumberField({
  label,
  value,
  onChange,
}: {
  label: string;
  value: number;
  onChange: (v: number) => void;
}) {
  return (
    <div>
      <label className="block text-sm text-gray-600 mb-1">{label}</label>
      <input
        type="number"
        value={value}
        onChange={(e) => onChange(Number(e.target.value))}
        className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm outline-none focus:border-[#1B4332]"
      />
    </div>
  );
}
