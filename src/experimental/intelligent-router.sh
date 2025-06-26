#!/bin/bash
# Gemini Advanced - Intelligent Command Router
# AI automatically determines the best command to use

# Create main 'g' command that intelligently routes
cat > ~/.gemini-advanced/bin/g.smart << 'EOF'
#!/bin/bash
# Smart command router - AI decides what to do

QUERY="$*"

if [ -z "$QUERY" ]; then
    echo "🤖 Gemini Advanced - Smart Mode"
    echo "Just tell me what you want, I'll figure out the right command!"
    echo ""
    echo "Examples:"
    echo "  g 'show me all React components'"
    echo "  g 'explain this error: TypeError...'"
    echo "  g 'run tests and fix failures'"
    echo "  g 'remember this uses PostgreSQL'"
    exit 0
fi

# Analyze intent with AI
echo "🧠 Analyzing request..."

INTENT_ANALYSIS=$(cat << PROMPT | gemini --prompt "$(<&0)"
Analyze this user request and determine the SINGLE BEST Gemini Advanced command to use.

User request: "$QUERY"

Available commands and their purposes:
- g.read <file> - Read and analyze a specific file
- g.find <term> - Search for something across the project
- g.analyze <pattern> - Analyze multiple files matching a pattern
- g.context <file> - Build smart context including related files
- g.project init - Initialize project indexing
- g.deps analyze - Analyze project dependencies
- g.remember <fact> - Store information for later
- g.recall <term> - Retrieve stored information
- g.learn - Learn patterns from codebase
- g.run <cmd> - Safely execute a command
- g.fix <error> - Fix an error
- g.safe <cmd> - Check if a command is safe
- g <text> - General question (no special features needed)
- gt <text> - Think mode for complex analysis
- gth <text> - Think hard for critical analysis
- gu <text> - Ultra think for exhaustive analysis

Based on the request, respond with ONLY:
1. The exact command to run (including arguments)
2. Brief reason (one line)

Format:
COMMAND: <exact command>
REASON: <why this command>

Examples:
Request: "show me all test files"
COMMAND: g.find test
REASON: Searching for files containing 'test'

Request: "analyze why the build is failing"
COMMAND: gth 'analyze why the build is failing'
REASON: Complex problem requiring deep analysis

Request: "remember that we use Docker for deployment"
COMMAND: g.remember 'we use Docker for deployment'
REASON: Storing project information

Request: "what does server.js do"
COMMAND: g.read server.js 'what does this file do'
REASON: Analyzing specific file content
PROMPT
)

# Extract command and reason
COMMAND=$(echo "$INTENT_ANALYSIS" | grep "^COMMAND:" | sed 's/^COMMAND: //')
REASON=$(echo "$INTENT_ANALYSIS" | grep "^REASON:" | sed 's/^REASON: //')

if [ -z "$COMMAND" ]; then
    # Fallback to basic g command
    echo "📝 Using standard mode"
    gemini --prompt "$QUERY"
else
    echo "🎯 $REASON"
    echo "⚡ Executing: $COMMAND"
    echo ""
    
    # Execute the determined command
    eval "$COMMAND"
fi
EOF

# Create enhanced main 'g' wrapper that includes smart routing
cat > ~/.gemini-advanced/bin/g.wrapper << 'EOF'
#!/bin/bash
# Enhanced g command with smart routing

# Check if first argument looks like a subcommand
if [[ "$1" =~ ^\. ]]; then
    # Traditional subcommand syntax (g.read, g.find, etc.)
    SUBCOMMAND="g$1"
    shift
    exec "$SUBCOMMAND" "$@"
elif [ -f "$1" ] || [[ "$1" =~ \.(js|ts|py|java|go|rb|php|cpp|c|h|jsx|tsx|json|yaml|yml|xml|html|css|scss|md|txt|sh|bash)$ ]]; then
    # If first argument is a file or looks like a filename, use g.read
    exec g.read "$@"
elif [[ "$1" =~ ^(find|search|look for|where is|locate) ]]; then
    # Search keywords detected
    shift
    exec g.find "$@"
elif [[ "$1" =~ ^(remember|store|save|note) ]]; then
    # Memory keywords detected
    shift
    exec g.remember "$@"
elif [[ "$1" =~ ^(recall|retrieve|what did|remind) ]]; then
    # Recall keywords detected
    shift
    exec g.recall "$@"
elif [[ "$1" =~ ^(run|exec|execute|do) ]]; then
    # Execution keywords detected
    shift
    exec g.run "$@"
elif [[ "$1" =~ ^(fix|solve|debug|repair) ]]; then
    # Fix keywords detected
    shift
    exec g.fix "$@"
elif [[ "$1" =~ ^(safe|check|verify|dangerous) ]]; then
    # Safety keywords detected
    shift
    exec g.safe "$@"
elif [[ "$GEMINI_SMART_MODE" == "true" ]] || [[ "$1" == "--smart" ]]; then
    # Smart mode enabled
    if [[ "$1" == "--smart" ]]; then
        shift
    fi
    exec g.smart "$@"
