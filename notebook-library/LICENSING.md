# Licensing and Legal Boundaries

## Overview

This document explains the licensing boundaries between the **Keys Marketplace** repository and the **Notebook Library** system to ensure clean legal separation and prevent license contamination.

## License Status

### Notebook Library

The Notebook Library (`/notebook-library/`) is currently licensed under **GPL-3.0-only** (inherited from the seed notebook pack). This means:

- All packs in the library are GPL-3.0-only licensed
- Any code derived from the seed pack must remain GPL-3.0-only
- New packs created clean-room (without copying GPL code) can be licensed differently (MIT, Proprietary, etc.)

### Keys Repository

The Keys repository maintains its own license (MIT or as specified in its LICENSE file). **Keys code must NOT import or copy GPL-licensed code from the notebook library** to avoid GPL contamination.

## Integration Strategy

### Clean Integration Pattern

The Keys marketplace integrates with the Notebook Library through:

1. **Metadata Contract Only**: Keys reads `/notebook-library/library.json` which contains only metadata (titles, descriptions, versions, etc.) - no code.

2. **Separate Distribution**: Notebook packs are distributed as separate zip files. Keys marketplace serves these zips but does not execute or import their code.

3. **API Contract**: If Keys needs to interact with packs, it should do so through:
   - File system operations (reading pack.json metadata)
   - HTTP/API calls to pack execution services (if packs are run as services)
   - Process execution (running notebooks as subprocesses, not importing code)

### What Keys CAN Do

✅ Read `library.json` metadata  
✅ Display pack information in marketplace UI  
✅ Serve pack zip files for download  
✅ Execute notebooks as subprocesses (via jupyter nbconvert)  
✅ Reference pack metadata in documentation  

### What Keys CANNOT Do

❌ Import Python modules from notebook library  
❌ Copy GPL-licensed code into Keys codebase  
❌ Link against notebook library code statically  
❌ Include notebook library code in Keys distribution  

## Pack Licensing

### Current Packs

- **Pack 0001** (Agentic AI Master): GPL-3.0-only (derived from seed)
- **Packs 0002-0006**: GPL-3.0-only (currently, but can be relicensed if clean-room)

### Future Pack Licensing

New packs can be licensed as:

- **MIT**: For maximum compatibility and commercial use
- **Proprietary**: For paid/commercial packs
- **GPL-3.0-only**: If derived from existing GPL packs

Each pack's license is specified in:
- `pack.json` → `license.spdx`
- `LICENSE.txt` file in pack directory

## Commercial Distribution

### Selling Notebook Packs

Keys marketplace can sell notebook packs without importing their code:

1. **Pack Distribution**: Packs are distributed as zip files
2. **Customer Download**: Customers download and run packs locally
3. **No Code Import**: Keys never imports pack code into its own codebase
4. **Metadata Only**: Keys only reads metadata for display/management

This pattern allows:
- GPL packs to be sold (as GPL allows selling)
- Non-GPL packs to be sold commercially
- Keys to remain MIT-licensed

### Revenue Model

- Pack sales revenue goes to pack creators/licensors
- Keys marketplace takes a platform fee (handled at payment level, not code level)
- No code sharing = clean legal boundaries

## Compliance Checklist

Before integrating notebook library with Keys:

- [ ] Verify Keys does not import notebook library Python modules
- [ ] Ensure only metadata (JSON) is read from library
- [ ] Confirm pack execution happens in separate processes
- [ ] Document integration pattern in Keys codebase
- [ ] Review pack licenses before listing in marketplace
- [ ] Ensure pack LICENSE.txt files are included in distributions

## Questions?

For licensing questions, consult:
- GPL-3.0 FAQ: https://www.gnu.org/licenses/gpl-faq.html
- Software licensing attorney (for commercial distribution)

---

**Last Updated**: 2025-01-XX  
**Maintained By**: Notebook Library Team
