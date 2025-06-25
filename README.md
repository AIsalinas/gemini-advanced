# 🚀 Gemini Advanced

Transform Google's Gemini CLI into a powerful AI assistant with thinking modes, personas, and enhanced capabilities inspired by Claude Code.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Node](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen.svg)

## 🌟 Features

### 🧠 Thinking Modes
- **Standard** (`g`) - Quick responses
- **Think** (`gt`) - Detailed analysis
- **Think Hard** (`gth`) - Deep critical thinking
- **Ultra Think** (`gu`) - Exhaustive analysis

### 🎭 Expert Personas
- **Architect** (`g.arch`) - System design & scalability
- **Frontend** (`g.front`) - UI/UX & user experience
- **Backend** (`g.back`) - APIs & data integrity
- **Debugger** (`g.debug`) - Systematic problem solving
- **Security** (`g.sec`) - Threat modeling & defense
- **Performance** (`g.perf`) - Optimization & profiling
- **QA** (`g.qa`) - Testing & quality assurance
- **Mentor** (`g.teach`) - Clear explanations & teaching

## 📦 Installation

### Quick Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/yourusername/gemini-advanced/main/install.sh | bash
```

### Manual Install

```bash
# Clone the repository
git clone https://github.com/yourusername/gemini-advanced.git
cd gemini-advanced

# Run installer
./install.sh
```

### Prerequisites
- Node.js 18+
- Gemini CLI (`npm install -g @google/gemini-cli`)
- macOS or Linux (Windows via WSL2)

## 🎯 Usage

### In Terminal

```bash
# Thinking modes
g "What is React?"              # Quick answer
gt "Analyze this error"         # Detailed analysis
gth "Security implications"     # Deep analysis
gu "Design payment system"      # Exhaustive analysis

# Personas
g.arch "Microservices design"   # Architecture perspective
g.debug "API returns 500"       # Debugging approach
g.teach "Explain closures"      # Teaching style
```

### Inside Gemini CLI

```bash
gemini

# Then use commands:
> g.help                        # Show all commands
> gu analyze this system        # Ultra-think mode
> g.debug why is this slow      # Debug persona
```

## 🔧 How It Works

Gemini Advanced enhances Gemini CLI by:
1. Adding command recognition patterns
2. Injecting specialized system prompts
3. Providing different thinking depths
4. Offering expert perspectives

## 📸 Examples

### Different Thinking Modes

```bash
# Standard mode
> g "What is Docker?"
Docker is a containerization platform...

# Think mode  
> gt "What is Docker?"
Let me analyze Docker comprehensively:
- Core concept: OS-level virtualization
- Architecture: Client-server model...
- Use cases: Microservices, CI/CD...

# Ultra-think mode
> gu "What is Docker?"
I'll provide an exhaustive analysis of Docker:
1. Historical context and evolution
2. Technical architecture deep-dive
3. Comparison with alternatives...
[Continues with 10+ sections]
```

### Expert Personas

```bash
# Frontend perspective
> g.front "Best way to handle forms"
From a UX perspective, form handling should...

# Backend perspective  
> g.back "Best way to handle forms"
For robust form processing, consider...

# Security perspective
> g.sec "Best way to handle forms"
Form security requires multiple layers...
```

## 🛠️ Configuration

### Customize Personas

Edit personas in `~/.gemini-advanced/personas/`:

```yaml
# frontend.yaml
name: frontend
description: "UX-focused developer"
system_prompt_addon: |
  You are a senior frontend engineer...
```

### Add Custom Commands

Create new commands in `~/.gemini-advanced/bin/`:

```bash
#!/bin/bash
# g.custom
echo "🎯 Custom persona activated"
gemini --prompt "[CUSTOM PERSONA] $*"
```

## 📚 Documentation

- [Installation Guide](docs/INSTALL.md)
- [Usage Examples](docs/EXAMPLES.md)
- [Creating Custom Personas](docs/PERSONAS.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md).

```bash
# Fork the repo
# Create your feature branch
git checkout -b feature/amazing-feature

# Commit your changes
git commit -m 'Add amazing feature'

# Push to the branch
git push origin feature/amazing-feature

# Open a Pull Request
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by [Claude Code](https://claude.ai/code)
- Built on top of [Google Gemini CLI](https://github.com/google-gemini/gemini-cli)
- Thanks to all contributors!

## 🐛 Known Issues

- Memory persistence only works for terminal commands
- Task management is terminal-only
- Some features require macOS/Linux

## 🚦 Roadmap

- [ ] Windows native support
- [ ] Memory persistence in Gemini CLI
- [ ] Custom model parameters
- [ ] Plugin system
- [ ] Web UI

---

<p align="center">
  Made with ❤️ by the community
  <br>
  <a href="https://github.com/yourusername/gemini-advanced/stargazers">⭐ Star us on GitHub!</a>
</p>