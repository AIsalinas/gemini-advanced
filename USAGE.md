# 🚀 Gemini Advanced - Použití

## Jak to funguje

Po instalaci můžeš používat rozšířené příkazy přímo v Gemini CLI!

## Rychlý start

1. **Spusť Gemini:**
   ```bash
   gemini
   ```

2. **Zkus tyto příkazy:**

### Základní příkazy
```
g.help                      # Zobrazí všechny příkazy
g. jak funguje async/await  # Rychlá odpověď
gt. vysvětli promises       # Krok po kroku vysvětlení
gth. analyzuj tento kód     # Kritická analýza
gu. navrhni payment systém  # Kompletní analýza
```

### Personas (experti)
```
g.arch navrhni mikroslužby     # Architekt
g.debug proč to nefunguje      # Debugger
g.sec zabezpeč API             # Security expert
g.front navbar component       # Frontend vývojář
g.back optimalizuj databázi    # Backend vývojář
g.perf zrychli aplikaci        # Performance expert
g.qa otestuj tuto funkci       # QA inženýr
g.mentor vysvětli rekurzi      # Učitel
```

## Příklady použití

### 1. Thinking modes
```
> gt. jak funguje React Context
💭 [THINK MODE]
Nechte mě to promyslet krok po kroku:
1. Co je React Context...
2. Kdy ho používat...
[detailní vysvětlení]
```

### 2. Ultra analýza
```
> gu. navrhni e-commerce platformu
🧠 [ULTRA THINK MODE]
Poskytnu kompletní analýzu návrhu e-commerce platformy:

1. ARCHITEKTURA
   - Mikroslužby vs Monolit
   - Škálovatelnost
   [rozsáhlé detaily...]

2. KOMPONENTY
   [rozsáhlé detaily...]

[pokračuje 10+ sekcemi]
```

### 3. Personas
```
> g.sec jak zabezpečit REST API
🔒 [SECURITY PERSONA]
Z pohledu security experta analyzuji zabezpečení REST API:
- Autentizace (OAuth2, JWT)
- Rate limiting
- Input validace
[security analýza]
```

## Pokročilé funkce (Terminal)

### File System
```bash
g.project init          # Indexuje projekt
g.find "UserService"    # Hledá v projektu
g.deps analyze          # Analyzuje závislosti
g.context server.js     # Kontext souboru
```

### Paměť
```bash
g.remember "používáme PostgreSQL 15"
g.recall "database"     # Vybaví si info
g.learn                 # Učí se z kódu
g.session save          # Uloží session
```

### Bezpečné spouštění
```bash
g.run "npm test" --explain   # Vysvětlí příkaz
g.fix "TypeError..."         # Opraví chybu
g.safe "rm -rf"             # Zkontroluje bezpečnost
g.undo                      # Vrátí změny
```

## Tipy

1. **Přirozený jazyk**: Piš česky nebo anglicky
2. **Kombinuj módy**: `gu. g.sec design auth system`
3. **Kontext**: Gemini si pamatuje předchozí dotazy
4. **Zkratky**: Můžeš psát jen `g.` místo plného příkazu

## Řešení problémů

Pokud příkazy nefungují:
1. Zkontroluj: `which gemini`
2. Restartuj terminal
3. Znovu spusť: `source ~/.zshrc`
4. Zkus: `~/.gemini-advanced/bin/gemini-final`

## Další pomoc

- GitHub: https://github.com/tom28881/gemini-advanced
- Issues: https://github.com/tom28881/gemini-advanced/issues