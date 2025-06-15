import 'dart:convert';
import 'dart:io';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:dart_weather_mcp/dart_weather_mcp.dart';

void main() async {
  final apiKey = Platform.environment['OPENWEATHER_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('Lỗi: Chưa thiết lập OPENWEATHER_API_KEY trong environment variables');
    exit(1);
  }

  final weatherService = WeatherService(apiKey);

  final server = McpServer(
    Implementation(name: 'Weather MCP Server', version: '1.0.0'),
    options: ServerOptions(
      capabilities: ServerCapabilities(
        tools: ServerCapabilitiesTools(),
      ),
    ),
  );

  server.tool(
    'getWeather',
    description: 'Lấy thông tin thời tiết theo tên thành phố (sử dụng OpenWeather API)',
    inputSchemaProperties: {
      'cityName': {
        'type': 'string',
        'description': 'Tên thành phố (VD: Hanoi, Ho Chi Minh)',
      },
    },
    callback: ({args, extra}) async {
      try {
        final cityName = args?['cityName'] as String?;
        if (cityName == null || cityName.isEmpty) {
          return CallToolResult.fromContent(
            content: [
              TextContent(
                text: json.encode({
                  'error': true,
                  'message': 'Tham số cityName là bắt buộc',
                }),
              ),
            ],
          );
        }

        final weatherData = await weatherService.getWeather(cityName);
        
        return CallToolResult.fromContent(
          content: [
            TextContent(
              text: json.encode(weatherData),
            ),
          ],
        );
      } catch (e) {
        String errorResponse;
        if (e is WeatherApiException) {
          errorResponse = json.encode(e.toJson());
        } else {
          errorResponse = json.encode({
            'error': true,
            'message': e.toString(),
          });
        }

        return CallToolResult.fromContent(
          content: [
            TextContent(text: errorResponse),
          ],
        );
      }
    },
  );

  await server.connect(StdioServerTransport());
} 