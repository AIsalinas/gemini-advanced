#!/bin/bash
# Gemini Advanced - Safe Command Execution
# AI-supervised command execution with sandboxing

SANDBOX_DIR="$HOME/.gemini-advanced/sandbox"
COMMAND_LOG="$HOME/.gemini-advanced/logs/commands.log"
BLOCKED_COMMANDS="$HOME/.gemini-advanced/security/blocked.txt"

# Ensure directories exist
mkdir -p "$SANDBOX_DIR"
mkdir -p "$HOME/.gemini-advanced/logs"
mkdir -p "$HOME/.gemini-advanced/security"

# Initialize blocked commands list
if [ ! -f "$BLOCKED_COMMANDS" ]; then
    cat > "$BLOCKED_COMMANDS" << 'EOF'
rm -rf /
rm -rf ~
sudo rm -rf
dd if=/dev/zero
mkfs
fdisk
shutdown
reboot
halt
init 0
systemctl stop
killall
pkill -9
chmod -R 777 /
chown -R
mv /* 
> /dev/sda
curl | sh
wget | sh
eval
EOF
fi

# g.run - Safe command execution
cat > ~/.gemini-advanced/bin/g.run << 'EOF'
#!/bin/bash
# Execute commands with AI supervision

COMMAND_LOG="$HOME/.gemini-advanced/logs/commands.log"
BLOCKED_COMMANDS="$HOME/.gemini-advanced/security/blocked.txt"

COMMAND="$1"
FLAGS="$2"

if [ -z "$COMMAND" ]; then
    echo "Usage: g.run <command> [--explain|--auto|--sandbox]"
    echo "Examples:"
    echo "  g.run 'npm test' --explain"
    echo "  g.run 'git status'"
    echo "  g.run 'rm file.txt' --sandbox"
    exit 1
fi

# Security check
DANGEROUS=false
while IFS= read -r blocked; do
    if [[ "$COMMAND" == *"$blocked"* ]]; then
        DANGEROUS=true
        break
    fi
done < "$BLOCKED_COMMANDS"

if [ "$DANGEROUS" = true ]; then
    echo "🚫 BLOCKED: This command appears dangerous!"
    echo "Command: $COMMAND"
    echo ""
    echo "If you're sure, use: g.run '$COMMAND' --force"
    exit 1
fi

# Log command
echo "$(date): RUN: $COMMAND" >> "$COMMAND_LOG"

case "$FLAGS" in
    --explain)
        echo "🤖 Analyzing command..."
        ANALYSIS=$(echo "Explain what this command does, potential risks, and expected output:
        
Command: $COMMAND

Provide:
1. What it does
2. Potential risks
3. Expected output
4. Safer alternatives (if any)" | gemini --prompt "$(<&0)")
        
        echo "$ANALYSIS"
        echo ""
        read -p "Execute this command? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🚀 Executing..."
            eval "$COMMAND"
        else
            echo "❌ Cancelled"
        fi
        ;;
        
    --sandbox)
        echo "📦 Running in sandbox..."
        SANDBOX_DIR="$HOME/.gemini-advanced/sandbox/$(date +%s)"
        mkdir -p "$SANDBOX_DIR"
        cd "$SANDBOX_DIR"
        
        echo "Working directory: $SANDBOX_DIR"
        eval "$COMMAND"
        
        echo ""
        echo "Sandbox contents:"
        ls -la "$SANDBOX_DIR"
        ;;
        
    --auto)
        echo "🤖 Auto-executing with monitoring..."
        # Execute and capture output
        OUTPUT=$(eval "$COMMAND" 2>&1)
        EXIT_CODE=$?
        
        if [ $EXIT_CODE -eq 0 ]; then
            echo "✅ Success:"
            echo "$OUTPUT"
        else
            echo "❌ Failed (exit code: $EXIT_CODE)"
            echo "$OUTPUT"
            
            # Ask AI for fix
            echo ""
            echo "🔧 Analyzing error..."
            FIX=$(echo "Command failed:
Command: $COMMAND
Error output: $OUTPUT
Exit code: $EXIT_CODE

Suggest a fix:" | gemini --prompt "$(<&0)")
            
            echo "$FIX"
        fi
        ;;
        
    --force)
        echo "⚠️  Force executing (be careful!)..."
        eval "$COMMAND"
        ;;
        
    *)
        # Default: execute with basic safety
        echo "🚀 Executing: $COMMAND"
        eval "$COMMAND"
        ;;
esac
EOF

# g.fix - Auto-fix errors
cat > ~/.gemini-advanced/bin/g.fix << 'EOF'
#!/bin/bash
# AI-powered error fixing

ERROR="$1"
CONTEXT="${2:-}"

if [ -z "$ERROR" ]; then
    echo "Usage: g.fix <error> [context]"
    echo "Example: g.fix 'npm ERR! missing script: test'"
    exit 1
fi

echo "🔧 Analyzing error..."

PROMPT="Fix this error:

Error: $ERROR"

if [ -n "$CONTEXT" ]; then
    PROMPT="$PROMPT

Context: $CONTEXT"
fi

PROMPT="$PROMPT

Provide:
1. Root cause
2. Fix command(s)
3. Preventive measures"

SOLUTION=$(echo "$PROMPT" | gemini --prompt "$(<&0)")

echo "$SOLUTION"

# Extract commands from solution
echo ""
echo "📋 Suggested commands:"
echo "$SOLUTION" | grep -E "^\s*(npm|yarn|git|cd|mkdir|touch|echo|cat)" | while read -r cmd; do
    cmd=$(echo "$cmd" | sed 's/^\s*//')
    echo "  $cmd"
    read -p "  Execute? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        eval "$cmd"
    fi
