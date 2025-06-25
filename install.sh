#!/bin/bash
# Gemini Advanced - Universal Installer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.gemini-advanced"
REPO_URL="https://github.com/tom28881/gemini-advanced.git"
VERSION="1.0.0"

# Functions
print_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║       🚀 Gemini Advanced v$VERSION      ║"
    echo "║   Enhanced AI Assistant for Gemini    ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

check_requirements() {
    echo -e "${YELLOW}Checking requirements...${NC}"
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js not found!${NC}"
        echo "Please install Node.js 18+ first: https://nodejs.org"
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        echo -e "${RED}❌ Node.js version must be 18 or higher${NC}"
        exit 1
    fi
    
    # Check Gemini CLI
    if ! command -v gemini &> /dev/null; then
        echo -e "${YELLOW}⚠️  Gemini CLI not found${NC}"
        read -p "Install Gemini CLI now? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing Gemini CLI..."
            npm install -g @google/gemini-cli
        else
            echo -e "${RED}Gemini CLI is required. Install with: npm install -g @google/gemini-cli${NC}"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}✅ All requirements met${NC}"
}

backup_existing() {
    if [ -d "$INSTALL_DIR" ]; then
        echo -e "${YELLOW}Backing up existing installation...${NC}"
        BACKUP_DIR="$INSTALL_DIR.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$INSTALL_DIR" "$BACKUP_DIR"
        echo -e "${GREEN}✅ Backup created at: $BACKUP_DIR${NC}"
    fi
}

download_and_install() {
    echo -e "${YELLOW}Installing Gemini Advanced...${NC}"
    
    # Create directories
    mkdir -p "$INSTALL_DIR"/{bin,personas,memory,templates,workflows,docs}
    
    # Download from GitHub or copy from current directory
    if [ -f "./src/GEMINI.md" ]; then
        # Installing from local repository
        echo "Installing from local files..."
        cp -r ./src/* "$INSTALL_DIR/"
        cp -r ./bin/* "$INSTALL_DIR/bin/" 2>/dev/null || true
        cp -r ./personas/* "$INSTALL_DIR/personas/" 2>/dev/null || true
    else
        # Download from GitHub
        echo "Downloading from GitHub..."
        TEMP_DIR=$(mktemp -d)
        git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
            echo -e "${YELLOW}Using fallback download method...${NC}"
            curl -L "https://github.com/yourusername/gemini-advanced/archive/main.tar.gz" | tar xz -C "$TEMP_DIR" --strip-components=1
        }
        cp -r "$TEMP_DIR/src"/* "$INSTALL_DIR/"
        cp -r "$TEMP_DIR/bin"/* "$INSTALL_DIR/bin/" 2>/dev/null || true
        cp -r "$TEMP_DIR/personas"/* "$INSTALL_DIR/personas/" 2>/dev/null || true
        rm -rf "$TEMP_DIR"
    fi
    
    # Copy GEMINI.md to home directory
    cp "$INSTALL_DIR/GEMINI.md" "$HOME/GEMINI.md" 2>/dev/null || true
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR"/bin/* 2>/dev/null || true
    chmod +x "$INSTALL_DIR"/*.sh 2>/dev/null || true
    
    echo -e "${GREEN}✅ Installation complete${NC}"
}

setup_shell_integration() {
    echo -e "${YELLOW}Setting up shell integration...${NC}"
    
    # Detect shell
    SHELL_CONFIG=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        SHELL_CONFIG="$HOME/.bashrc"
    else
        echo -e "${YELLOW}⚠️  Unknown shell. Please add manually to your shell config:${NC}"
        echo 'export PATH="$HOME/.gemini-advanced/bin:$PATH"'
        echo 'alias gemini="gemini --project-doc ~/GEMINI.md"'
        return
    fi
    
    # Add to PATH
    if ! grep -q "gemini-advanced/bin" "$SHELL_CONFIG" 2>/dev/null; then
        echo "" >> "$SHELL_CONFIG"
        echo "# Gemini Advanced" >> "$SHELL_CONFIG"
        echo 'export PATH="$HOME/.gemini-advanced/bin:$PATH"' >> "$SHELL_CONFIG"
    fi
    
    # Add Gemini alias
    if ! grep -q "alias gemini=" "$SHELL_CONFIG" 2>/dev/null; then
        echo 'alias gemini="gemini --project-doc ~/GEMINI.md"' >> "$SHELL_CONFIG"
    fi
    
    echo -e "${GREEN}✅ Shell integration configured${NC}"
}

create_uninstaller() {
    cat > "$INSTALL_DIR/uninstall.sh" << 'EOF'
#!/bin/bash
# Gemini Advanced Uninstaller

echo "Uninstalling Gemini Advanced..."

# Remove installation directory
rm -rf "$HOME/.gemini-advanced"

# Remove GEMINI.md
rm -f "$HOME/GEMINI.md"

# Remove from shell config
for config in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$config" ]; then
        # Remove PATH export
        sed -i.bak '/gemini-advanced\/bin/d' "$config"
        # Remove alias
        sed -i.bak '/alias gemini=/d' "$config"
        # Remove section header
        sed -i.bak '/# Gemini Advanced/d' "$config"
    fi
done

echo "✅ Gemini Advanced has been uninstalled"
echo "Please restart your terminal or run: source ~/.zshrc"
EOF
    chmod +x "$INSTALL_DIR/uninstall.sh"
}

test_installation() {
    echo -e "${YELLOW}Testing installation...${NC}"
    
    export PATH="$HOME/.gemini-advanced/bin:$PATH"
    
    if command -v g &> /dev/null; then
        echo -e "${GREEN}✅ Installation successful!${NC}"
        return 0
    else
        echo -e "${RED}❌ Installation test failed${NC}"
        return 1
    fi
}

print_success() {
    echo
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║        🎉 Gemini Advanced Installed Successfully!      ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo
    echo "📝 Next steps:"
    echo "1. Restart your terminal or run: source $SHELL_CONFIG"
    echo "2. Test with: g.help"
    echo "3. Try: gemini (then use g.help inside)"
    echo
    echo "🚀 Quick examples:"
    echo "   g 'What is Docker?'           # Quick answer"
    echo "   gt 'Analyze this error'       # Detailed analysis"
    echo "   gu 'Design payment system'    # Exhaustive analysis"
    echo "   g.debug 'Why API fails'       # Debug persona"
    echo
    echo "📚 Full documentation: https://github.com/yourusername/gemini-advanced"
    echo
}

# Main installation flow
main() {
    print_banner
    check_requirements
    backup_existing
    download_and_install
    setup_shell_integration
    create_uninstaller
    
    if test_installation; then
        print_success
    else
        echo -e "${RED}Installation completed with warnings. Please check the output above.${NC}"
        exit 1
    fi
}

# Run main function
main "$@"