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

### Cấu hình qua Stdio Interface (Universal)

Nhiều MCP clients hiện tại hỗ trợ thêm MCP server qua giao diện "Add MCP Server" hoặc "Choose the type of MCP server to add":

#### Bước 1: Chọn loại server
- Chọn **"Command (stdio)"** 
- Mô tả: "Run a local command that implements the MCP protocol"

#### Bước 2: Điền thông tin server

**Phiên bản Dart JIT (khuyến nghị cho development):**
```
Name/Identifier: Weather MCP
Command: dart
Arguments: run
             /Users/vuongha/cursor/dart-weather-mcp/bin/weather_mcp_server.dart
Environment Variables:
  Key: OPENWEATHER_API_KEY
  Value: your_api_key_here
Timeout: 600 (tùy chọn)
```

**Phiên bản Executable (nhanh hơn):**
```
Name/Identifier: Weather MCP  
Command: /Users/vuongha/cursor/dart-weather-mcp/weather_mcp_server
Arguments: (để trống)
Environment Variables:
  Key: OPENWEATHER_API_KEY
  Value: your_api_key_here
Timeout: 600 (tùy chọn)
```

#### Bước 3: Test kết nối
Sau khi add, server sẽ cung cấp tool `getWeather` với schema:
- **Input**: `cityName` (string) - Tên thành phố
- **Output**: Thông tin thời tiết chi tiết từ OpenWeather API

#### Clients hỗ trợ MCP stdio:
- ✅ **Claude Desktop** (Anthropic)
- ✅ **Cursor** (Anysphere) 
- ✅ **Continue.dev** (VS Code Extension)
- ✅ **Zed Editor**
- ✅ **Codeium Chat** (một số phiên bản)
- ❓ **GitHub Copilot Chat** (experimental - nếu có hỗ trợ MCP)
- ✅ Các clients khác implement MCP protocol

#### 📝 Ví dụ cấu hình cho GitHub Copilot (nếu hỗ trợ):
Nếu GitHub Copilot Chat có tính năng add MCP server:
```
Type: Command (stdio)
Server Name: Weather MCP
Command Path: /usr/local/bin/dart  
Arguments: run /Users/vuongha/cursor/dart-weather-mcp/bin/weather_mcp_server.dart
Environment:
  OPENWEATHER_API_KEY=<INPUT_YOUR_API_KEY_HERE>
```

*Lưu ý: GitHub Copilot hiện tại chưa hỗ trợ MCP protocol chính thức. Sử dụng CLI tool để tích hợp với VS Code.*

#### 🔧 Troubleshooting:

**Lỗi "Command not found":**
- Đảm bảo Dart SDK đã được cài đặt và có trong PATH
- Kiểm tra đường dẫn tuyệt đối: `which dart`
- Với executable: đảm bảo file đã được compile

**Lỗi "API Error":**
- Kiểm tra API key đã đúng chưa
- Đảm bảo environment variable được set đúng
- Test API key: `curl "https://api.openweathermap.org/data/2.5/weather?q=Hanoi&appid=YOUR_API_KEY"`

**Server không phản hồi:**
- Tăng timeout lên 600-1200 giây
- Kiểm tra logs của client
- Test server standalone: `dart run bin/weather_mcp_server.dart`

**Tips:**
- 💡 Sử dụng đường dẫn tuyệt đối để tránh lỗi
- 💡 Executable khởi động nhanh hơn ~2-3 giây so với JIT
- 💡 Environment variables có thể set global trong shell profile

### Cấu hình với Claude Desktop

Thêm vào file cấu hình Claude Desktop (`claude_desktop_config.json`):

### Sử dụng executable (khuyến nghị - nhanh hơn):
```json
{
  "mcpServers": {
    "dart-weather": {
      "command": "/Users/vuongha/cursor/dart-weather-mcp/weather_mcp_server",
      "env": {
        "OPENWEATHER_API_KEY": "your_api_key_here"
      },
      "timeout": 600
    }
  }
}
```

### Sử dụng Dart JIT:
```json
{
  "mcpServers": {
    "dart-weather": {
      "command": "dart",
      "args": ["run", "/Users/vuongha/cursor/dart-weather-mcp/bin/weather_mcp_server.dart"],
      "env": {
        "OPENWEATHER_API_KEY": "your_api_key_here"
      },
      "timeout": 600
    }
  }
}
```

### Cấu hình với Cursor MCP:
Thêm vào file `/Users/vuongha/.cursor/mcp.json`:
```json
{
  "mcpServers": {
    "Weather MCP (Dart)": {
      "command": "/Users/vuongha/cursor/dart-weather-mcp/weather_mcp_server",
      "env": {
        "OPENWEATHER_API_KEY": "YOUR_API_KEY_HERE"
      },
      "timeout": 600
    }
  }
}
```

## Sử dụng

### MCP Server
MCP server cung cấp tool `getWeather` với tham số:
- `cityName`: Tên thành phố (bắt buộc) - VD: "Hanoi", "Ho Chi Minh"

Server trả về thông tin thời tiết chi tiết bao gồm:
- Nhiệt độ hiện tại, cảm giác như, nhiệt độ min/max
- Độ ẩm, áp suất khí quyển
- Tốc độ và hướng gió
- Tình trạng thời tiết (mưa, nắng, mây...)
- Thời gian mặt trời mọc/lặn

### CLI Tool
Ngoài MCP server, bạn có thể sử dụng CLI tool để lấy thời tiết từ terminal:

#### Cài đặt CLI:
```bash
./install.sh
```

#### Sử dụng CLI:
```bash
# Lấy thời tiết cơ bản
weather "Hanoi"

# Output đẹp với khung
weather "Ho Chi Minh" --pretty  

# Output JSON
weather "New York" --json

# Trợ giúp
weather --help
```

#### Sử dụng trong VS Code/GitHub Copilot:
Sau khi cài đặt CLI, bạn có thể gọi từ terminal trong VS Code:
```bash
# Trong VS Code terminal
weather "Tokyo" --pretty
```

Hoặc tạo VS Code tasks trong `.vscode/tasks.json`:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Get Weather",
      "type": "shell",
      "command": "weather",
      "args": ["${input:cityName}", "--pretty"],
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    }
  ],
  "inputs": [
    {
      "id": "cityName",
      "description": "Enter city name",
      "default": "Hanoi",
      "type": "promptString"
    }
  ]
}
```

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