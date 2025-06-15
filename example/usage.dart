import 'dart:io';
import 'package:dart_weather_mcp/dart_weather_mcp.dart';

void main() async {
  final apiKey = Platform.environment['OPENWEATHER_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    print('Lỗi: Chưa thiết lập OPENWEATHER_API_KEY');
    exit(1);
  }

  final weatherService = WeatherService(apiKey);

  try {
    print('🌤️  Đang lấy thời tiết cho Hà Nội...');
    final weather = await weatherService.getWeather('Hanoi');
    
    print('📍 Thành phố: ${weather['name']}');
    print('🌡️  Nhiệt độ: ${weather['main']['temp']}°C');
    print('🌡️  Cảm giác như: ${weather['main']['feels_like']}°C');
    print('💧 Độ ẩm: ${weather['main']['humidity']}%');
    print('🌤️  Thời tiết: ${weather['weather'][0]['description']}');
    
  } catch (e) {
    if (e is WeatherApiException) {
      print('❌ Lỗi API: ${e.message}');
    } else {
      print('❌ Lỗi: $e');
    }
  }
} 