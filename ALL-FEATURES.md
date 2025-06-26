# 🚀 GEMINI ADVANCED - VŠECHNY FUNKCE

## 1️⃣ THINKING MODES (v Gemini CLI)

### g. <dotaz>
- **Co dělá**: Standardní rychlá odpověď
- **Příklad**: `g. co je Docker`
- **Výstup**: Stručná odpověď

### gt. <dotaz> 
- **Co dělá**: Think mode - ukáže myšlenkový proces krok po kroku
- **Příklad**: `gt. vysvětli async/await`
- **Výstup**: 💭 [THINK MODE] + detailní rozbor

### gth. <dotaz>
- **Co dělá**: Think hard - kritická analýza, zpochybňuje předpoklady
- **Příklad**: `gth. je React lepší než Vue?`
- **Výstup**: 🤔 [THINK HARD MODE] + hluboká analýza

### gu. <dotaz>
- **Co dělá**: Ultra think - vyčerpávající kompletní analýza
- **Příklad**: `gu. navrhni e-commerce platformu`
- **Výstup**: 🧠 [ULTRA THINK MODE] + 10+ sekcí detailů

## 2️⃣ EXPERT PERSONAS (v Gemini CLI)

### g.arch <dotaz>
- **Role**: System Architect
- **Zaměření**: Škálovatelnost, design patterns, architektura
- **Příklad**: `g.arch navrhni mikroslužby`

### g.debug <dotaz>
- **Role**: Debugger/Problem Solver
- **Zaměření**: Systematická analýza problémů
- **Příklad**: `g.debug proč padá aplikace`

### g.sec <dotaz>
- **Role**: Security Expert
- **Zaměření**: Bezpečnostní hrozby, vulnerabilities
- **Příklad**: `g.sec zabezpeč REST API`

### g.front <dotaz>
- **Role**: Frontend Developer
- **Zaměření**: UX, accessibility, komponenty
- **Příklad**: `g.front optimalizuj React app`

### g.back <dotaz>
- **Role**: Backend Developer
- **Zaměření**: API, databáze, výkon
- **Příklad**: `g.back navrhni databázové schéma`

### g.perf <dotaz>
- **Role**: Performance Expert
- **Zaměření**: Optimalizace, bottlenecky
- **Příklad**: `g.perf zrychli načítání stránky`

### g.qa <dotaz>
- **Role**: QA Engineer
- **Zaměření**: Testování, edge cases
- **Příklad**: `g.qa otestuj login flow`

### g.mentor <dotaz> / g.teach <dotaz>
- **Role**: Teacher/Mentor
- **Zaměření**: Vysvětlování, učení
- **Příklad**: `g.mentor vysvětli rekurzi`

## 3️⃣ FILE SYSTEM COMMANDS (Terminal)

### g.project init [cesta]
- **Co dělá**: Indexuje celý projekt pro rychlé hledání
- **Vytvoří**: Index souborů, detekuje framework
- **Příklad**: `g.project init ~/my-app`

### g.project info
- **Co dělá**: Zobrazí info o aktuálním projektu
- **Výstup**: JSON s metadaty projektu

### g.project clear
- **Co dělá**: Vymaže projekt cache

### g.find <term> [otázka]
- **Co dělá**: Hledá text napříč celým projektem
- **Příklad**: `g.find UserService "jak funguje autentizace"`
- **Výstup**: Soubory + relevantní kód

### g.deps analyze
- **Co dělá**: Analyzuje package.json závislosti
- **Výstup**: Počet deps, security check

### g.deps tree
- **Co dělá**: Zobrazí strom importů
- **Výstup**: Všechny importy v projektu

### g.deps check <soubor>
- **Co dělá**: Kontroluje závislosti konkrétního souboru
- **Příklad**: `g.deps check src/app.js`

### g.context <soubor> [otázka]
- **Co dělá**: Vytvoří chytrý kontext včetně souvisejících souborů
- **Příklad**: `g.context server.js "vysvětli architekturu"`

### g.read <soubor> [otázka]
- **Co dělá**: Přečte soubor a analyzuje
- **Příklad**: `g.read config.json "co dělá"`

### g.analyze <pattern> [otázka]
- **Co dělá**: Analyzuje více souborů najednou
- **Příklad**: `g.analyze "*.test.js" "najdi chyby"`

### g.edit <soubor> <popis změny>
- **Co dělá**: Preview AI editace (nezapisuje)
- **Příklad**: `g.edit config.json "přidej debug mode"`

