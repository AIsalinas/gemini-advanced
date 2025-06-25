# Quick Start Guide

## Installation (2 minutes)

```bash
# One-line install
curl -sSL https://raw.githubusercontent.com/yourusername/gemini-advanced/main/install.sh | bash

# Restart terminal or
source ~/.zshrc
```

## First Commands

### 1. Test Installation
```bash
g.help
```

### 2. Try Thinking Modes

```bash
# Standard
g "What is React?"

# Think mode (detailed)
gt "What is React?"

# Think hard (comprehensive)
gth "What is React?"

# Ultra think (exhaustive)
gu "What is React?"
```

Notice how each mode provides progressively deeper analysis!

### 3. Try Personas

```bash
# Ask different experts the same question
g.arch "How to handle user authentication?"
g.front "How to handle user authentication?"
g.back "How to handle user authentication?"
g.sec "How to handle user authentication?"
```

Each persona gives a different perspective!

## Inside Gemini CLI

```bash
gemini

# Now type:
> g.help
> gu analyze this code: function add(a,b) { return a+b }
> g.debug why would this fail
```

## Real-World Examples

### Debugging
```bash
g.debug "API returns 500 on POST /users"
```

### Architecture Design
```bash
g.arch "Design a real-time chat system"
```

### Security Review
```bash
g.sec "Review this auth flow for vulnerabilities"
```

### Learning
```bash
g.teach "Explain closures in JavaScript"
```

## Pro Tips

1. **Combine modes with personas**: Think deeply about specific aspects
2. **Use `gu` for critical decisions**: When you need exhaustive analysis
3. **Use `g.debug` for systematic troubleshooting**: It thinks like a debugger
4. **Save responses**: Pipe to files for documentation

## Next Steps

- Read [Full Documentation](../README.md)
- Learn about [Custom Personas](PERSONAS.md)
- See [Advanced Examples](EXAMPLES.md)

Happy coding with Gemini Advanced! 🚀