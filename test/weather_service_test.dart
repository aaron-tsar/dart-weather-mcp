import 'package:test/test.dart';
import 'package:dart_weather_mcp/dart_weather_mcp.dart';

void main() {
  group('WeatherService', () {
    late WeatherService weatherService;

    setUp(() {
      weatherService = WeatherService('test_api_key');
    });

    test('should create instance with api key', () {
      expect(weatherService.apiKey, equals('test_api_key'));
    });

    test('WeatherApiException should format error correctly', () {
      final exception = WeatherApiException(
        message: 'Test error',
        statusCode: 404,
        details: {'error': 'Not found'},
      );

      final json = exception.toJson();
      expect(json['error'], isTrue);
      expect(json['message'], equals('Test error'));
      expect(json['statusCode'], equals(404));
      expect(json['details'], equals({'error': 'Not found'}));
    });

    test('WeatherApiException toString should work', () {
      final exception = WeatherApiException(
        message: 'Test error',
        statusCode: 404,
      );

      expect(exception.toString(), equals('WeatherApiException: Test error'));
    });
  });
} 