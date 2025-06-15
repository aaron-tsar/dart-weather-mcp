#!/bin/bash

# Weather CLI Installation Script

echo "🌤️  Installing Weather CLI..."

INSTALL_DIR="$HOME/.local/bin"
CURRENT_DIR="$(pwd)"
WEATHER_CLI="$CURRENT_DIR/weather_cli"
WEATHER_SCRIPT="$CURRENT_DIR/weather"

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Check if compiled CLI exists
if [ ! -f "$WEATHER_CLI" ]; then
    echo "🔨 Compiling Weather CLI..."
    if ! dart compile exe bin/weather_cli.dart -o weather_cli; then
        echo "❌ Failed to compile Weather CLI"
        exit 1
    fi
fi

# Copy files
echo "📦 Installing files..."
cp "$WEATHER_CLI" "$INSTALL_DIR/weather"
chmod +x "$INSTALL_DIR/weather"

# Add to PATH if not already there
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "🔧 Adding to PATH..."
    
    # Detect shell
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi
    
    echo "" >> "$SHELL_RC"
    echo "# Weather CLI" >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
    
    echo "⚠️  Please run: source $SHELL_RC"
    echo "   Or restart your terminal"
fi

echo ""
echo "✅ Weather CLI installed successfully!"
echo ""
echo "🎯 Usage examples:"
echo "   weather \"Hanoi\""
echo "   weather \"Ho Chi Minh\" --pretty"
echo "   weather \"New York\" --json"
echo ""
echo "🔑 Don't forget to set your API key:"
echo "   export OPENWEATHER_API_KEY=\"your_api_key_here\""
echo ""
echo "📖 Get help:"
echo "   weather --help" 