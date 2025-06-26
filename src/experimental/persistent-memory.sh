#!/bin/bash
# Gemini Advanced - Persistent Memory System
# Context that survives between sessions

MEMORY_DIR="$HOME/.gemini-advanced/memory"
MEMORY_FILE="$MEMORY_DIR/context.json"
MEMORY_INDEX="$MEMORY_DIR/index.json"
SESSION_LOG="$MEMORY_DIR/sessions.log"

# Ensure directories exist
mkdir -p "$MEMORY_DIR"

# Initialize memory structure
if [ ! -f "$MEMORY_FILE" ]; then
    cat > "$MEMORY_FILE" << 'EOF'
{
    "global": {
        "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
        "facts": {},
        "preferences": {},
        "learned_patterns": {}
    },
    "projects": {}
}
EOF
fi

# g.remember - Store information
cat > ~/.gemini-advanced/bin/g.remember << 'EOF'
#!/bin/bash
# Remember facts and context

MEMORY_FILE="$HOME/.gemini-advanced/memory/context.json"
TEMP_FILE="$HOME/.gemini-advanced/memory/temp.json"

FACT="$*"
if [ -z "$FACT" ]; then
    echo "Usage: g.remember <fact>"
    echo "Example: g.remember 'This project uses PostgreSQL 15 with Prisma ORM'"
    exit 1
fi

# Determine context (global or project-specific)
PROJECT_NAME=""
if [ -f "$HOME/.gemini-advanced/projects/current/metadata.json" ]; then
    PROJECT_NAME=$(python3 -c "import json; print(json.load(open('$HOME/.gemini-advanced/projects/current/metadata.json'))['name'])" 2>/dev/null)
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
FACT_ID=$(echo "$FACT" | md5sum | cut -d' ' -f1 | head -c 8)

# Add fact to memory using Python for JSON manipulation
python3 << PYTHON
import json
import sys

with open('$MEMORY_FILE', 'r') as f:
    memory = json.load(f)

fact_entry = {
    "content": "$FACT",
    "timestamp": "$TIMESTAMP",
    "id": "$FACT_ID"
}

if "$PROJECT_NAME":
    # Project-specific memory
    if "$PROJECT_NAME" not in memory["projects"]:
        memory["projects"]["$PROJECT_NAME"] = {
            "facts": {},
            "preferences": {},
            "patterns": {}
        }
    memory["projects"]["$PROJECT_NAME"]["facts"]["$FACT_ID"] = fact_entry
    print(f"💾 Remembered for project {'"$PROJECT_NAME"'}: {'"$FACT"'}")
else:
    # Global memory
    memory["global"]["facts"]["$FACT_ID"] = fact_entry
    print(f"💾 Remembered globally: {'"$FACT"'}")

with open('$MEMORY_FILE', 'w') as f:
    json.dump(memory, f, indent=2)
PYTHON

# Log to session
echo "$(date): REMEMBER: $FACT" >> "$HOME/.gemini-advanced/memory/sessions.log"
EOF

# g.recall - Retrieve information
cat > ~/.gemini-advanced/bin/g.recall << 'EOF'
#!/bin/bash
# Recall stored information

MEMORY_FILE="$HOME/.gemini-advanced/memory/context.json"
SEARCH_TERM="$1"

if [ -z "$SEARCH_TERM" ]; then
    # Show all memories
    echo "🧠 All memories:"
    python3 << PYTHON
import json

with open('$MEMORY_FILE', 'r') as f:
    memory = json.load(f)

print("\n📌 Global facts:")
for fact_id, fact in memory["global"]["facts"].items():
    print(f"  - {fact['content']} (ID: {fact_id})")

if memory["projects"]:
    print("\n📁 Project-specific facts:")
    for project, data in memory["projects"].items():
        if data["facts"]:
            print(f"\n  Project: {project}")
            for fact_id, fact in data["facts"].items():
                print(f"    - {fact['content']}")
PYTHON
else
    # Search for specific term
    echo "🔍 Searching memories for: $SEARCH_TERM"
    python3 << PYTHON
import json
import re

with open('$MEMORY_FILE', 'r') as f:
    memory = json.load(f)

search_term = "$SEARCH_TERM".lower()
found = False

# Search global facts
for fact_id, fact in memory["global"]["facts"].items():
    if search_term in fact["content"].lower():
        if not found:
            print("\n📌 Global matches:")
            found = True
        print(f"  - {fact['content']} (ID: {fact_id})")

# Search project facts
for project, data in memory["projects"].items():
    project_found = False
    for fact_id, fact in data["facts"].items():
        if search_term in fact["content"].lower():
            if not project_found:
                print(f"\n📁 Project '{project}' matches:")
                project_found = True
                found = True
            print(f"  - {fact['content']}")

if not found:
    print("❌ No memories found matching: $SEARCH_TERM")
PYTHON
fi
EOF

# g.forget - Remove memories
cat > ~/.gemini-advanced/bin/g.forget << 'EOF'
#!/bin/bash
# Forget specific memories

MEMORY_FILE="$HOME/.gemini-advanced/memory/context.json"
FACT_ID="$1"

if [ -z "$FACT_ID" ]; then
    echo "Usage: g.forget <fact-id>"
    echo "Use 'g.recall' to see fact IDs"
    exit 1
fi

python3 << PYTHON
import json

with open('$MEMORY_FILE', 'r') as f:
    memory = json.load(f)

deleted = False

# Check global facts
if "$FACT_ID" in memory["global"]["facts"]:
    content = memory["global"]["facts"]["$FACT_ID"]["content"]
    del memory["global"]["facts"]["$FACT_ID"]
    print(f"🗑️  Forgot global fact: {content}")
    deleted = True
