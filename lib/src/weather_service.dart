import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  WeatherService(this.apiKey);

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    try {
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'q': cityName,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'vi',
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        throw WeatherApiException(
          message: errorData['message'] ?? 'API Error',
          statusCode: response.statusCode,
          details: errorData,
        );
      }
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException(
        message: e.toString(),
        statusCode: 0,
        details: null,
      );
    }
  }
}

class WeatherApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? details;

  WeatherApiException({
    required this.message,
    required this.statusCode,
    this.details,
  });

  Map<String, dynamic> toJson() => {
        'error': true,
        'message': message,
        'statusCode': statusCode,
        'details': details,
      };

  @override
  String toString() => 'WeatherApiException: $message';
} 