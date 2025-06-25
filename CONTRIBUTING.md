# Contributing to Gemini Advanced

First off, thank you for considering contributing to Gemini Advanced! 🎉

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed**
- **Explain which behavior you expected to see instead**
- **Include screenshots if possible**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- **Use a clear and descriptive title**
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the steps**
- **Describe the current behavior and explain which behavior you expected**
- **Explain why this enhancement would be useful**

### Pull Requests

1. Fork the repo and create your branch from `main`
2. If you've added code that should be tested, add tests
3. Ensure the test suite passes
4. Make sure your code follows the existing style
5. Issue that pull request!

## Development Process

1. **Fork & Clone**
   ```bash
   git clone https://github.com/yourusername/gemini-advanced.git
   cd gemini-advanced
   ```

2. **Create a branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make your changes**
   - Add new personas in `personas/`
   - Add new commands in `bin/`
   - Update documentation

4. **Test locally**
   ```bash
   ./install.sh
   # Test your changes
   ```

5. **Commit your changes**
   ```bash
   git commit -m 'Add some amazing feature'
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Open a Pull Request**

## Adding New Personas

To add a new persona:

1. Create a YAML file in `personas/`:
   ```yaml
   name: data_scientist
   description: "Data analysis and ML focus"
   system_prompt_addon: |
     You are a senior data scientist...
   ```

2. Create a command in `bin/`:
   ```bash
   #!/bin/bash
   # g.data
   echo "🎭 Using data scientist persona"
   gemini --prompt "[DATA SCIENTIST PERSONA] $*"
   ```

3. Update documentation

## Style Guide

### Bash Scripts
- Use `#!/bin/bash` shebang
- Quote variables: `"$var"`
- Use `[[ ]]` for conditionals
- Add meaningful comments

### Documentation
- Use clear, concise language
- Include examples
- Keep README under 500 lines
- Update docs with new features

### Commit Messages
- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests

## Testing

Before submitting:
- Test all thinking modes
- Test all personas
- Test installation on clean system
- Verify documentation is accurate

## Questions?

Feel free to open an issue with the label "question" or reach out to the maintainers.

Thank you for contributing! 🚀