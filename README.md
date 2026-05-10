# 🔥 Warlock GSE3 Package for WoW Midnight

Comprehensive GSE3 (Gnome Sequencer Enhanced) rotation sequences for Warlock class across all three specializations, optimized for WoW Midnight patch 12.0.x.

## 📋 Specializations

### Affliction
- Endgame PVE rotations
- Leveling AOE sequences
- Leveling Single Target
- RBG PVP rotations
- Optimized DoT management

### Demonology
- Endgame PVE rotations
- Leveling AOE sequences
- Leveling Single Target
- RBG PVP rotations
- Demon summoning optimization

### Destruction
- Endgame PVE rotations
- Leveling AOE sequences
- Leveling Single Target
- RBG PVP rotations
- Chaos Bolt optimization

## ⚡ Key Features

- GSE3 (Gnome Sequencer Enhanced) compatible sequences
- Optimized for WoW Midnight patch 12.0.x
- Adaptive rotations based on combat situation
- Resource-efficient mana management
- Cooldown optimization for maximum DPS
- WeakAuras integration signals
- Comprehensive documentation and rotation guides

## 📦 Installation

### Manual Installation
Copy the entire Warlock package to your WoW addon directory:
```
World of Warcraft/_retail_/Interface/AddOns/GSE3-Warlock-Midnight/
```

### PowerShell Installation
Run the included installation script:
```powershell
.\scripts\Install-Warlock-Package.ps1
```

Restart WoW and enable the addon in the addon manager.

## 🧪 Testing

This package includes Playwright tests for documentation verification:

```bash
# Install dependencies
npm install

# Run tests
npm test

# Run tests with UI
npm run test:ui

# View test report
npm run report
```

## 📁 Structure

```
warlock-package/
├── gse/                      # GSE3 sequences and import strings
│   ├── plugin/              # Plugin TOC files
│   └── *.lua               # Lua rotation scripts
├── specs/                   # Specialization-specific content
│   ├── Affliction/
│   ├── Demonology/
│   └── Destruction/
├── scripts/                 # Generation and installation scripts
├── research/               # Research documentation
├── docs/                    # Web documentation
└── tests/                   # Playwright tests
```

## 🔍 Code Review

This package has undergone harsh code review with:
- GitHub Copilot automated analysis
- Playwright documentation testing
- Manual institutional-grade review

See [Issue #1](https://github.com/jordanellis8686-wq/warlock-gse3-midnight/issues/1) for review details.

## 📄 License

MIT License - See LICENSE file for details

## 🔗 Links

- GitHub Repository: https://github.com/jordanellis8686-wq/warlock-gse3-midnight
- Documentation: Open `docs/index.html` in a browser

---

**Warlock GSE3 Package - Institutional Grade WoW Addon Development**
