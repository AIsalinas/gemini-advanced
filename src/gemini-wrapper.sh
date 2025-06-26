#!/bin/bash
# Gemini Advanced - Interactive Wrapper
# Intercepts commands inside Gemini CLI

# Create the wrapper script
cat > ~/.gemini-advanced/bin/gemini-wrapper << 'EOF'
#!/usr/bin/env expect -f
# Expect script to wrap Gemini CLI and intercept commands

set timeout -1

# Start gemini with GEMINI.md loaded
spawn gemini

# Initial setup
expect {
    ">" {
        send_user "\n🚀 Gemini Advanced Wrapper Active!\n"
        send_user "Special commands: g., gt., gth., gu., g.help\n\n"
    }
}

# Main interaction loop
interact {
    # Intercept g.help
    "g.help" {
        send_user "\n📚 Gemini Advanced Commands:\n"
        send_user "  g. <query>    - Standard mode\n"
        send_user "  gt. <query>   - Think mode\n"
        send_user "  gth. <query>  - Think hard mode\n"
        send_user "  gu. <query>   - Ultra think mode\n"
        send_user "  g.arch <q>    - Architect persona\n"
        send_user "  g.debug <q>   - Debugger persona\n"
        send_user "  g.sec <q>     - Security persona\n"
        send_user "  g.front <q>   - Frontend persona\n"
        send_user "  g.back <q>    - Backend persona\n"
        send_user "  g.perf <q>    - Performance persona\n"
        send_user "  g.qa <q>      - QA persona\n"
        send_user "  g.mentor <q>  - Mentor persona\n\n"
        send "\r"
    }
    
    # Intercept gu. command (ultra think)
    -re "gu\\. (.+)" {
        set query $interact_out(1,string)
        send_user "\n🧠 Ultra Think Mode Activated\n"
        send "[ULTRA THINK MODE - EXHAUSTIVE ANALYSIS]\n"
        send "Provide an EXHAUSTIVE, COMPLETE analysis of: $query\n"
        send "Include ALL relevant aspects, edge cases, alternatives, and implications.\r"
    }
    
    # Intercept gth. command (think hard)
    -re "gth\\. (.+)" {
        set query $interact_out(1,string)
        send_user "\n🤔 Think Hard Mode Activated\n"
        send "[THINK HARD MODE - CRITICAL ANALYSIS]\n"
        send "Analyze critically with deep reasoning: $query\r"
    }
    
    # Intercept gt. command (think)
    -re "gt\\. (.+)" {
        set query $interact_out(1,string)
        send_user "\n💭 Think Mode Activated\n"
        send "[THINK MODE]\n"
        send "Think step by step about: $query\r"
    }
    
    # Intercept g. command (standard)
    -re "g\\. (.+)" {
        set query $interact_out(1,string)
        send "$query\r"
    }
    
    # Persona commands
    -re "g\\.arch (.+)" {
        set query $interact_out(1,string)
        send_user "\n🏗️ Architect Persona\n"
        send "[ARCHITECT PERSONA] Design with scalability and maintainability in mind: $query\r"
    }
    
    -re "g\\.debug (.+)" {
        set query $interact_out(1,string)
        send_user "\n🐛 Debugger Persona\n"
        send "[DEBUGGER PERSONA] Systematically analyze and solve: $query\r"
    }
    
    -re "g\\.sec (.+)" {
        set query $interact_out(1,string)
        send_user "\n🔒 Security Persona\n"
        send "[SECURITY PERSONA] Analyze threats and vulnerabilities: $query\r"
    }
    
    -re "g\\.front (.+)" {
        set query $interact_out(1,string)
        send_user "\n🎨 Frontend Persona\n"
        send "[FRONTEND PERSONA] Focus on UX and user needs: $query\r"
    }
    
    -re "g\\.back (.+)" {
        set query $interact_out(1,string)
        send_user "\n⚙️ Backend Persona\n"
        send "[BACKEND PERSONA] Design for reliability and performance: $query\r"
    }
    
    -re "g\\.perf (.+)" {
        set query $interact_out(1,string)
        send_user "\n⚡ Performance Persona\n"
        send "[PERFORMANCE PERSONA] Optimize for speed: $query\r"
    }
    
    -re "g\\.qa (.+)" {
        set query $interact_out(1,string)
        send_user "\n✅ QA Persona\n"
        send "[QA PERSONA] Test thoroughly: $query\r"
    }
    
    -re "g\\.mentor (.+)" {
        set query $interact_out(1,string)
        send_user "\n👨‍🏫 Mentor Persona\n"
        send "[MENTOR PERSONA] Teach and guide: $query\r"
    }
}
EOF

chmod +x ~/.gemini-advanced/bin/gemini-wrapper

# Create Python-based wrapper (alternative)
cat > ~/.gemini-advanced/bin/gemini-interactive << 'EOF'
#!/usr/bin/env python3
import subprocess
import sys
import re
import readline

