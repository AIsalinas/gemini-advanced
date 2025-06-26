#!/bin/bash
# Gemini Advanced - Intelligent File System
# Project-aware file reading and analysis

GEMINI_PROJECT_DIR="$HOME/.gemini-advanced/projects"
CURRENT_PROJECT_CACHE="$GEMINI_PROJECT_DIR/current"

# Ensure directories exist
mkdir -p "$GEMINI_PROJECT_DIR"
mkdir -p "$CURRENT_PROJECT_CACHE"

# g.project - Project management
cat > ~/.gemini-advanced/bin/g.project << 'EOF'
#!/bin/bash
# Project initialization and management

GEMINI_PROJECT_DIR="$HOME/.gemini-advanced/projects"
CURRENT_PROJECT_CACHE="$GEMINI_PROJECT_DIR/current"

case "$1" in
    init)
        echo "🔍 Initializing project analysis..."
        PROJECT_ROOT="${2:-$(pwd)}"
        
        # Create project metadata
        cat > "$CURRENT_PROJECT_CACHE/metadata.json" << METADATA
{
    "root": "$PROJECT_ROOT",
    "name": "$(basename "$PROJECT_ROOT")",
    "indexed_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "files_count": 0,
    "primary_language": "",
    "framework": ""
}
METADATA
        
        # Index project structure
        echo "📁 Indexing project structure..."
        find "$PROJECT_ROOT" -type f \
            -not -path "*/node_modules/*" \
            -not -path "*/.git/*" \
            -not -path "*/dist/*" \
            -not -path "*/build/*" \
            -not -path "*/.next/*" \
            -not -path "*/coverage/*" \
            -not -name "*.log" \
            -not -name "*.lock" \
            | head -1000 > "$CURRENT_PROJECT_CACHE/file_index.txt"
        
        FILE_COUNT=$(wc -l < "$CURRENT_PROJECT_CACHE/file_index.txt")
        echo "✅ Indexed $FILE_COUNT files"
        
        # Detect project type
        if [ -f "$PROJECT_ROOT/package.json" ]; then
            echo "📦 Detected: Node.js project"
            cp "$PROJECT_ROOT/package.json" "$CURRENT_PROJECT_CACHE/package.json"
            
            # Extract key info
            FRAMEWORK=""
            if grep -q "react" "$PROJECT_ROOT/package.json"; then
                FRAMEWORK="React"
            elif grep -q "vue" "$PROJECT_ROOT/package.json"; then
                FRAMEWORK="Vue"
            elif grep -q "angular" "$PROJECT_ROOT/package.json"; then
                FRAMEWORK="Angular"
            elif grep -q "express" "$PROJECT_ROOT/package.json"; then
                FRAMEWORK="Express"
            fi
            
            [ -n "$FRAMEWORK" ] && echo "🚀 Framework: $FRAMEWORK"
        fi
        
        # Create import map for JS/TS projects
        echo "🔗 Analyzing imports..."
        grep -h "^import\|^const.*require" $(find "$PROJECT_ROOT" -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" 2>/dev/null | head -100) 2>/dev/null \
            | sort | uniq > "$CURRENT_PROJECT_CACHE/imports.txt"
        
        echo "✅ Project initialized! Use 'g.find' to search or 'g.deps' to analyze"
        ;;
        
    info)
        if [ -f "$CURRENT_PROJECT_CACHE/metadata.json" ]; then
            echo "📊 Current project info:"
            cat "$CURRENT_PROJECT_CACHE/metadata.json" | python3 -m json.tool
        else
            echo "❌ No project initialized. Run: g.project init"
        fi
        ;;
        
    clear)
        rm -rf "$CURRENT_PROJECT_CACHE"/*
        echo "🧹 Project cache cleared"
        ;;
        
    *)
        echo "Usage: g.project <command>"
        echo "Commands:"
        echo "  init [path]  - Initialize project analysis"
        echo "  info         - Show project information"
        echo "  clear        - Clear project cache"
        ;;
esac
EOF

# g.find - Intelligent file search
cat > ~/.gemini-advanced/bin/g.find << 'EOF'
#!/bin/bash
# Smart search across project files

CURRENT_PROJECT_CACHE="$HOME/.gemini-advanced/projects/current"

if [ ! -f "$CURRENT_PROJECT_CACHE/file_index.txt" ]; then
    echo "❌ No project initialized. Run: g.project init"
    exit 1
fi

SEARCH_TERM="$1"
QUESTION="${2:-Explain what you found:}"

if [ -z "$SEARCH_TERM" ]; then
    echo "Usage: g.find <search-term> [question]"
    echo "Example: g.find 'UserService' 'how does authentication work?'"
    exit 1
fi

echo "🔍 Searching for: $SEARCH_TERM"

# Search in filenames first
FILE_MATCHES=$(grep -i "$SEARCH_TERM" "$CURRENT_PROJECT_CACHE/file_index.txt" | head -10)

# Search in file contents
CONTENT_MATCHES=$(grep -r "$SEARCH_TERM" \
    --include="*.js" --include="*.ts" --include="*.jsx" --include="*.tsx" \
    --include="*.py" --include="*.java" --include="*.go" \
    --exclude-dir=node_modules --exclude-dir=.git \
    "$(head -1 "$CURRENT_PROJECT_CACHE/file_index.txt" | xargs dirname | sort -u)" 2>/dev/null \
    | head -20)

# Build context for Gemini
CONTEXT="Project search results for: $SEARCH_TERM

Files containing the term:
$FILE_MATCHES

Code matches:
$CONTENT_MATCHES

$QUESTION"

# Send to Gemini with context
echo "$CONTEXT" | gemini --prompt "$(<&0)"
EOF

# g.deps - Dependency analyzer
cat > ~/.gemini-advanced/bin/g.deps << 'EOF'
#!/bin/bash
# Analyze project dependencies

CURRENT_PROJECT_CACHE="$HOME/.gemini-advanced/projects/current"

case "$1" in
    analyze)
        if [ -f "$CURRENT_PROJECT_CACHE/package.json" ]; then
            echo "📦 Analyzing dependencies..."
            
            DEPS=$(cat "$CURRENT_PROJECT_CACHE/package.json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
deps = data.get('dependencies', {})
dev_deps = data.get('devDependencies', {})
print(f'Production: {len(deps)}')
print(f'Development: {len(dev_deps)}')
print('\nKey dependencies:')
for dep in list(deps.keys())[:10]:
    print(f'  - {dep}: {deps[dep]}')
")
            echo "$DEPS"
            
            # Check for security issues
            echo -e "\n🔒 Security check:"
            QUESTION="Analyze these dependencies for known security issues or outdated versions: $(cat "$CURRENT_PROJECT_CACHE/package.json" | head -50)"
            echo "$QUESTION" | gemini --prompt "$(<&0)"
        else
            echo "❌ No package.json found. Is this a Node.js project?"
        fi
        ;;
        
    tree)
        echo "🌳 Import tree:"
        if [ -f "$CURRENT_PROJECT_CACHE/imports.txt" ]; then
            cat "$CURRENT_PROJECT_CACHE/imports.txt" | head -30
            TOTAL=$(wc -l < "$CURRENT_PROJECT_CACHE/imports.txt")
            echo "... and $((TOTAL - 30)) more imports"
        else
            echo "❌ No imports indexed. Run: g.project init"
        fi
        ;;
        
    check)
        FILE="$2"
        if [ -z "$FILE" ]; then
            echo "Usage: g.deps check <file>"
            exit 1
        fi
        
        echo "🔍 Checking dependencies for: $FILE"
        IMPORTS=$(grep "^import\|require(" "$FILE" 2>/dev/null)
        
        PROMPT="Analyze these imports and suggest optimizations or issues:
        
File: $FILE
Imports:
$IMPORTS

Check for:
1. Unused imports
2. Missing dependencies
3. Circular dependencies
4. Performance issues"

        echo "$PROMPT" | gemini --prompt "$(<&0)"
        ;;
        
    *)
        echo "Usage: g.deps <command>"
        echo "Commands:"
        echo "  analyze      - Analyze package.json dependencies"
        echo "  tree         - Show import tree"
        echo "  check <file> - Check file dependencies"
        ;;
esac
EOF

# g.context - Smart context builder
cat > ~/.gemini-advanced/bin/g.context << 'EOF'
#!/bin/bash
# Build intelligent context from project

CURRENT_PROJECT_CACHE="$HOME/.gemini-advanced/projects/current"

if [ ! -f "$CURRENT_PROJECT_CACHE/file_index.txt" ]; then
    echo "❌ No project initialized. Run: g.project init"
    exit 1
fi

# Get related files based on imports
build_context() {
    local FILE="$1"
    local DEPTH="${2:-1}"
    
    echo "=== $FILE ==="
    head -50 "$FILE" 2>/dev/null
    
    if [ "$DEPTH" -gt 0 ]; then
        # Find imports in this file
        IMPORTS=$(grep -E "^import.*from ['\"]\.|require\(['\"]\." "$FILE" 2>/dev/null | sed -E "s/.*from ['\"](.+)['\"].*/\1/" | sed -E "s/.*require\(['\"](.+)['\"]\).*/\1/")
        
        for IMPORT in $IMPORTS; do
            # Resolve relative import
            IMPORT_PATH=$(dirname "$FILE")/"$IMPORT"
            if [ -f "$IMPORT_PATH.js" ]; then
                build_context "$IMPORT_PATH.js" $((DEPTH - 1))
            elif [ -f "$IMPORT_PATH.ts" ]; then
                build_context "$IMPORT_PATH.ts" $((DEPTH - 1))
            elif [ -f "$IMPORT_PATH/index.js" ]; then
                build_context "$IMPORT_PATH/index.js" $((DEPTH - 1))
            fi
        done
    fi
}

FILE="$1"
QUESTION="${2:-Analyze this code:}"

if [ -z "$FILE" ]; then
    echo "Usage: g.context <file> [question]"
    echo "Builds smart context including related files"
    exit 1
fi

echo "🧠 Building context for: $FILE"
CONTEXT=$(build_context "$FILE" 1)

PROMPT="$QUESTION

Context includes the main file and its direct imports:

$CONTEXT"

echo "$PROMPT" | gemini --prompt "$(<&0)"
EOF

# Make all scripts executable
chmod +x ~/.gemini-advanced/bin/g.project
chmod +x ~/.gemini-advanced/bin/g.find
chmod +x ~/.gemini-advanced/bin/g.deps
chmod +x ~/.gemini-advanced/bin/g.context

echo "✅ Intelligent File System installed!"
echo ""
echo "🚀 New commands:"
echo "  g.project init       - Index current project"
echo "  g.project info       - Show project information"
echo "  g.find <term>        - Search across project"
echo "  g.deps analyze       - Analyze dependencies"
echo "  g.deps check <file>  - Check file dependencies"
echo "  g.context <file>     - Build smart context"
echo ""
echo "Start with: g.project init"