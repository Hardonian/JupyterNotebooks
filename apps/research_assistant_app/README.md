# Research Assistant App

A complete example application built with Agent Factory Platform, demonstrating how to create a production-ready AI research assistant.

## Features

- 🔬 **AI-Powered Research**: Query and get comprehensive research results
- 🎨 **Auto-Generated UI**: Beautiful, responsive web interface
- 🚀 **FastAPI Backend**: Production-ready REST API
- 📊 **Research History**: Track past research queries
- 🐳 **Docker Support**: Easy deployment with Docker
- 📝 **API Documentation**: Auto-generated OpenAPI docs

## Quick Start

### Local Development

1. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Set environment variables**:
   ```bash
   export OPENAI_API_KEY=your_key_here
   export ANTHROPIC_API_KEY=your_key_here  # Optional
   ```

3. **Run the application**:
   ```bash
   python main.py
   ```

4. **Access the app**:
   - Web UI: http://localhost:8000
   - API Docs: http://localhost:8000/docs
   - Health Check: http://localhost:8000/health

### Docker Deployment

1. **Build the image**:
   ```bash
   docker build -t research-assistant-app .
   ```

2. **Run the container**:
   ```bash
   docker run -p 8000:8000 \
     -e OPENAI_API_KEY=your_key_here \
     research-assistant-app
   ```

### Docker Compose

```bash
docker-compose up
```

## API Endpoints

### POST `/api/v1/research`

Perform a research query.

**Request**:
```json
{
  "query": "What is artificial intelligence?",
  "max_results": 5,
  "include_citations": true
}
```

**Response**:
```json
{
  "query": "What is artificial intelligence?",
  "results": [
    {
      "content": "...",
      "rank": 1
    }
  ],
  "summary": "AI is...",
  "citations": [],
  "timestamp": "2024-01-01T12:00:00"
}
```

### GET `/api/v1/history`

Get research history (last 10 queries).

### GET `/health`

Health check endpoint.

## Architecture

```
research_assistant_app/
├── main.py              # FastAPI application
├── requirements.txt     # Python dependencies
├── Dockerfile          # Docker configuration
├── docker-compose.yml  # Docker Compose config
└── README.md           # This file
```

## Customization

### Adding Custom Tools

Modify `main.py` to add custom tools:

```python
from agent_factory.tools.decorator import function_tool

@function_tool
def custom_tool(input: str) -> str:
    """Your custom tool."""
    return "result"

agent = Agent(
    id="research-assistant",
    name="Research Assistant",
    instructions="...",
    tools=[custom_tool]
)
```

### Styling the UI

Edit the HTML/CSS in the `root()` function in `main.py` to customize the UI appearance.

### Adding Database

Replace in-memory storage with a database:

```python
from sqlalchemy import create_engine
from agent_factory.database.session import SessionLocal

# Use database instead of research_history list
```

## Deployment Options

### Render

1. Connect your GitHub repository
2. Set build command: `pip install -r requirements.txt`
3. Set start command: `python main.py`
4. Add environment variables

### Vercel

See `vercel.json` in deployment templates.

### HuggingFace Spaces

See `huggingface/` directory in deployment templates.

## Environment Variables

- `OPENAI_API_KEY`: Required - OpenAI API key
- `ANTHROPIC_API_KEY`: Optional - Anthropic API key
- `PORT`: Optional - Port to run on (default: 8000)

## License

GPL-3.0 - See LICENSE file in Agent Factory repository.

## Support

- Documentation: https://docs.agentfactory.io
- Issues: https://github.com/agentfactory/platform/issues
- Email: support@agentfactory.io