done
EOF

# g.safe - Safety checker
cat > ~/.gemini-advanced/bin/g.safe << 'EOF'
#!/bin/bash
# Check command safety before execution

COMMAND="$1"

if [ -z "$COMMAND" ]; then
    echo "Usage: g.safe <command>"
    echo "Checks if a command is safe to run"
    exit 1
fi

echo "🔍 Safety analysis for: $COMMAND"

ANALYSIS=$(echo "Analyze the safety of this command:

Command: $COMMAND

Check for:
1. Destructive operations (file deletion, system changes)
2. Security risks (network access, privilege escalation)
3. Performance impact
4. Side effects

Rate safety: SAFE / CAUTION / DANGEROUS

Explain your rating:" | gemini --prompt "$(<&0)")

echo "$ANALYSIS"

# Log safety check
echo "$(date): SAFETY_CHECK: $COMMAND" >> "$HOME/.gemini-advanced/logs/commands.log"
EOF

# g.monitor - Command monitoring
cat > ~/.gemini-advanced/bin/g.monitor << 'EOF'
#!/bin/bash
# Monitor long-running commands

COMMAND="$1"
INTERVAL="${2:-5}"

if [ -z "$COMMAND" ]; then
    echo "Usage: g.monitor <command> [interval]"
    echo "Monitor command execution with AI insights"
    exit 1
fi

echo "📊 Monitoring: $COMMAND"
echo "Check interval: ${INTERVAL}s"
echo "Press Ctrl+C to stop"
echo ""

# Start command in background
eval "$COMMAND" &
PID=$!

START_TIME=$(date +%s)

while kill -0 $PID 2>/dev/null; do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    echo "⏱️  Running for ${ELAPSED}s (PID: $PID)"
    
    # Check system resources
    if command -v ps >/dev/null 2>&1; then
        PS_OUTPUT=$(ps -p $PID -o %cpu,%mem,comm 2>/dev/null | tail -1)
        echo "   Resources: $PS_OUTPUT"
    fi
    
    sleep $INTERVAL
done

wait $PID
EXIT_CODE=$?

END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))

echo ""
echo "✅ Completed in ${TOTAL_TIME}s (exit code: $EXIT_CODE)"

# AI summary
if [ $TOTAL_TIME -gt 10 ]; then
    echo ""
    echo "🤖 Performance analysis..."
    ANALYSIS=$(echo "Analyze this command execution:

Command: $COMMAND
Duration: ${TOTAL_TIME} seconds
Exit code: $EXIT_CODE

Was this normal execution time? Any optimization suggestions?" | gemini --prompt "$(<&0)")
    
    echo "$ANALYSIS"
fi
EOF

# g.undo - Command undo functionality
cat > ~/.gemini-advanced/bin/g.undo << 'EOF'
#!/bin/bash
# Undo last command effects

COMMAND_LOG="$HOME/.gemini-advanced/logs/commands.log"
UNDO_SCRIPTS="$HOME/.gemini-advanced/undo"
mkdir -p "$UNDO_SCRIPTS"

# Get last command
LAST_COMMAND=$(tail -1 "$COMMAND_LOG" | sed 's/^.*RUN: //')

if [ -z "$LAST_COMMAND" ]; then
    echo "❌ No commands in history"
    exit 1
fi

echo "🔄 Last command: $LAST_COMMAND"
echo ""
echo "🤖 Generating undo script..."

UNDO_SCRIPT=$(echo "Generate a script to undo/reverse the effects of this command:

Command: $LAST_COMMAND

Provide the exact commands needed to reverse this operation.
If it cannot be undone, explain why." | gemini --prompt "$(<&0)")

echo "$UNDO_SCRIPT"

# Save undo script
SCRIPT_FILE="$UNDO_SCRIPTS/undo_$(date +%s).sh"
echo "#!/bin/bash" > "$SCRIPT_FILE"
echo "# Undo: $LAST_COMMAND" >> "$SCRIPT_FILE"
echo "$UNDO_SCRIPT" | grep -E "^(git|npm|rm|mv|cp|mkdir|touch)" >> "$SCRIPT_FILE"
chmod +x "$SCRIPT_FILE"

echo ""
echo "💾 Undo script saved: $SCRIPT_FILE"
echo ""
read -p "Execute undo script? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    bash "$SCRIPT_FILE"
fi
EOF

# Make all scripts executable
chmod +x ~/.gemini-advanced/bin/g.run
chmod +x ~/.gemini-advanced/bin/g.fix
chmod +x ~/.gemini-advanced/bin/g.safe
chmod +x ~/.gemini-advanced/bin/g.monitor
chmod +x ~/.gemini-advanced/bin/g.undo

echo "✅ Safe Command Execution installed!"
echo ""
echo "🔒 Command execution tools:"
echo "  g.run <cmd> [--explain|--sandbox|--auto]  - Safe execution"
echo "  g.fix <error>                              - Auto-fix errors"
echo "  g.safe <cmd>                               - Safety check"
echo "  g.monitor <cmd>                            - Monitor execution"
echo "  g.undo                                     - Undo last command"
echo ""
echo "Try: g.run 'ls -la' --explain"