'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import {
  collection,
  deleteDoc,
  doc,
  onSnapshot,
  orderBy,
  query,
  Timestamp,
  updateDoc,
} from 'firebase/firestore';
import { firestore } from '@/lib/firebase';

interface Upload {
  id: string;
  telegramUsername: string;
  subjectType: string;
  subjectId: string | null;
  subjectName: string;
  fileUrl: string | null;
  caption: string;
  status: string;
  createdAt: Timestamp | null;
}

export default function UploadsPage() {
  const [uploads, setUploads] = useState<Upload[]>([]);
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState<string | null>(null);

  useEffect(() => {
    const q = query(
      collection(firestore, 'telegram_uploads'),
      orderBy('createdAt', 'desc')
    );
    const unsub = onSnapshot(q, (snap) => {
      setUploads(
        snap.docs.map((d) => ({ id: d.id, ...(d.data() as Omit<Upload, 'id'>) }))
      );
      setLoading(false);
    });
    return () => unsub();
  }, []);

  const handleDelete = async (upload: Upload) => {
    if (!confirm(`Delete upload from @${upload.telegramUsername}?`)) return;
    try {
      // Mark as deleted in Firestore
      await updateDoc(doc(firestore, 'telegram_uploads', upload.id), {
        status: 'deleted',
        deletedAt: Timestamp.now(),
      });

      // If attached to a subject, we'd also remove from images[] — but
      // that requires a callable function (client can't arrayRemove a
      // specific URL without knowing the full array). For now, mark deleted.
      setToast('Deleted');
      setTimeout(() => setToast(null), 2000);
    } catch (err) {
      setToast(`Error: ${err}`);
      setTimeout(() => setToast(null), 3000);
    }
  };

  const published = uploads.filter((u) => u.status === 'published');
  const deleted = uploads.filter((u) => u.status === 'deleted');

  return (
    <div className="min-h-screen">
      <header className="bg-[#1B4332] text-white px-8 py-6">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div>
            <Link href="/" className="text-green-200 text-sm hover:underline">
              ← Dashboard
            </Link>
            <h1 className="text-2xl font-bold mt-1">Telegram Uploads</h1>
            <p className="text-green-200 text-sm">
              Photos & documents sent by park workers via @AlaArchaParkBot
            </p>
          </div>
          <div className="text-right">
            <div className="text-sm">Published</div>
            <div className="text-3xl font-bold">{published.length}</div>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-8 py-8">
        {loading ? (
          <div className="text-gray-500">Loading…</div>
        ) : published.length === 0 ? (
          <div className="bg-white rounded-xl border p-12 text-center">
            <div className="text-4xl mb-3">📷</div>
            <div className="font-semibold text-gray-900">No uploads yet</div>
            <p className="text-sm text-gray-500 mt-1">
              Workers can send photos to @AlaArchaParkBot on Telegram.
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            {published.map((u) => (
              <UploadCard key={u.id} upload={u} onDelete={() => handleDelete(u)} />
            ))}
          </div>
        )}

        {deleted.length > 0 && (
          <details className="mt-12">
            <summary className="text-sm text-gray-500 cursor-pointer">
              {deleted.length} deleted upload{deleted.length > 1 ? 's' : ''}
            </summary>
            <div className="grid grid-cols-4 gap-4 mt-4 opacity-50">
              {deleted.map((u) => (
                <UploadCard key={u.id} upload={u} />
              ))}
            </div>
          </details>
        )}
      </main>

      {toast && (
        <div className="fixed bottom-6 right-6 px-4 py-3 rounded-lg shadow-lg text-white bg-green-600">
          {toast}
        </div>
      )}
    </div>
  );
}

function UploadCard({
  upload,
  onDelete,
}: {
  upload: Upload;
  onDelete?: () => void;
}) {
  const isDeleted = upload.status === 'deleted';
  return (
    <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
      {upload.fileUrl ? (
        <a href={upload.fileUrl} target="_blank" rel="noopener noreferrer">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={upload.fileUrl}
            alt={upload.subjectName}
            className="w-full h-40 object-cover"
          />
        </a>
      ) : (
        <div className="w-full h-40 bg-gray-100 flex items-center justify-center text-3xl">
          📄
        </div>
      )}
      <div className="p-3">
        <div className="flex items-center gap-2 mb-1">
          <span className="text-xs px-2 py-0.5 rounded bg-gray-100 text-gray-600">
            {upload.subjectType}
          </span>
          <span className="text-xs text-gray-400">
            @{upload.telegramUsername}
          </span>
        </div>
        <div className="text-sm font-medium text-gray-900 truncate">
          {upload.subjectName}
        </div>
        {upload.caption && (
          <div className="text-xs text-gray-500 mt-1 truncate">
            {upload.caption}
          </div>
        )}
        {upload.createdAt && (
          <div className="text-xs text-gray-400 mt-1">
            {upload.createdAt.toDate().toLocaleDateString()}
          </div>
        )}
        {onDelete && !isDeleted && (
          <button
            onClick={onDelete}
            className="mt-2 text-xs text-red-600 hover:text-red-800 font-medium"
          >
            Delete
          </button>
        )}
      </div>
    </div>
  );
}
