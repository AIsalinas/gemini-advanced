# Gemini CLI Integration - Complete Guide

## How Gemini CLI Works

### Architecture
1. **Gemini CLI** is Google's command-line AI assistant powered by Gemini 2.5 Pro
2. **Configuration**: Stored in `~/.gemini/` directory
3. **Extensions**: Located in `~/.gemini/extensions/` 
4. **System Prompts**: Loaded via `GEMINI.md` files in extensions

### Extension System
- Extensions are directories containing `gemini-extension.json`
- Each extension can include a `GEMINI.md` for system prompts
- Extensions are loaded automatically on Gemini CLI startup
- Workspace extensions override home directory extensions

## Your Setup

### What We've Implemented

1. **Created Gemini Extension** at `~/.gemini/extensions/gemini-advanced/`
   - `gemini-extension.json` - Extension configuration
   - `GEMINI.md` - System prompts for command recognition

2. **Command Recognition System**
   - Commands work INSIDE Gemini CLI interface
   - No need for bash scripts when inside Gemini
   - System recognizes patterns like `gt`, `gth`, `gu`, `g.arch`, etc.

3. **Updated Configuration**
   - Removed `--project-doc` flag from alias (now using extension system)
   - Extension loads automatically when Gemini CLI starts

### Available Commands

#### Thinking Modes
- `g <query>` - Standard response
- `gt <query>` - Think mode (detailed analysis)
- `gth <query>` - Think hard mode (critical thinking)
- `gu <query>` - Ultra think mode (exhaustive analysis)

#### Expert Personas
- `g.arch` - System architect perspective
- `g.front` - Frontend developer perspective
- `g.back` - Backend developer perspective
- `g.debug` - Systematic debugging approach
- `g.sec` - Security expert perspective
- `g.perf` - Performance optimization focus
- `g.qa` - QA and testing perspective
- `g.teach` - Clear teaching style

#### Special Commands
- `g.help` - Shows comprehensive command list

## How to Use

1. **Open a new terminal** (to load updated configuration)
2. **Run `gemini`** to start Gemini CLI
3. **Type commands directly** in Gemini CLI interface:
   ```
   > g.help
   > gt explain Docker networking
   > gu design a payment system
   > g.debug why is my API failing
   ```

## How It Works Internally

### Command Processing Flow
1. User types command in Gemini CLI
2. Extension's GEMINI.md is loaded as context
3. Gemini recognizes command patterns
4. Applies corresponding thinking mode or persona
5. Processes query with enhanced capabilities

### Why This Approach Works
- Uses Gemini CLI's native extension system
- No external dependencies or hacks
- Commands are processed by Gemini's AI model
- Seamless integration with CLI interface

## Troubleshooting

### Commands Not Working?

1. **Check Extension Loading**
   ```bash
   ls ~/.gemini/extensions/gemini-advanced/
   ```

2. **Restart Terminal and Gemini CLI**
   ```bash
   # Close terminal, open new one
   gemini
   ```

3. **Verify No Conflicting Alias**
   ```bash
   grep "alias gemini" ~/.zshrc ~/.bashrc
   ```

4. **Test with g.help**
   - If `g.help` works, other commands should too
   - If not, extension may not be loading

### Manual Testing
Run the test script:
```bash
./test-gemini-commands.sh
```

## Technical Details

### Extension Configuration
```json
{
  "name": "gemini-advanced",
  "version": "1.0.0",
  "description": "Enhanced thinking modes and personas for Gemini CLI",
  "contextFileName": "GEMINI.md"
}
```

### System Prompt Structure
- Clear command patterns at message start
- Explicit mode/persona descriptions
- Examples for each command type
- Help command always available

### Integration Points
1. **Extension Directory**: `~/.gemini/extensions/gemini-advanced/`
2. **Context File**: Loaded automatically via extension
3. **No Shell Alias Needed**: Extension handles everything
4. **Backward Compatible**: Terminal commands still work

## Future Enhancements

Consider adding:
- MCP servers for advanced tools
- Custom workflows for specific tasks
- Project-specific configurations
- Integration with other AI tools

## Summary

Your Gemini CLI now supports advanced commands directly in the interface. The extension system ensures commands are recognized and processed correctly, providing enhanced thinking modes and expert perspectives on demand.