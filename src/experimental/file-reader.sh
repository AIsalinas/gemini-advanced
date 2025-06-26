#!/bin/bash
# Gemini Advanced - Experimental File Reader
# Adds file reading capability to Gemini CLI

# Create g.read command
cat > ~/.gemini-advanced/bin/g.read << 'EOF'
#!/bin/bash
# Read file and pass to Gemini with context

if [ $# -eq 0 ]; then
    echo "Usage: g.read <file> [question]"
    echo "Example: g.read server.js 'explain this code'"
    exit 1
fi

FILE="$1"
QUESTION="${2:-Explain this code:}"

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found"
    exit 1
fi

# Read file content
CONTENT=$(cat "$FILE" 2>/dev/null | head -500)  # Limit to 500 lines
FILE_INFO="File: $FILE ($(wc -l < "$FILE") lines)"

# Create prompt with file context
PROMPT="$FILE_INFO

\`\`\`$(basename "$FILE" | sed 's/.*\.//')
$CONTENT
\`\`\`

$QUESTION"

# Send to Gemini
gemini --project-doc ~/GEMINI.md --prompt "$PROMPT"
EOF

chmod +x ~/.gemini-advanced/bin/g.read

# Create g.analyze command
cat > ~/.gemini-advanced/bin/g.analyze << 'EOF'
#!/bin/bash
# Analyze multiple files

PATTERN="${1:-*.js}"
QUESTION="${2:-Analyze these files and find issues:}"

echo "🔍 Analyzing files matching: $PATTERN"
FILES=$(find . -name "$PATTERN" -type f 2>/dev/null | head -10)

if [ -z "$FILES" ]; then
    echo "No files found matching pattern: $PATTERN"
    exit 1
fi

# Build context from multiple files
CONTEXT="Project files analysis:"
for FILE in $FILES; do
    CONTEXT+="\n\n--- $FILE ---\n"
    CONTEXT+=$(head -50 "$FILE" 2>/dev/null)
done

echo "$CONTEXT" | gemini --project-doc ~/GEMINI.md --prompt "$QUESTION"
EOF

chmod +x ~/.gemini-advanced/bin/g.analyze

# Create g.edit command (preview only for safety)
cat > ~/.gemini-advanced/bin/g.edit << 'EOF'
#!/bin/bash
# AI-powered file editing with preview

if [ $# -lt 2 ]; then
    echo "Usage: g.edit <file> <change-description>"
    echo "Example: g.edit config.json 'add debug mode'"
    exit 1
fi

FILE="$1"
CHANGE="$2"

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found"
    exit 1
fi

CONTENT=$(cat "$FILE")

PROMPT="File: $FILE

Current content:
\`\`\`
$CONTENT
\`\`\`

Task: $CHANGE

Show the complete edited file content (not just changes):"

echo "🤖 Generating edit preview..."
RESULT=$(gemini --project-doc ~/GEMINI.md --prompt "$PROMPT" 2>/dev/null)

echo -e "\n📝 Preview of changes:\n"
echo "$RESULT"
echo -e "\n---"
read -p "Apply these changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Save backup
    cp "$FILE" "$FILE.backup"
    # This is where we'd apply changes - for now just show message
    echo "✅ Changes would be applied (backup saved as $FILE.backup)"
    echo "Note: Actual file writing not implemented in experimental version"
else
    echo "❌ Changes cancelled"
fi
EOF

chmod +x ~/.gemini-advanced/bin/g.edit

echo "✅ Experimental file features installed!"
echo ""
echo "New commands:"
echo "  g.read <file> [question]     - Read and analyze files"
echo "  g.analyze <pattern> [query]  - Analyze multiple files" 
echo "  g.edit <file> <description>  - Preview AI-powered edits"
echo ""
echo "Try: g.read package.json 'what does this project do?'"