else:
    # Check project facts
    for project, data in memory["projects"].items():
        if "$FACT_ID" in data["facts"]:
            content = data["facts"]["$FACT_ID"]["content"]
            del data["facts"]["$FACT_ID"]
            print(f"🗑️  Forgot project '{project}' fact: {content}")
            deleted = True
            break

if deleted:
    with open('$MEMORY_FILE', 'w') as f:
        json.dump(memory, f, indent=2)
else:
    print("❌ Fact ID not found: $FACT_ID")
PYTHON
EOF

# g.learn - Learn from codebase patterns
cat > ~/.gemini-advanced/bin/g.learn << 'EOF'
#!/bin/bash
# Learn patterns from codebase

MEMORY_FILE="$HOME/.gemini-advanced/memory/context.json"
PROJECT_DIR="${1:-.}"

echo "🎓 Learning from: $PROJECT_DIR"

# Analyze code patterns
PATTERNS=$(find "$PROJECT_DIR" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" \) \
    -not -path "*/node_modules/*" -not -path "*/.git/*" | head -20 | xargs -I {} sh -c '
    echo "File: {}"
    # Extract function patterns
    grep -E "^(function|const|class|def|export)" {} | head -5
    echo "---"
' 2>/dev/null)

# Send to Gemini for analysis
ANALYSIS=$(echo "Analyze these code patterns and identify:
1. Coding style (naming conventions, structure)
2. Common patterns used
3. Architecture patterns
4. Testing approach

Patterns found:
$PATTERNS

Provide a concise summary of learned patterns:" | gemini --prompt "$(<&0)")

# Store learned patterns
python3 << PYTHON
import json
from datetime import datetime

with open('$MEMORY_FILE', 'r') as f:
    memory = json.load(f)

project_name = "$PROJECT_DIR"
if project_name == ".":
    project_name = "current"

pattern_entry = {
    "analysis": """$ANALYSIS""",
    "learned_at": datetime.utcnow().isoformat() + "Z",
    "directory": "$PROJECT_DIR"
}

if project_name not in memory["projects"]:
    memory["projects"][project_name] = {
        "facts": {},
        "preferences": {},
        "patterns": {}
    }

memory["projects"][project_name]["patterns"]["codebase"] = pattern_entry

with open('$MEMORY_FILE', 'w') as f:
    json.dump(memory, f, indent=2)

print("✅ Patterns learned and stored!")
PYTHON

echo ""
echo "$ANALYSIS"
EOF

# g.context save/load - Session management
cat > ~/.gemini-advanced/bin/g.session << 'EOF'
#!/bin/bash
# Session management

MEMORY_DIR="$HOME/.gemini-advanced/memory"
SESSIONS_DIR="$MEMORY_DIR/sessions"
mkdir -p "$SESSIONS_DIR"

case "$1" in
    save)
        SESSION_NAME="${2:-$(date +%Y%m%d_%H%M%S)}"
        SESSION_FILE="$SESSIONS_DIR/$SESSION_NAME.json"
        
        # Create session snapshot
        python3 << PYTHON
import json
import shutil
from datetime import datetime

# Copy current memory
shutil.copy2('$MEMORY_DIR/context.json', '$SESSION_FILE')

# Add session metadata
with open('$SESSION_FILE', 'r') as f:
    session = json.load(f)

session['_session_meta'] = {
    'name': '$SESSION_NAME',
    'saved_at': datetime.utcnow().isoformat() + 'Z',
    'description': '${3:-}'
}

with open('$SESSION_FILE', 'w') as f:
    json.dump(session, f, indent=2)

print(f"💾 Session saved: $SESSION_NAME")
PYTHON
        ;;
        
    load)
        SESSION_NAME="$2"
        if [ -z "$SESSION_NAME" ]; then
            echo "Available sessions:"
            ls -1 "$SESSIONS_DIR" | sed 's/.json$//'
            exit 0
        fi
        
        SESSION_FILE="$SESSIONS_DIR/$SESSION_NAME.json"
        if [ -f "$SESSION_FILE" ]; then
            cp "$SESSION_FILE" "$MEMORY_DIR/context.json"
            echo "✅ Session loaded: $SESSION_NAME"
        else
            echo "❌ Session not found: $SESSION_NAME"
        fi
        ;;
        
    list)
        echo "📚 Available sessions:"
        for session in "$SESSIONS_DIR"/*.json; do
            if [ -f "$session" ]; then
                name=$(basename "$session" .json)
                echo "  - $name"
            fi
        done
        ;;
        
    *)
        echo "Usage: g.session <command>"
        echo "Commands:"
        echo "  save [name] [description]  - Save current session"
        echo "  load <name>               - Load saved session"
        echo "  list                      - List all sessions"
        ;;
esac
EOF

# Make all scripts executable
chmod +x ~/.gemini-advanced/bin/g.remember
chmod +x ~/.gemini-advanced/bin/g.recall
chmod +x ~/.gemini-advanced/bin/g.forget
chmod +x ~/.gemini-advanced/bin/g.learn
chmod +x ~/.gemini-advanced/bin/g.session

echo "✅ Persistent Memory System installed!"
echo ""
echo "🧠 Memory commands:"
echo "  g.remember <fact>         - Store information"
echo "  g.recall [search]         - Retrieve memories"
echo "  g.forget <id>            - Remove specific memory"
echo "  g.learn [path]           - Learn from codebase"
echo "  g.session save/load      - Manage sessions"
echo ""
echo "Try: g.remember 'This project uses React 18 with TypeScript'"