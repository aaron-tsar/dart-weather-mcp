import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:dart_weather_mcp/dart_weather_mcp.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('city', abbr: 'c', help: 'Tên thành phố')
    ..addOption('api-key', abbr: 'k', help: 'OpenWeather API key')
    ..addFlag('help', abbr: 'h', help: 'Hiển thị trợ giúp', negatable: false)
    ..addFlag('json', abbr: 'j', help: 'Output JSON format', negatable: false)
    ..addFlag('pretty', abbr: 'p', help: 'Pretty output', negatable: false);

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      print('🌤️  Weather CLI Tool');
      print('');
      print('Usage: weather_cli --city "Hanoi" [options]');
      print('');
      print('Options:');
      print(parser.usage);
      print('');
      print('Examples:');
      print('  weather_cli -c "Hanoi"');
      print('  weather_cli -c "Ho Chi Minh" --json');
      print('  weather_cli -c "New York" --pretty');
      print('');
      print('Environment Variables:');
      print('  OPENWEATHER_API_KEY - Your OpenWeather API key');
      exit(0);
    }

    final apiKey = results['api-key'] as String? ?? 
                   Platform.environment['OPENWEATHER_API_KEY'];
    
    if (apiKey == null || apiKey.isEmpty) {
      stderr.writeln('❌ Lỗi: Chưa thiết lập API key');
      stderr.writeln('   Sử dụng: --api-key hoặc set OPENWEATHER_API_KEY');
      exit(1);
    }

    final cityName = results['city'] as String?;
    if (cityName == null || cityName.isEmpty) {
      stderr.writeln('❌ Lỗi: Chưa chỉ định tên thành phố');
      stderr.writeln('   Sử dụng: --city "Tên thành phố"');
      exit(1);
    }

    final weatherService = WeatherService(apiKey);
    
    print('🌤️  Đang lấy thời tiết cho $cityName...');
    
    final weather = await weatherService.getWeather(cityName);
    
    final isJson = results['json'] as bool;
    final isPretty = results['pretty'] as bool;
    
    if (isJson) {
      print(json.encode(weather));
    } else if (isPretty) {
      _printPrettyWeather(weather);
    } else {
      _printSimpleWeather(weather);
    }
    
  } catch (e) {
    if (e is WeatherApiException) {
      stderr.writeln('❌ Lỗi API: ${e.message}');
      if (e.statusCode == 404) {
        stderr.writeln('   Kiểm tra lại tên thành phố');
      } else if (e.statusCode == 401) {
        stderr.writeln('   Kiểm tra lại API key');
      }
    } else if (e is FormatException) {
      stderr.writeln('❌ Lỗi: Tham số không hợp lệ');
      stderr.writeln('   Sử dụng --help để xem hướng dẫn');
    } else {
      stderr.writeln('❌ Lỗi: $e');
    }
    exit(1);
  }
}

void _printSimpleWeather(Map<String, dynamic> weather) {
  print('📍 ${weather['name']}, ${weather['sys']['country']}');
  print('🌡️  ${weather['main']['temp']}°C (feels like ${weather['main']['feels_like']}°C)');
  print('🌤️  ${weather['weather'][0]['description']}');
  print('💧 Humidity: ${weather['main']['humidity']}%');
  print('💨 Wind: ${weather['wind']['speed']} m/s');
}

void _printPrettyWeather(Map<String, dynamic> weather) {
  print('');
  print('╔══════════════════════════════════════╗');
  print('║            🌤️  WEATHER INFO          ║');
  print('╠══════════════════════════════════════╣');
  print('║ 📍 Location: ${weather['name']}, ${weather['sys']['country']}'.padRight(37) + '║');
  print('║ 🌡️  Temperature: ${weather['main']['temp']}°C'.padRight(37) + '║');
  print('║ 🤔 Feels like: ${weather['main']['feels_like']}°C'.padRight(37) + '║');
  print('║ 📊 Min/Max: ${weather['main']['temp_min']}°C/${weather['main']['temp_max']}°C'.padRight(37) + '║');
  print('║ 🌤️  Condition: ${weather['weather'][0]['description']}'.padRight(37) + '║');
  print('║ 💧 Humidity: ${weather['main']['humidity']}%'.padRight(37) + '║');
  print('║ 🌬️  Pressure: ${weather['main']['pressure']} hPa'.padRight(37) + '║');
  print('║ 💨 Wind: ${weather['wind']['speed']} m/s'.padRight(37) + '║');
  if (weather['wind']['deg'] != null) {
    print('║ 🧭 Wind Direction: ${weather['wind']['deg']}°'.padRight(37) + '║');
  }
  print('╚══════════════════════════════════════╝');
  print('');
} 