#!/bin/bash

# Set your OpenWeather API key here
export OPENWEATHER_API_KEY="your_api_key_here"

echo "🌤️  Running Dart Weather MCP Example..."
echo "📝 Make sure to set your OPENWEATHER_API_KEY environment variable"
echo "🔑 Current API Key: ${OPENWEATHER_API_KEY}"
echo ""

if [ "$OPENWEATHER_API_KEY" = "your_api_key_here" ]; then
    echo "❌ Please set your actual OpenWeather API key in this script or as environment variable"
    echo "   Get your key from: https://openweathermap.org/api"
    exit 1
fi

echo "🚀 Running weather service example..."
dart run example/usage.dart 