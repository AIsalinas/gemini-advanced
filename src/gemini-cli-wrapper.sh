#!/bin/bash
# Gemini CLI Wrapper - Injects system instructions

# Read the GEMINI.md content
SYSTEM_PROMPT=$(cat ~/GEMINI.md)

# Create the wrapper
cat > ~/.gemini-advanced/bin/gemini-enhanced << 'EOF'
#!/bin/bash
# Enhanced Gemini CLI with command support

# Check if we're in interactive mode or have a prompt
if [ $# -eq 0 ]; then
    # Interactive mode - inject our system prompt first
    echo "Loading Gemini Advanced commands..." >&2
    echo "Type 'g.help' for available commands" >&2
    echo "" >&2
    
    # Create a temporary file with our system instructions
    TEMP_PROMPT=$(mktemp)
    cat > "$TEMP_PROMPT" << 'SYSPROMPT'
# GEMINI ADVANCED COMMANDS - ACTIVE

You are Gemini with enhanced capabilities. RECOGNIZE AND EXECUTE these commands:

## COMMAND DETECTION RULES
When user input starts with these EXACT patterns, you MUST activate the corresponding mode:

### THINKING MODES (PREFIX COMMANDS)
**g.** = Standard mode - just answer the query
**gt.** = THINK MODE - Show step-by-step reasoning
**gth.** = THINK HARD - Deep critical analysis  
**gu.** = ULTRA THINK - Exhaustive, complete analysis

### PERSONAS (PREFIX COMMANDS)
**g.arch** = [ARCHITECT] Focus on scalability, patterns, design
**g.debug** = [DEBUGGER] Systematic problem analysis
**g.sec** = [SECURITY] Threat modeling, vulnerabilities
**g.front** = [FRONTEND] UX, accessibility, user-centric
**g.back** = [BACKEND] APIs, databases, reliability
**g.perf** = [PERFORMANCE] Optimization, bottlenecks
**g.qa** = [QA] Testing strategies, edge cases
**g.mentor** = [MENTOR] Clear teaching, examples

### SPECIAL COMMAND
**g.help** = Show this command list with examples

## EXECUTION EXAMPLES

Input: g.help
Output: Show all available commands with examples

Input: gt. explain concept
Output: [THINK MODE] Step-by-step explanation...

Input: g.arch design system
Output: [ARCHITECT] Architectural analysis...

REMEMBER: Check EVERY message for these command patterns at the start!
SYSPROMPT
    
    # Start gemini with our system prompt pre-loaded
    (echo ""; cat "$TEMP_PROMPT"; echo -e "\n---\nSystem instructions loaded. I will recognize g., gt., gth., gu. and persona commands.\n") | gemini
    
    rm -f "$TEMP_PROMPT"
else
    # Non-interactive mode - pass through
    gemini "$@"
fi
EOF

chmod +x ~/.gemini-advanced/bin/gemini-enhanced

# Create an alias updater
cat > ~/.gemini-advanced/bin/update-gemini-alias.sh << 'EOF'
#!/bin/bash
# Update shell configuration for Gemini Advanced

SHELL_CONFIG=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    # Remove old alias if exists
    sed -i.bak '/alias gemini=/d' "$SHELL_CONFIG"
    
    # Add new alias
    echo "" >> "$SHELL_CONFIG"
    echo "# Gemini Advanced" >> "$SHELL_CONFIG"
    echo "alias gemini='gemini-enhanced'" >> "$SHELL_CONFIG"
    echo "✅ Updated $SHELL_CONFIG"
    echo "Run: source $SHELL_CONFIG"
else
    echo "❌ Unknown shell. Add manually:"
    echo "alias gemini='gemini-enhanced'"
fi
EOF

chmod +x ~/.gemini-advanced/bin/update-gemini-alias.sh

echo "✅ Gemini CLI Wrapper created!"
echo ""
echo "To activate enhanced Gemini:"
echo "1. Run: ~/.gemini-advanced/bin/update-gemini-alias.sh"
echo "2. Run: source ~/.zshrc (or ~/.bashrc)"
echo "3. Then use: gemini"
echo ""
echo "Or directly: gemini-enhanced"