else
    # Default behavior - check complexity
    WORD_COUNT=$(echo "$@" | wc -w)
    
    if [ $WORD_COUNT -gt 10 ] || [[ "$@" =~ (analyze|explain|debug|architect|design|implement) ]]; then
        # Complex query - use smart routing
        exec g.smart "$@"
    else
        # Simple query - direct to gemini
        gemini --prompt "$@"
    fi
fi
EOF

# Update the main 'g' command to use the wrapper
cat > ~/.gemini-advanced/bin/g << 'EOF'
#!/bin/bash
# Gemini Advanced - Main command with intelligent routing

# Enable smart mode by default for natural language queries
export GEMINI_SMART_MODE="${GEMINI_SMART_MODE:-true}"

# Pass to wrapper
exec g.wrapper "$@"
EOF

# Create a configuration command
cat > ~/.gemini-advanced/bin/g.config << 'EOF'
#!/bin/bash
# Configure Gemini Advanced behavior

CONFIG_FILE="$HOME/.gemini-advanced/config.json"

# Initialize config if not exists
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << CONFIG
{
    "smart_mode": true,
    "auto_project_init": true,
    "safety_level": "medium",
    "thinking_preference": "auto",
    "language": "en"
}
CONFIG
fi

case "$1" in
    get)
        KEY="$2"
        if [ -z "$KEY" ]; then
            cat "$CONFIG_FILE" | python3 -m json.tool
        else
            python3 -c "import json; print(json.load(open('$CONFIG_FILE')).get('$KEY', 'Not set'))"
        fi
        ;;
        
    set)
        KEY="$2"
        VALUE="$3"
        if [ -z "$KEY" ] || [ -z "$VALUE" ]; then
            echo "Usage: g.config set <key> <value>"
            exit 1
        fi
        
        python3 << PYTHON
import json

with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

config['$KEY'] = '$VALUE'

with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2)

print(f"✅ Set {repr('$KEY')} = {repr('$VALUE')}")
PYTHON
        ;;
        
    *)
        echo "🔧 Gemini Advanced Configuration"
        echo ""
        echo "Commands:"
        echo "  g.config get [key]     - Show configuration"
        echo "  g.config set <key> <value> - Set configuration"
        echo ""
        echo "Configuration keys:"
        echo "  smart_mode - Enable intelligent routing (true/false)"
        echo "  auto_project_init - Auto-index projects (true/false)"
        echo "  safety_level - Command safety (low/medium/high)"
        echo "  thinking_preference - Thinking mode (auto/light/deep)"
        echo "  language - Interface language (en/cs)"
        ;;
esac
EOF

# Create help command
cat > ~/.gemini-advanced/bin/g.help << 'EOF'
#!/bin/bash
# Comprehensive help for Gemini Advanced

echo "🚀 Gemini Advanced - Intelligent AI Assistant"
echo "============================================"
echo ""
echo "SMART MODE (default):"
echo "  Just type naturally, AI will choose the right command:"
echo "  g 'show all test files'"
echo "  g 'fix this TypeError'"
echo "  g 'explain how authentication works'"
echo ""
echo "THINKING MODES:"
echo "  g <text>    - Quick response"
echo "  gt <text>   - Think mode (detailed)"
echo "  gth <text>  - Think hard (critical analysis)"
echo "  gu <text>   - Ultra think (exhaustive)"
echo ""
echo "FILE OPERATIONS:"
echo "  g.read <file> [question]      - Analyze file"
echo "  g.find <term>                 - Search project"
echo "  g.analyze <pattern>           - Analyze multiple files"
echo "  g.context <file>              - Build smart context"
echo ""
echo "PROJECT MANAGEMENT:"
echo "  g.project init                - Index current project"
echo "  g.deps analyze                - Analyze dependencies"
echo ""
echo "MEMORY SYSTEM:"
echo "  g.remember <fact>             - Store information"
echo "  g.recall [search]             - Retrieve memories"
echo "  g.learn                       - Learn from codebase"
echo "  g.session save/load           - Manage sessions"
echo ""
echo "COMMAND EXECUTION:"
echo "  g.run <cmd> [--explain]       - Safe execution"
echo "  g.fix <error>                 - Auto-fix errors"
echo "  g.safe <cmd>                  - Safety check"
echo "  g.monitor <cmd>               - Monitor execution"
echo ""
echo "CONFIGURATION:"
echo "  g.config get/set              - Configure behavior"
echo "  g.help                        - This help"
echo ""
echo "PRO TIP: Just describe what you want naturally!"
echo "Example: g 'find all places where we handle user login'"
EOF

# Make all scripts executable
chmod +x ~/.gemini-advanced/bin/g.smart
chmod +x ~/.gemini-advanced/bin/g.wrapper
chmod +x ~/.gemini-advanced/bin/g
chmod +x ~/.gemini-advanced/bin/g.config
chmod +x ~/.gemini-advanced/bin/g.help

echo "✅ Intelligent Router installed!"
echo ""
echo "🎯 Smart features activated:"
echo "  • Natural language understanding"
echo "  • Automatic command selection"
echo "  • Context-aware routing"
echo "  • Intelligent file detection"
echo ""
echo "Just type: g 'what you want to do'"
echo "Examples:"
echo "  g 'show me all API endpoints'"
echo "  g 'fix the failing tests'"
echo "  g 'explain this error: ...'"
echo ""
echo "Configure with: g.config set smart_mode true"