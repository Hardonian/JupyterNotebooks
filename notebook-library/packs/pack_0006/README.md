# RAG Chunking & Embedding Prep

## What Problem This Pack Solves

Preparing documents for Retrieval-Augmented Generation (RAG) systems requires chunking text intelligently, generating embeddings, and formatting data for vector stores—a complex process that requires understanding chunking strategies, embedding models, and vector database formats. This pack eliminates that friction by automating the entire pipeline from raw documents to RAG-ready chunks with embeddings.

## What You Get

- **Text Chunking** - Intelligent document splitting with configurable chunk size and overlap
- **Embedding Generation** - Vector embeddings ready for similarity search
- **Vector Store Prep** - Formatted data structures ready for vector database ingestion

## How It Works

The notebook follows a deterministic, step-by-step process:

1. **Configuration** - Sets input/output paths, chunk size, overlap, and embedding dimensions
2. **Environment Validation** - Checks Python version and write permissions
3. **Input Loading** - Loads documents text file or generates sample documents if not provided
4. **Text Chunking** - Splits documents into overlapping chunks with sentence boundary awareness
5. **Embedding Generation** - Creates vector embeddings for each chunk
6. **Output Writing** - Saves chunks JSON and preparation report to outputs directory

The notebook is designed to run top-to-bottom without any hidden state or dependencies on prior executions. All randomness is seeded for deterministic results.

## Inputs Required

### Required
- None (pack generates sample documents if input not provided)

### Optional
- `data/documents.txt` - Your text documents (will generate sample if not provided)

### Example Inputs

```bash
# Place your documents in the data directory
cat your_documents.txt > data/documents.txt
```

## Outputs Produced

All outputs are written to the `outputs/` directory:

1. **`outputs/chunks.json`** - Complete chunk data with embeddings
   ```json
   {
     "metadata": {
       "total_chunks": 10,
       "chunk_size": 500,
       "embedding_dim": 128
     },
     "chunks": [
       {
         "chunk_id": "chunk_0001",
         "text": "Chunk text here...",
         "embedding": [0.123, -0.456, ...],
         "length": 487
       }
     ]
   }
   ```

2. **`outputs/rag_preparation_report.md`** - Preparation summary report

## Common Failure Modes + Fixes

### Error: "Python 3.10+ required"
**Fix:** Upgrade Python to 3.10 or higher. Check version with `python --version`.

### Error: "Cannot write to outputs"
**Fix:** Ensure write permissions in the current directory. Run `chmod u+w .` if needed.

### Error: "Input documents file is empty"
**Fix:** Provide a text file with content, or let the pack generate sample documents automatically.

### Warning: "Input documents not found"
**Fix:** This is normal. The pack will generate sample documents automatically. To use your own documents, place them at `data/documents.txt`.

### Note: Embedding Method
**Important:** This pack uses hash-based embeddings for demonstration. In production, replace with actual embedding models (OpenAI, Sentence Transformers, etc.) for real semantic similarity.

## License + Support Expectations

- **License:** GPL-3.0-only (see LICENSE.txt)
- **Support:** This is a commercial pack sold through the Keys marketplace. Support is provided through the marketplace platform.
- **Warranty:** Pack is provided "as-is" without warranty. Test in a development environment before production use.

## This Pack Is For

- Developers building RAG systems
- Data engineers preparing documents for vector databases
- ML engineers setting up retrieval pipelines
- Teams implementing semantic search

## This Pack Is NOT For

- Complete beginners to Python (requires Python 3.10+ knowledge)
- Users needing production-ready embeddings (this uses demo embeddings)
- Projects requiring proprietary/closed-source licensing (pack is GPL-3.0)
- Users who need multi-format document support (text files only)

## Technical Details

- **Runtime:** ~15 minutes (depends on document size)
- **Dependencies:** Standard library only (see requirements.txt)
- **Deterministic:** Yes - all randomness seeded, no hidden state
- **Idempotent:** Yes - can be run multiple times safely (overwrites outputs)
- **Embedding Method:** Hash-based (replace with production embedding model)
- **Chunking Strategy:** Sentence-aware with configurable size and overlap

## Next Steps After Running

1. Review `outputs/chunks.json` for chunk structure
2. Check `outputs/rag_preparation_report.md` for summary
3. Replace hash-based embeddings with production embedding model
4. Import chunks into vector database (Pinecone, Weaviate, Chroma, etc.)
5. Set up similarity search and retrieval pipeline

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-04
