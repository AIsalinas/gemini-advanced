#!/bin/bash
# Fix Gemini Advanced Commands - Final Solution

echo "🔧 Fixing Gemini Advanced command recognition..."

# Solution 1: Create a pre-prompt injection wrapper
cat > ~/.gemini-advanced/bin/gemini-interactive << 'EOF'
#!/bin/bash
# Gemini Interactive with Command Support

# Create initial context message
INIT_MESSAGE='You are Gemini with enhanced command recognition. 

CRITICAL INSTRUCTIONS:
When users type these patterns at the START of their message, you MUST respond accordingly:

1. g.help → Show available commands
2. g. <query> → Answer normally  
3. gt. <query> → [THINK MODE] Show step-by-step reasoning
4. gth. <query> → [THINK HARD] Critical analysis
5. gu. <query> → [ULTRA THINK] Exhaustive analysis
6. g.arch <query> → [ARCHITECT] System design focus
7. g.debug <query> → [DEBUGGER] Problem solving
8. g.sec <query> → [SECURITY] Security analysis

Example: User types "gt. how does async work"
You respond: "[THINK MODE] Let me think through this step by step..."

Acknowledge by saying: "✅ Gemini Advanced ready! Type g.help for commands."'

# Use expect to interact with gemini
expect -c "
spawn gemini
expect \">\"
send \"$INIT_MESSAGE\r\"
expect \">\"
interact
"
EOF

chmod +x ~/.gemini-advanced/bin/gemini-interactive

# Solution 2: Create a Python wrapper with better control
cat > ~/.gemini-advanced/bin/gemini-enhanced.py << 'EOF'
#!/usr/bin/env python3
import subprocess
import sys
import re

class GeminiEnhanced:
    def __init__(self):
        self.commands = {
            'g.help': self.show_help,
            'g.': self.standard_mode,
            'gt.': self.think_mode,
            'gth.': self.think_hard_mode,
            'gu.': self.ultra_think_mode,
            'g.arch': self.architect_mode,
            'g.debug': self.debugger_mode,
            'g.sec': self.security_mode,
            'g.front': self.frontend_mode,
            'g.back': self.backend_mode,
        }
        
    def show_help(self):
        return """🚀 Gemini Advanced Commands:

THINKING MODES:
  g. <query>     - Standard response
  gt. <query>    - Think mode (step-by-step)
  gth. <query>   - Think hard (critical analysis)  
  gu. <query>    - Ultra think (exhaustive)

PERSONAS:
  g.arch <q>     - System architect
  g.debug <q>    - Debugger
  g.sec <q>      - Security expert
  g.front <q>    - Frontend developer
  g.back <q>     - Backend developer

Example: gt. explain promises in JavaScript"""

    def standard_mode(self, query):
        return query

    def think_mode(self, query):
        return f"Please think step by step about this: {query}\nShow your reasoning process clearly."

    def think_hard_mode(self, query):
        return f"[THINK HARD MODE] Analyze this critically with deep reasoning: {query}\nQuestion assumptions, consider edge cases."

    def ultra_think_mode(self, query):
        return f"[ULTRA THINK MODE] Provide exhaustive analysis of: {query}\nCover ALL aspects, alternatives, implications, edge cases."

    def architect_mode(self, query):
        return f"As a system architect, analyze this focusing on design patterns and scalability: {query}"

    def debugger_mode(self, query):
        return f"As a debugger, systematically analyze this problem: {query}"

    def security_mode(self, query):
        return f"From a security perspective, analyze: {query}"
        
    def frontend_mode(self, query):
        return f"As a frontend developer focusing on UX: {query}"
        
    def backend_mode(self, query):
        return f"As a backend developer focusing on reliability: {query}"

    def process_input(self, user_input):
        # Check each command pattern
        for cmd, handler in self.commands.items():
            if user_input.startswith(cmd):
                if cmd == 'g.help':
                    return handler()
                else:
                    # Extract query after command
                    query = user_input[len(cmd):].strip()
                    if query:
                        return handler(query)
                    else:
                        return f"Please provide a query after {cmd}"
        
        # No command matched - return as is
        return user_input

    def run(self):
        print("🚀 Gemini Enhanced - Command Recognition Active")
        print("Type 'g.help' for commands\n")
        
        # Start gemini subprocess
        proc = subprocess.Popen(
            ['gemini'],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=0
        )
        
        # Send initial context
        init_msg = """You are Gemini with command recognition. When I send messages starting with g., gt., gth., gu., or g.arch etc., interpret them as special commands. Acknowledge with: Ready for enhanced commands."""
        
        proc.stdin.write(init_msg + '\n')
        proc.stdin.flush()
        
        # Main loop
        try:
            while True:
                user_input = input("> ")
                if user_input.lower() in ['exit', 'quit']:
                    break
                    
                # Process command
                processed = self.process_input(user_input)
                
                # Send to gemini
                proc.stdin.write(processed + '\n')
                proc.stdin.flush()
                
        except KeyboardInterrupt:
            print("\nExiting...")
        finally:
            proc.terminate()

if __name__ == '__main__':
    app = GeminiEnhanced()
    app.run()
EOF

chmod +x ~/.gemini-advanced/bin/gemini-enhanced.py

# Solution 3: Update the main wrapper to inject commands properly
cat > ~/.gemini-advanced/bin/gemini-cmd << 'EOF'
#!/bin/bash
# Simple command injector for Gemini

# If in terminal, provide command list
if [ -t 0 ] && [ $# -eq 0 ]; then
    echo "🚀 Starting Gemini with command support..."
    echo ""
    # First, send the context setup
    (
        echo "From now on, recognize these commands when they appear at the start of a message:"
        echo "- g.help = show command list"
        echo "- gt. <text> = think mode with step-by-step reasoning"
        echo "- gth. <text> = think hard with critical analysis"  
        echo "- gu. <text> = ultra think with exhaustive analysis"
        echo "- g.arch <text> = architect persona"
        echo "Acknowledge with: Gemini Advanced ready."
        echo ""
        cat
    ) | gemini
else
    gemini "$@"
fi
EOF

chmod +x ~/.gemini-advanced/bin/gemini-cmd

echo ""
echo "✅ Created 3 solutions:"
echo ""
echo "1. gemini-interactive - Uses expect for better control"
echo "2. gemini-enhanced.py - Python wrapper with command processing"  
echo "3. gemini-cmd - Simple bash wrapper"
echo ""
echo "Try each one to see which works best:"
echo "  ~/.gemini-advanced/bin/gemini-interactive"
echo "  ~/.gemini-advanced/bin/gemini-enhanced.py"
echo "  ~/.gemini-advanced/bin/gemini-cmd"