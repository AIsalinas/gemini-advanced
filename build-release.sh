#!/bin/bash
# Build release package for Gemini Advanced

echo "🔨 Building Gemini Advanced release package..."

# Copy all necessary files from existing installation
TOOL_DIR="$HOME/gemini-advanced-tool"

# Copy personas
echo "📁 Copying personas..."
cp -r ~/.gemini-advanced/personas/* "$TOOL_DIR/src/personas/" 2>/dev/null || true

# Copy all bin commands
echo "📁 Copying commands..."
for cmd in g gt gth gu g.arch g.front g.back g.debug g.sec g.perf g.qa g.teach g.help; do
    if [[ -f ~/.gemini-advanced/bin/$cmd ]]; then
        cp ~/.gemini-advanced/bin/$cmd "$TOOL_DIR/bin/"
        # Remove hardcoded paths
        sed -i.bak 's|/Users/[^/]*/|~/|g' "$TOOL_DIR/bin/$cmd"
        rm "$TOOL_DIR/bin/$cmd.bak"
    fi
done

# Create missing bin commands if needed
for cmd in gt gth gu g.help; do
    if [[ ! -f "$TOOL_DIR/bin/$cmd" ]]; then
        cp "$TOOL_DIR/bin/g" "$TOOL_DIR/bin/$cmd"
    fi
done

# Copy configuration
echo "📁 Copying configuration..."
cp ~/.gemini-advanced/config.yaml "$TOOL_DIR/src/" 2>/dev/null || true

# Make everything executable
chmod +x "$TOOL_DIR/bin/"* 2>/dev/null || true
chmod +x "$TOOL_DIR"/*.sh 2>/dev/null || true

echo "✅ Build complete!"
echo ""
echo "📦 Your Gemini Advanced tool is ready in: $TOOL_DIR"
echo ""
echo "Next steps:"
echo "1. Update README.md with your GitHub username"
echo "2. Create GitHub repository"
echo "3. Push to GitHub:"
echo "   cd $TOOL_DIR"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial release of Gemini Advanced'"
echo "   git remote add origin https://github.com/YOUR_USERNAME/gemini-advanced.git"
echo "   git push -u origin main"
echo ""
echo "4. Optional: Publish to npm:"
echo "   npm login"
echo "   npm publish"
echo ""
echo "🎉 Ready to share with the world!"