# Dart Weather MCP Server

Server MCP lấy thông tin thời tiết từ OpenWeather API, được viết bằng Dart sử dụng [mcp_dart](https://pub.dev/packages/mcp_dart).

## Yêu cầu

- Dart SDK >= 3.0.0
- API key từ [OpenWeatherMap](https://openweathermap.org/api)

## Cài đặt

```bash
dart pub get
```

## Cấu hình

Thiết lập environment variable với API key:

```bash
export OPENWEATHER_API_KEY=your_openweather_api_key_here
```

Hoặc trên Windows:
```cmd
set OPENWEATHER_API_KEY=your_openweather_api_key_here
```

## Chạy server

### Chạy trực tiếp với Dart:
```bash
dart run bin/weather_mcp_server.dart
```

### Compile và chạy executable:
```bash
dart compile exe bin/weather_mcp_server.dart -o weather_mcp_server
./weather_mcp_server
```

## Cấu hình MCP Server

### Cấu hình cho GitHub Copilot

Trong dialog "Enter Command", nhập:

```
env OPENWEATHER_API_KEY=your_api_key_here dart run /Users/vuongha/cursor/dart-weather-mcp/bin/weather_mcp_server.dart
```

*💡 Lưu ý: Thay `your_api_key_here` bằng API key thực tế và `/Users/vuongha/cursor/dart-weather-mcp/` bằng đường dẫn thực tế đến repo của bạn*



## Sử dụng

MCP server cung cấp tool `getWeather` với tham số:
- `cityName`: Tên thành phố (bắt buộc) - VD: "Hanoi", "Ho Chi Minh"

Server trả về thông tin thời tiết chi tiết bao gồm:
- Nhiệt độ hiện tại, cảm giác như, nhiệt độ min/max
- Độ ẩm, áp suất khí quyển
- Tốc độ và hướng gió
- Tình trạng thời tiết (mưa, nắng, mây...)
- Thời gian mặt trời mọc/lặn

## Cấu trúc dự án

```
dart-weather-mcp/
├── bin/
│   └── weather_mcp_server.dart    # Entry point chính
├── lib/
│   ├── dart_weather_mcp.dart      # Library export
│   └── src/
│       └── weather_service.dart   # Service gọi OpenWeather API
├── pubspec.yaml                   # Dependencies
└── README.md
```

## Phát triển

Chạy tests:
```bash
dart test
```

Format code:
```bash
dart format .
```

Analyze code:
```bash
dart analyze
``` 
