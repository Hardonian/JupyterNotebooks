# Research Assistant - Product Documentation

## PRODUCT OVERVIEW

**Product Name:** Research Assistant  
**Target User:** Researchers, analysts, students, professionals who need quick research reports  
**Core Job-to-be-Done:** Generate comprehensive research reports from a query, saving hours of manual research  
**Output Artifact:** Structured research report with summary, key findings, sources, and citations  
**Pricing Model:** Free tier (5 reports/month), Pro tier (unlimited reports, $29/month)

## PRODUCT CONTRACT

### Input Schema
- `query` (required): Research question or topic (10-1000 characters)
- `max_results` (optional): Maximum search results to analyze (1-20, default: 5)
- `include_citations` (optional): Include source citations (default: true)
- `depth` (optional): Research depth - "quick", "standard", or "comprehensive" (default: "standard")

### Output Schema
- `report_id`: Unique identifier for the report
- `query`: Original research query
- `summary`: Executive summary of findings
- `key_findings`: Array of findings with sources and relevance scores
- `sources`: Array of source URLs and metadata
- `citations`: Array of citation URLs
- `generated_at`: ISO timestamp
- `execution_time_seconds`: Execution time

## USAGE LIMITS

### Free Tier
- **5 reports per month**
- Maximum 5 results per report
- Only "quick" depth level
- All features available but limited

### Pro Tier ($29/month)
- **Unlimited reports**
- Up to 20 results per report
- All depth levels (quick, standard, comprehensive)
- Priority support

## API ENDPOINTS

### Authentication

#### Sign Up
```bash
POST /api/v1/auth/signup
{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Login
```bash
POST /api/v1/auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

Returns JWT token for subsequent requests.

### Research

#### Run Research
```bash
POST /api/v1/research
Authorization: Bearer <token>
{
  "query": "What are the latest developments in quantum computing?",
  "max_results": 5,
  "include_citations": true,
  "depth": "quick"
}
```

#### List Past Reports
```bash
GET /api/v1/research/reports
Authorization: Bearer <token>
```

#### Get Specific Report
```bash
GET /api/v1/research/reports/{report_id}
Authorization: Bearer <token>
```

#### Check Usage
```bash
GET /api/v1/research/usage
Authorization: Bearer <token>
```

### Payments

#### Upgrade to Pro
```bash
POST /api/v1/payments/upgrade
Authorization: Bearer <token>
```

Returns Stripe checkout URL (or test mode response if Stripe not configured).

## EXECUTION FLOW

1. **Input Validation**: Request validated against blueprint schema
2. **Usage Limit Check**: Backend enforces free tier limits
3. **Execution**: Real research logic executes (web search + AI analysis)
4. **Output Formatting**: Results structured per contract
5. **Logging**: Execution logged with input/output traces
6. **Usage Tracking**: Usage recorded for billing

## TRUST & AUDITABILITY

Every execution is logged with:
- Unique execution ID
- Input data (full request)
- Output data (full report)
- Execution time
- Timestamp
- User ID and Tenant ID
- Status (running, completed, failed)

All logs stored in `executions` table, queryable via API.

## MONETIZATION ENFORCEMENT

**Backend enforcement** (not just UI):
- Free tier: 5 reports/month enforced server-side
- Free tier: Max 5 results enforced server-side
- Free tier: Only "quick" depth enforced server-side
- Paid tier: Limits checked via subscription status
- Usage tracked per tenant, reset monthly

## DEPLOYMENT

### Environment Variables Required

```bash
# Database
DATABASE_URL=postgresql://user:pass@host:port/dbname

# Authentication
JWT_SECRET_KEY=your-secret-key-change-in-production

# OpenAI (required for research execution)
OPENAI_API_KEY=sk-...

# Stripe (optional, for payments)
STRIPE_SECRET_KEY=sk_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Optional: Enhanced search
SERPER_API_KEY=...  # Falls back to DuckDuckGo if not set
```

### Running Locally

```bash
# Install dependencies
pip install -e ".[dev]"

# Run migrations
alembic upgrade head

# Start API
uvicorn agent_factory.api.main:app --reload
```

### Verification

Run the verification script to test end-to-end:

```bash
python scripts/verify_product.py --url http://localhost:8000
```

This tests:
1. User signup
2. Research execution
3. Usage limit enforcement
4. Upgrade flow
5. Post-upgrade execution
6. Report listing

## PRODUCT STATUS

✅ **REALITY MODE READY**

- Zero hard-500 errors (graceful degradation everywhere)
- Lint-clean, type-safe
- Real execution (not mocked)
- Backend-enforced monetization
- Full audit trail
- Production-ready authentication
- Stripe integration (test mode supported)

## ARCHITECTURE

```
User Request
    ↓
API Route (/api/v1/research)
    ↓
ResearchService.run_research()
    ├─ Check usage limits
    ├─ Validate free tier constraints
    ├─ Create execution record
    ├─ Execute research (web search + AI)
    ├─ Format output
    ├─ Save execution result
    └─ Track usage
    ↓
ResearchReport Response
```

## FILES

- **Blueprint**: `blueprints/research_assistant/blueprint.yaml`
- **Service**: `agent_factory/services/research_service.py`
- **API Routes**: `agent_factory/api/routes/research.py`
- **Auth Routes**: `agent_factory/api/routes/auth.py`
- **Payment Routes**: `agent_factory/api/routes/payments.py`
- **Verification**: `scripts/verify_product.py`

## NEXT STEPS

1. Set up production database
2. Configure Stripe (or use test mode)
3. Set OpenAI API key
4. Deploy API
5. Run verification script
6. Start accepting users!

---

**This is REALITY MODE. Ship or fix until it ships.**
