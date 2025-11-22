# Deployment Guides

This directory contains deployment configurations and scripts for various platforms.

## Docker

### Quick Start

```bash
# Build and run
docker-compose -f deployment/docker/docker-compose.prod.yml up

# Or use the deployment script
chmod +x deployment/docker/deploy.sh
./deployment/docker/deploy.sh
```

### Production Deployment

```bash
# Set environment variables
export OPENAI_API_KEY=your_key
export DATABASE_URL=postgresql://...
export REDIS_URL=redis://...

# Deploy
docker-compose -f deployment/docker/docker-compose.prod.yml up -d
```

## Vercel

1. Install Vercel CLI: `npm i -g vercel`
2. Deploy: `vercel --prod`
3. Configure environment variables in Vercel dashboard

The `vercel.json` configuration is already set up.

## Render

1. Connect your GitHub repository to Render
2. Render will automatically detect `render.yaml`
3. Set environment variables in Render dashboard
4. Deploy

## HuggingFace Spaces

1. Create a new Space on HuggingFace
2. Upload files from `deployment/huggingface/`
3. Set environment variables (secrets) in Space settings
4. The Space will automatically build and deploy

## Environment Variables

All deployments require:

- `OPENAI_API_KEY`: Your OpenAI API key (required)
- `ANTHROPIC_API_KEY`: Your Anthropic API key (optional)

Optional:

- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string
- `ENVIRONMENT`: `production` or `development`

## Health Checks

All deployments include health check endpoints:

- Docker: `http://localhost:8000/health`
- Vercel: `https://your-app.vercel.app/health`
- Render: `https://your-app.onrender.com/health`

## Troubleshooting

### Docker

- Check logs: `docker-compose logs -f`
- Restart services: `docker-compose restart`
- Rebuild: `docker-compose build --no-cache`

### Vercel

- Check build logs in Vercel dashboard
- Verify Python version matches `vercel.json`

### Render

- Check build logs in Render dashboard
- Verify `render.yaml` syntax

### HuggingFace

- Check Space logs
- Verify `requirements.txt` includes all dependencies
