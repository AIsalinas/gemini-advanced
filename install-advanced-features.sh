#!/bin/bash
# Install all advanced features for Gemini Advanced

echo "🚀 Installing Gemini Advanced - Next Generation Features"
echo "======================================================="
echo ""

# Check if Gemini Advanced is installed
if [ ! -d "$HOME/.gemini-advanced" ]; then
    echo "❌ Gemini Advanced not found. Please install base version first:"
    echo "curl -sSL https://raw.githubusercontent.com/tom28881/gemini-advanced/main/install.sh | bash"
    exit 1
fi

echo "📦 Installing advanced features..."
echo ""

# Feature installation functions
install_file_system() {
    echo "1️⃣ Installing Intelligent File System..."
    bash "$HOME/.gemini-advanced/src/experimental/intelligent-file-system.sh"
    echo "✅ File system features installed"
    echo ""
}

install_memory() {
    echo "2️⃣ Installing Persistent Memory System..."
    bash "$HOME/.gemini-advanced/src/experimental/persistent-memory.sh"
    echo "✅ Memory system installed"
    echo ""
}

install_execution() {
    echo "3️⃣ Installing Safe Command Execution..."
    bash "$HOME/.gemini-advanced/src/experimental/safe-command-execution.sh"
    echo "✅ Command execution installed"
    echo ""
}

install_router() {
    echo "4️⃣ Installing Intelligent Router..."
    bash "$HOME/.gemini-advanced/src/experimental/intelligent-router.sh"
    echo "✅ Smart routing installed"
    echo ""
}

# Install all features
install_file_system
install_memory
install_execution
install_router

# Test installation
echo "🧪 Testing installation..."
if command -v g.project &> /dev/null && \
   command -v g.remember &> /dev/null && \
   command -v g.run &> /dev/null && \
   command -v g.smart &> /dev/null; then
    echo "✅ All features installed successfully!"
else
    echo "⚠️  Some features may not be installed correctly"
fi

echo ""
echo "🎉 Gemini Advanced 2025 Features Ready!"
echo "======================================"
echo ""
echo "🚀 Quick Start:"
echo "  1. Initialize project: g.project init"
echo "  2. Try smart mode: g 'explain what this project does'"
echo "  3. Remember facts: g.remember 'uses PostgreSQL 15'"
echo "  4. Safe execution: g.run 'npm test' --explain"
echo ""
echo "📚 Full help: g.help"
echo ""
echo "💡 TIP: Just describe what you want naturally!"
echo "   g 'find all API endpoints and explain them'"