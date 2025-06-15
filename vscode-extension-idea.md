# VS Code Extension Idea for Weather

## Concept
Create a VS Code extension that integrates with our Dart Weather MCP server.

## Implementation Options:

### Option 1: Direct API Integration
- Call OpenWeather API directly from VS Code extension
- No need for MCP server
- Use VS Code's built-in commands and UI

### Option 2: MCP Bridge
- Create a bridge between VS Code and MCP server
- Extension spawns our Dart MCP server as child process
- Communicate via stdio

## VS Code Extension Structure:
```
weather-extension/
├── package.json
├── src/
│   ├── extension.ts
│   ├── weatherService.ts
│   └── mcpBridge.ts
├── commands/
│   └── getWeather.ts
└── README.md
```

## Commands to implement:
- `weather.getWeather` - Get weather for current location
- `weather.getWeatherForCity` - Get weather for specific city
- `weather.insertWeather` - Insert weather info at cursor

## UI Integration:
- Status bar weather widget
- Command palette integration
- Hover providers for city names 