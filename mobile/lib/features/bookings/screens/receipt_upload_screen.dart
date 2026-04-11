import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/booking_provider.dart';

class ReceiptUploadScreen extends ConsumerStatefulWidget {
  const ReceiptUploadScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<ReceiptUploadScreen> createState() =>
      _ReceiptUploadScreenState();
}

class _ReceiptUploadScreenState extends ConsumerState<ReceiptUploadScreen> {
  File? _selectedFile;
  bool _uploading = false;
  double _progress = 0;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 2400,
      imageQuality: 85,
    );
    if (picked == null) return;

    final compressed = await _compress(File(picked.path));
    setState(() => _selectedFile = compressed);
  }

  Future<File> _compress(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 78,
      minWidth: 1600,
      minHeight: 1600,
    );
    return result != null ? File(result.path) : file;
  }

  Future<void> _submit() async {
    if (_selectedFile == null) return;
    final booking = ref.read(bookingByIdProvider(widget.bookingId));
    if (booking == null) return;

    setState(() {
      _uploading = true;
      _progress = 0;
    });

    try {
      String downloadUrl;

      if (AppConfig.devMode) {
        // Simulate upload progress.
        for (var i = 1; i <= 10; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 120));
          if (!mounted) return;
          setState(() => _progress = i / 10);
        }
        downloadUrl = 'devmode://local/${_selectedFile!.path.split('/').last}';
      } else {
        final storageRef = FirebaseStorage.instance.ref(
          'receipts/${booking.userId}/${booking.id}.jpg',
        );
        final task = storageRef.putFile(
          _selectedFile!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        task.snapshotEvents.listen((snap) {
          if (!mounted) return;
          setState(
            () => _progress =
                snap.bytesTransferred / snap.totalBytes.clamp(1, 1 << 30),
          );
        });
        final snap = await task;
        downloadUrl = await snap.ref.getDownloadURL();
      }

      if (AppConfig.devMode || AppConfig.useBackendBookings) {
        ref
            .read(devBookingsProvider.notifier)
            .update(
              booking.id,
              (b) => b.copyWith(
                status: BookingStatus.pendingVerification,
                receiptUrl: downloadUrl,
              ),
            );
      } else {
        await ref
            .read(firestoreServiceProvider)
            .updateBooking(
              booking.id,
              status: BookingStatus.pendingVerification,
              receiptUrl: downloadUrl,
            );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _successLabel(Localizations.localeOf(context).languageCode),
          ),
        ),
      );
      context.go('/bookings/${booking.id}');
    } catch (e) {
      if (!mounted) return;
      setState(() => _uploading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final booking = ref.watch(bookingByIdProvider(widget.bookingId));

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_titleLabel(locale))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Booking summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_refLabel(locale)} ${booking.shortRef}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${booking.totalPriceKgs} KGS',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_selectedFile == null) ...[
            _PickerTile(
              icon: Icons.camera_alt,
              label: _takePhotoLabel(locale),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 12),
            _PickerTile(
              icon: Icons.photo_library,
              label: _galleryLabel(locale),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ] else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _selectedFile!,
                height: 380,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            if (_uploading) ...[
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _uploading
                        ? null
                        : () => setState(() => _selectedFile = null),
                    icon: const Icon(Icons.refresh),
                    label: Text(_retakeLabel(locale)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _uploading ? null : _submit,
                    icon: const Icon(Icons.cloud_upload),
                    label: Text(_submitLabel(locale)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _hintLabel(locale),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _titleLabel(String l) =>
      {'en': 'Upload Receipt', 'ru': 'Загрузка чека', 'ky': 'Чек жүктөө'}[l] ??
      'Загрузка чека';
  static String _takePhotoLabel(String l) =>
      {
        'en': 'Take a photo',
        'ru': 'Сфотографировать',
        'ky': 'Сүрөткө тартуу',
      }[l] ??
      'Сфотографировать';
  static String _galleryLabel(String l) =>
      {
        'en': 'Choose from gallery',
        'ru': 'Выбрать из галереи',
        'ky': 'Галереядан тандоо',
      }[l] ??
      'Выбрать из галереи';
  static String _retakeLabel(String l) =>
      {'en': 'Retake', 'ru': 'Заново', 'ky': 'Кайра'}[l] ?? 'Заново';
  static String _submitLabel(String l) =>
      {'en': 'Submit', 'ru': 'Отправить', 'ky': 'Жөнөтүү'}[l] ?? 'Отправить';
  static String _refLabel(String l) =>
      {'en': 'Ref', 'ru': 'Код', 'ky': 'Код'}[l] ?? 'Код';
  static String _successLabel(String l) =>
      {
        'en': 'Receipt uploaded — AI is verifying now',
        'ru': 'Чек загружен — AI проверяет',
        'ky': 'Чек жүктөлдү — AI текшерүүдө',
      }[l] ??
      'Чек загружен';
  static String _hintLabel(String l) =>
      {
        'en':
            'Make sure the amount, date, and reference code are clearly visible on the receipt.',
        'ru': 'Убедитесь, что сумма, дата и код оплаты чётко видны на чеке.',
        'ky': 'Чекте сумма, күн жана төлөм коду так көрүнүп турсун.',
      }[l] ??
      '';
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
