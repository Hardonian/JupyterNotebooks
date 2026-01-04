# Notebook Library Marketplace Integration

## Overview

This document describes how the Keys marketplace integrates with the Notebook Library system. The integration follows a **metadata-only, process-separated** pattern to maintain clean licensing boundaries.

## Architecture

```
Keys Marketplace (MIT License)
    │
    ├─ Reads: /notebook-library/library.json (metadata only)
    │
    ├─ Serves: Pack zip files (separate distribution)
    │
    └─ Executes: Notebooks as subprocesses (no code import)
```

## Integration Contract

### 1. Library Index

**Location**: `/notebook-library/library.json`

**Schema**:
```json
{
  "version": "1.0.0",
  "generated_at": "ISO timestamp",
  "total_packs": 6,
  "packs": [
    {
      "id": "pack_0001",
      "slug": "agentic-ai-master",
      "title": "Agentic AI Master Notebook",
      "version": "1.0.0",
      "category": "ai_ops",
      "difficulty": "intermediate",
      "runtime_minutes": 180,
      "description": "...",
      "tags": ["ai", "agents", ...]
    }
  ]
}
```

**Usage**: Keys reads this file to populate marketplace catalog.

### 2. Pack Metadata

**Location**: `/notebook-library/packs/<pack_id>/pack.json`

**Key Fields for Marketplace**:
- `id`, `slug`, `title`, `version`
- `category`, `difficulty`, `runtime_minutes`
- `description`, `tags`
- `license.spdx` (for display)
- `assets.cover`, `assets.preview_html` (for UI)

**Usage**: Keys displays pack information, pricing, previews.

### 3. Pack Distribution

**Format**: ZIP files containing:
- `main.ipynb` (notebook)
- `pack.json` (metadata)
- `README.md`, `quickstart.md` (documentation)
- `requirements.txt` or `pyproject.toml` (dependencies)
- `LICENSE.txt` (license file)
- `data/` (sample data, optional)
- `assets/` (cover images, flow diagrams)

**Delivery**: Keys serves zip files for customer download.

### 4. Pack Execution

**Pattern**: Process separation (no code import)

```python
# ✅ CORRECT: Execute as subprocess
import subprocess
result = subprocess.run([
    "jupyter", "nbconvert",
    "--to", "notebook",
    "--execute", "main.ipynb"
], cwd=pack_directory)

# ❌ WRONG: Import pack code
from notebook_library.packs.pack_0001 import main  # NO!
```

## Marketplace API Contract

### Endpoints (Conceptual)

```
GET /api/notebook-library/packs
  → Returns library.json packs array

GET /api/notebook-library/packs/:id
  → Returns pack.json for specific pack

GET /api/notebook-library/packs/:id/download
  → Returns pack zip file

POST /api/notebook-library/packs/:id/execute
  → Executes pack notebook (subprocess)
  → Returns execution results/outputs
```

### Data Flow

1. **Catalog Display**:
   - Keys reads `library.json`
   - Displays packs with metadata
   - Shows cover images from `assets/cover.png`

2. **Pack Purchase**:
   - Customer purchases pack
   - Keys generates download link
   - Customer downloads zip file

3. **Pack Execution** (Optional):
   - Customer uploads pack to Keys execution environment
   - Keys runs notebook as subprocess
   - Returns outputs to customer

## Pricing Integration

### Pack Pricing Fields

Add to `pack.json` (future enhancement):
```json
{
  "pricing": {
    "currency": "USD",
    "amount": 29.99,
    "tier": "premium"
  }
}
```

### Marketplace Pricing Model

- **Pack Price**: Set by pack creator/licensor
- **Platform Fee**: Keys takes X% (handled at payment level)
- **Revenue Split**: Pack creator receives (100 - X)%

## UI Components

### Pack Card Display

```typescript
interface PackCard {
  id: string;
  title: string;
  category: string;
  difficulty: "beginner" | "intermediate" | "advanced";
  runtime_minutes: number;
  cover_image_url: string;
  price: number;
  tags: string[];
}
```

### Pack Detail Page

- Title, description, category
- Cover image, flow diagram
- Inputs/outputs table
- Quick start guide
- Purchase/download button
- Preview HTML (if available)

## Security Considerations

1. **Sandbox Execution**: Run notebooks in isolated environments
2. **Input Validation**: Validate pack.json schema before processing
3. **Resource Limits**: Set timeouts and memory limits for execution
4. **Output Sanitization**: Sanitize notebook outputs before display

## Implementation Checklist

- [ ] Create API endpoint to read `library.json`
- [ ] Implement pack metadata caching
- [ ] Build pack download endpoint
- [ ] Create subprocess execution service
- [ ] Add pack preview rendering
- [ ] Implement pricing integration
- [ ] Add pack search/filter by category/tags
- [ ] Create pack execution monitoring
- [ ] Add pack version management

## Example Integration Code

```python
# keys/marketplace/notebook_library.py

import json
from pathlib import Path
import subprocess

class NotebookLibraryClient:
    def __init__(self, library_path: Path):
        self.library_path = library_path
        self.library_json_path = library_path / "library.json"
    
    def get_packs(self) -> list[dict]:
        """Get all packs from library.json"""
        with open(self.library_json_path) as f:
            data = json.load(f)
        return data["packs"]
    
    def get_pack_metadata(self, pack_id: str) -> dict:
        """Get metadata for specific pack"""
        pack_dir = self.library_path / "packs" / pack_id
        pack_json_path = pack_dir / "pack.json"
        with open(pack_json_path) as f:
            return json.load(f)
    
    def execute_pack(self, pack_id: str, inputs: dict = None) -> dict:
        """Execute pack notebook (subprocess, no code import)"""
        pack_dir = self.library_path / "packs" / pack_id
        notebook_path = pack_dir / "main.ipynb"
        
        result = subprocess.run(
            ["jupyter", "nbconvert", "--to", "notebook", "--execute", str(notebook_path)],
            cwd=pack_dir,
            capture_output=True,
            timeout=900
        )
        
        return {
            "success": result.returncode == 0,
            "stdout": result.stdout.decode(),
            "stderr": result.stderr.decode()
        }
```

## Next Steps

1. **Phase 1**: Read library.json, display packs in marketplace
2. **Phase 2**: Implement pack download and zip serving
3. **Phase 3**: Add pack execution service (subprocess-based)
4. **Phase 4**: Integrate pricing and payment processing
5. **Phase 5**: Add pack preview and search functionality

---

**Last Updated**: 2025-01-XX  
**Maintained By**: Keys Marketplace Team