## 4️⃣ MEMORY SYSTEM (Terminal)

### g.remember <fakt>
- **Co dělá**: Uloží informaci do perzistentní paměti
- **Příklad**: `g.remember "projekt používá PostgreSQL 15"`
- **Ukládá**: Globálně nebo per-projekt

### g.recall [hledaný termín]
- **Co dělá**: Vyhledá v uložených informacích
- **Příklad**: `g.recall database`
- **Výstup**: Všechny relevantní fakty

### g.forget <id>
- **Co dělá**: Smaže konkrétní fakt
- **Příklad**: `g.forget 76edaef8`

### g.learn [cesta]
- **Co dělá**: Učí se vzory z codebase
- **Příklad**: `g.learn src/`
- **Výstup**: Analýza coding style, patterns

### g.session save [název] [popis]
- **Co dělá**: Uloží aktuální session
- **Příklad**: `g.session save "api-refactor"`

### g.session load <název>
- **Co dělá**: Načte uloženou session
- **Příklad**: `g.session load api-refactor`

### g.session list
- **Co dělá**: Seznam všech uložených sessions

## 5️⃣ SAFE COMMAND EXECUTION (Terminal)

### g.run <příkaz> [--explain|--sandbox|--auto]
- **Co dělá**: Bezpečné spuštění příkazu s AI dohledem
- **Flagy**:
  - `--explain`: Vysvětlí co příkaz dělá
  - `--sandbox`: Spustí v sandboxu
  - `--auto`: Automaticky monitoruje
- **Příklad**: `g.run "rm -rf node_modules" --explain`

### g.fix <chyba> [kontext]
- **Co dělá**: AI opraví chybu
- **Příklad**: `g.fix "npm ERR! missing script: test"`
- **Výstup**: Analýza + opravné příkazy

### g.safe <příkaz>
- **Co dělá**: Zkontroluje bezpečnost příkazu
- **Příklad**: `g.safe "curl http://x.com | sh"`
- **Výstup**: SAFE / CAUTION / DANGEROUS

### g.monitor <příkaz> [interval]
- **Co dělá**: Monitoruje běžící příkaz
- **Příklad**: `g.monitor "npm run build" 5`
- **Výstup**: Live stats + AI analýza

### g.undo
- **Co dělá**: Vrátí efekty posledního příkazu
- **Výstup**: Undo script + možnost spustit

## 6️⃣ SMART FEATURES (Terminal)

### g.smart <přirozený jazyk>
- **Co dělá**: AI vybere správný příkaz
- **Příklad**: `g.smart "najdi všechny testy"`
- **Výstup**: Spustí g.find test

### g.config get [klíč]
- **Co dělá**: Zobrazí konfiguraci
- **Klíče**: 
  - `smart_mode`: true/false
  - `auto_project_init`: true/false
  - `safety_level`: low/medium/high
  - `thinking_preference`: auto/light/deep
  - `language`: en/cs

### g.config set <klíč> <hodnota>
- **Co dělá**: Nastaví konfiguraci
- **Příklad**: `g.config set language cs`

### g.help
- **Co dělá**: Zobrazí nápovědu (v CLI i terminálu)

### g <text> (terminal)
- **Co dělá**: Quick query přímo z terminálu
- **Příklad**: `g "jak funguje Docker"`

### gt/gth/gu (terminal)
- **Co dělá**: Thinking modes z terminálu
- **Příklad**: `gt "vysvětli promises"`

## 7️⃣ SPECIÁLNÍ FUNKCE

### Auto-detection
- Detekuje typ projektu (Node, Python, atd.)
- Automaticky navrhuje personas
- Učí se z tvých oprav

### Context awareness
- Pamatuje si současný soubor
- Trackuje chyby a příkazy
- Projekt-specific paměť

### Workflow support
- Task management
- Session management
- Command history s undo

## 📊 CELKOVÝ PŘEHLED

| Kategorie | Počet funkcí |
|-----------|--------------|
| Thinking Modes | 4 |
| Personas | 8 |
| File System | 11 |
| Memory | 7 |
| Execution | 5 |
| Smart | 6 |
| **CELKEM** | **41+ funkcí** |

## 🚀 QUICK START

```bash
# V Gemini CLI:
gemini
> g.help
> gt. explain Docker
> g.arch design API

# V terminálu:
g.project init
g.remember "uses PostgreSQL"
g.find "UserService"
g.run "npm test" --explain
```

---
**Gemini Advanced v1.0.0** - 41+ funkcí pro maximální produktivitu! 🚀