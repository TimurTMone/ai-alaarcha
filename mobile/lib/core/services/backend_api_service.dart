import 'package:dio/dio.dart';

import '../constants/app_config.dart';
import '../models/announcement_model.dart';
import '../models/booking_model.dart';
import '../models/date_range.dart';
import '../models/service_model.dart';

class AiChatResponse {
  const AiChatResponse({
    required this.sessionId,
    required this.reply,
    this.booking,
  });

  final String sessionId;
  final String reply;
  final Booking? booking;

  factory AiChatResponse.fromApi(Map<String, dynamic> json) {
    final bookingJson = json['booking'];
    return AiChatResponse(
      sessionId: json['session_id']?.toString() ?? '',
      reply: json['reply']?.toString() ?? '',
      booking: bookingJson is Map
          ? Booking.fromApi(
              bookingJson.map((key, value) => MapEntry(key.toString(), value)),
            )
          : null,
    );
  }
}

class BackendApiService {
  BackendApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.backendBaseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
              responseType: ResponseType.json,
            ),
          );

  final Dio _dio;

  Future<List<Announcement>> fetchNews() async {
    final response = await _dio.get<Map<String, dynamic>>('/news/');
    final results = _results(response.data);
    return results.map(Announcement.fromApi).toList();
  }

  Future<List<Service>> fetchServices() async {
    final response = await _dio.get<Map<String, dynamic>>('/services/');
    final results = _results(response.data);
    return results.map(Service.fromApi).toList();
  }

  Future<List<DateRange>> fetchBookedRanges(String serviceId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/bookings/availability/',
      queryParameters: {'service': serviceId},
    );
    final results = _results(response.data, key: 'results');
    return results
        .map(
          (item) => DateRange(
            DateTime.parse(item['check_in'].toString()),
            DateTime.parse(item['check_out'].toString()),
          ),
        )
        .toList();
  }

  Future<Booking> createBooking({
    required Service service,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required int quantity,
    required String customerName,
    required String contactChannel,
    required String contactValue,
    String? note,
    int? totalPriceKgs,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/bookings/requests/',
      data: {
        'service_id': int.tryParse(service.id) ?? service.id,
        'check_in': _dateOnly(checkIn),
        'check_out': _dateOnly(checkOut),
        'guests': guests,
        'quantity': quantity,
        'customer_name': customerName,
        'contact_channel': contactChannel,
        'contact_value': contactValue,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
        if (totalPriceKgs != null && totalPriceKgs > 0)
          'total_price': totalPriceKgs.toString(),
        'currency': service.currency,
      },
    );

    return Booking.fromApi(response.data ?? const {}, fallbackService: service);
  }

  Future<AiChatResponse> sendAiChatMessage({
    required String sessionId,
    required String message,
    required String language,
    String? userName,
    String? contactValue,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/telegram/chat/',
      data: {
        'session_id': sessionId,
        'message': message,
        'language': language,
        if (userName != null && userName.trim().isNotEmpty)
          'user_name': userName.trim(),
        if (contactValue != null && contactValue.trim().isNotEmpty)
          'contact_value': contactValue.trim(),
      },
    );

    return AiChatResponse.fromApi(response.data ?? const {});
  }

  static List<Map<String, dynamic>> _results(
    Map<String, dynamic>? data, {
    String key = 'results',
  }) {
    final raw = data?[key] as List? ?? const [];
    return raw
        .whereType<Map>()
        .map((item) => item.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  static String _dateOnly(DateTime value) {
    final date = DateTime(value.year, value.month, value.day);
    return date.toIso8601String().split('T').first;
  }
}