class GeminiWrapper:
    def __init__(self):
        self.commands = {
            'g.help': self.show_help,
            'g.': self.standard_mode,
            'gt.': self.think_mode,
            'gth.': self.think_hard_mode,
            'gu.': self.ultra_think_mode,
            'g.arch': self.architect_persona,
            'g.debug': self.debugger_persona,
            'g.sec': self.security_persona,
            'g.front': self.frontend_persona,
            'g.back': self.backend_persona,
            'g.perf': self.performance_persona,
            'g.qa': self.qa_persona,
            'g.mentor': self.mentor_persona,
        }
        
        self.prompts = {
            'g.': '',
            'gt.': '[THINK MODE] Think step by step: ',
            'gth.': '[THINK HARD MODE - CRITICAL ANALYSIS] Analyze critically with deep reasoning: ',
            'gu.': '[ULTRA THINK MODE - EXHAUSTIVE ANALYSIS] Provide COMPLETE analysis including ALL aspects, edge cases, alternatives: ',
            'g.arch': '[ARCHITECT PERSONA] Design with scalability and maintainability: ',
            'g.debug': '[DEBUGGER PERSONA] Systematically analyze and solve: ',
            'g.sec': '[SECURITY PERSONA] Analyze threats and vulnerabilities: ',
            'g.front': '[FRONTEND PERSONA] Focus on UX and user needs: ',
            'g.back': '[BACKEND PERSONA] Design for reliability and performance: ',
            'g.perf': '[PERFORMANCE PERSONA] Optimize for speed: ',
            'g.qa': '[QA PERSONA] Test thoroughly: ',
            'g.mentor': '[MENTOR PERSONA] Teach and guide: ',
        }
    
    def show_help(self, query=''):
        print("\n📚 Gemini Advanced Commands:")
        print("  g. <query>     - Standard mode")
        print("  gt. <query>    - Think mode (detailed analysis)")
        print("  gth. <query>   - Think hard mode (critical thinking)")
        print("  gu. <query>    - Ultra think mode (exhaustive analysis)")
        print("\n🎭 Personas:")
        print("  g.arch <q>     - Architect (system design)")
        print("  g.debug <q>    - Debugger (problem solving)")
        print("  g.sec <q>      - Security (threat analysis)")
        print("  g.front <q>    - Frontend (UX focus)")
        print("  g.back <q>     - Backend (reliability)")
        print("  g.perf <q>     - Performance (optimization)")
        print("  g.qa <q>       - QA (testing)")
        print("  g.mentor <q>   - Mentor (teaching)\n")
        return None
    
    def process_command(self, cmd, query):
        if cmd in self.prompts:
            prompt = self.prompts[cmd] + query
            return prompt
        return None
    
    def standard_mode(self, query):
        return self.process_command('g.', query)
    
    def think_mode(self, query):
        print("💭 Think Mode Activated")
        return self.process_command('gt.', query)
    
    def think_hard_mode(self, query):
        print("🤔 Think Hard Mode Activated")
        return self.process_command('gth.', query)
    
    def ultra_think_mode(self, query):
        print("🧠 Ultra Think Mode Activated")
        return self.process_command('gu.', query)
    
    def architect_persona(self, query):
        print("🏗️ Architect Persona")
        return self.process_command('g.arch', query)
    
    def debugger_persona(self, query):
        print("🐛 Debugger Persona")
        return self.process_command('g.debug', query)
    
    def security_persona(self, query):
        print("🔒 Security Persona")
        return self.process_command('g.sec', query)
    
    def frontend_persona(self, query):
        print("🎨 Frontend Persona")
        return self.process_command('g.front', query)
    
    def backend_persona(self, query):
        print("⚙️ Backend Persona")
        return self.process_command('g.back', query)
    
    def performance_persona(self, query):
        print("⚡ Performance Persona")
        return self.process_command('g.perf', query)
    
    def qa_persona(self, query):
        print("✅ QA Persona")
        return self.process_command('g.qa', query)
    
    def mentor_persona(self, query):
        print("👨‍🏫 Mentor Persona")
        return self.process_command('g.mentor', query)
    
    def run(self):
        print("🚀 Gemini Advanced Interactive Mode")
        print("Type 'g.help' for commands, 'exit' to quit\n")
        
        # Start gemini process
        proc = subprocess.Popen(
            ['gemini'],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=0
        )
        
        try:
            while True:
                user_input = input("> ")
                
                if user_input.lower() in ['exit', 'quit']:
                    break
                
                # Check for special commands
                handled = False
                for cmd in self.commands:
                    if user_input.startswith(cmd):
                        if cmd == 'g.help':
                            self.show_help()
                            handled = True
                        else:
                            query = user_input[len(cmd):].strip()
                            if query:
                                prompt = self.commands[cmd](query)
                                if prompt:
                                    proc.stdin.write(prompt + '\n')
                                    proc.stdin.flush()
                                handled = True
                        break
                
                if not handled:
                    # Pass through to gemini
                    proc.stdin.write(user_input + '\n')
                    proc.stdin.flush()
                
                # Read response (simplified - real implementation needs better handling)
                # This is a placeholder - actual implementation would need async reading
        
        except KeyboardInterrupt:
            print("\nExiting...")
        finally:
            proc.terminate()

if __name__ == '__main__':
    wrapper = GeminiWrapper()
    wrapper.run()
EOF

chmod +x ~/.gemini-advanced/bin/gemini-interactive

echo "✅ Gemini Wrapper installed!"
echo ""
echo "🚀 Usage:"
echo "  gemini-wrapper     # Expect-based wrapper (recommended)"
echo "  gemini-interactive # Python-based wrapper"
echo ""
echo "The wrapper intercepts your commands and transforms them before sending to Gemini."