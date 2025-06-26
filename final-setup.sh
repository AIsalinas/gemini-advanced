#!/bin/bash
# Final setup for Gemini Advanced

echo "🚀 Finalizing Gemini Advanced setup..."

# Copy the final instructions
cp ~/GEMINI-FINAL.md ~/GEMINI.md

# Create the definitive wrapper
cat > ~/.gemini-advanced/bin/gemini-final << 'EOF'
#!/bin/bash
# Gemini Advanced - Final Version

# Check if expect is installed
if ! command -v expect &> /dev/null; then
    echo "Installing expect..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install expect
    else
        sudo apt-get install -y expect
    fi
fi

# Run Gemini with command injection
expect << 'EXPECT_SCRIPT'
set timeout -1

# Start gemini
spawn gemini

# Wait for prompt
expect ">"

# Send our system instructions
send "You are Gemini with enhanced command recognition. From now on, you MUST check every message for these patterns at the start: g.help (show commands), gt. (think mode), gth. (think hard), gu. (ultra think), g.arch (architect), g.debug (debugger), g.sec (security), g.front (frontend), g.back (backend), g.perf (performance), g.qa (QA), g.mentor (mentor). When you see these patterns, activate the corresponding mode. Acknowledge with: 'Gemini Advanced ready! Type g.help for commands.'\r"

# Wait for acknowledgment
expect ">"

# Now interact normally
interact
EXPECT_SCRIPT
EOF

chmod +x ~/.gemini-advanced/bin/gemini-final

# Update aliases
SHELL_CONFIG=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

# Clean up old aliases
sed -i.bak '/alias gemini=/d' "$SHELL_CONFIG"

# Add final alias
echo "" >> "$SHELL_CONFIG"
echo "# Gemini Advanced - Final" >> "$SHELL_CONFIG"
echo "alias gemini='gemini-final'" >> "$SHELL_CONFIG"

# Create a quick test
cat > ~/.gemini-advanced/test-final.sh << 'EOF'
#!/bin/bash
echo "Testing Gemini Advanced commands..."
echo ""
echo "Starting Gemini and sending test commands..."

expect << 'TEST_SCRIPT'
set timeout 10

spawn gemini-final
expect "ready"

# Test g.help
send "g.help\r"
expect ">"
sleep 1

# Test think mode
send "gt. what is 2+2\r"
expect "THINK MODE"
expect ">"

send "exit\r"
TEST_SCRIPT

echo "✅ Test complete!"
EOF

chmod +x ~/.gemini-advanced/test-final.sh

echo ""
echo "✅ Final setup complete!"
echo ""
echo "To use:"
echo "1. source $SHELL_CONFIG"
echo "2. gemini"
echo ""
echo "Then try:"
echo "  g.help"
echo "  gt. explain something"
echo "  gu. design a system"
echo ""
echo "Test: ~/.gemini-advanced/test-final.sh"