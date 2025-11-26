# Demo Checklist

**Purpose:** Pre-demo checklist and quick recovery tips  
**Time:** 5 minutes before demo

---

## Pre-Demo Checklist

### Environment Setup

- [ ] **API Server Running**
  - Local: `uvicorn agent_factory.api.main:app --reload`
  - Production: Verify URL is accessible
  - Test: `curl http://localhost:8000/health`

- [ ] **Database Connected**
  - Migrations applied: `make migrate`
  - Connection verified: Health check shows database healthy
  - Test: `curl http://localhost:8000/health`

- [ ] **Environment Variables Set**
  - Required: `DATABASE_URL`, `OPENAI_API_KEY` (or `ANTHROPIC_API_KEY`), `JWT_SECRET_KEY`
  - Verify: `make env-check` or `python scripts/env-doctor.py`

- [ ] **LLM API Key Valid**
  - Test: Create and run a simple agent
  - If fails: Check API key, check balance/limits

### Demo Data (Optional)

- [ ] **Demo Data Seeded** (if using)
  - Run: `make seed` or `python scripts/db-seed-demo.py`
  - Verify: Agents/blueprints exist

### Demo Preparation

- [ ] **Test All Demo Steps**
  - Health check works
  - CLI agent creation works
  - API agent creation works
  - Python SDK works (if showing)
  - Blueprint install works (if showing)

- [ ] **Prepare Demo Script**
  - Review `demo/DEMO_SCRIPT.md`
  - Practice talking points
  - Prepare answers to common questions

- [ ] **Backup Plan**
  - Have production URL ready (if local fails)
  - Have screenshots/video ready (if live demo fails)
  - Have documentation links ready

---

## Quick Recovery Tips

### API Not Responding

**Symptoms:** Health check fails, API calls timeout

**Quick Fixes:**
1. Check if server is running: `ps aux | grep uvicorn`
2. Restart server: `uvicorn agent_factory.api.main:app --reload`
3. Check logs: Look for error messages
4. Check port: Verify port 8000 is not in use: `lsof -i :8000`

**Fallback:** Use production URL if local fails

---

### Database Connection Fails

**Symptoms:** Health check shows database unhealthy, migration errors

**Quick Fixes:**
1. Check database is running:
   - Local: `pg_isready`
   - Supabase: Check project status in dashboard
2. Verify `DATABASE_URL` in `.env`
3. Test connection: `python -c "from agent_factory.database.session import get_db; next(get_db())"`
4. Check firewall/network settings

**Fallback:** Use production database if local fails

---

### Authentication Errors

**Symptoms:** 401 Unauthorized, API key errors

**Quick Fixes:**
1. Verify API key is set: Check `.env` or environment variables
2. Check authorization header format: `Bearer YOUR_KEY`
3. Verify key permissions: Check key is valid and has required permissions
4. Regenerate key if needed

**Fallback:** Use demo API key (if available)

---

### Agent Not Running

**Symptoms:** Agent creation succeeds but execution fails

**Quick Fixes:**
1. Check LLM API key: Verify `OPENAI_API_KEY` or `ANTHROPIC_API_KEY` is set
2. Check API key balance/limits: Verify key has credits/quota
3. Check agent configuration: Verify instructions are valid
4. Check logs: Look for LLM API errors

**Fallback:** Use mock mode (if available) or show agent creation without execution

---

### Blueprint Not Found

**Symptoms:** Blueprint install fails, blueprint not listed

**Quick Fixes:**
1. Verify blueprints exist: `curl http://localhost:8000/api/v1/blueprints`
2. Check blueprint registry: Verify `blueprints_index.json` is valid
3. Seed demo data: `make seed` (if blueprints are in seed data)

**Fallback:** Skip blueprint demo, show agent creation instead

---

### Slow Performance

**Symptoms:** API calls take >5 seconds, agent execution slow

**Quick Fixes:**
1. Check LLM API latency: May be slow if API is experiencing issues
2. Check database connection: Verify connection pooling is working
3. Check server resources: Verify CPU/memory usage
4. Use cached responses: If available, use cached agent responses

**Fallback:** Explain that first run may be slower, subsequent runs are faster

---

### Port Already in Use

**Symptoms:** Server fails to start, "Address already in use"

**Quick Fixes:**
1. Find process: `lsof -i :8000` (macOS/Linux) or `netstat -ano | findstr :8000` (Windows)
2. Kill process: `kill -9 <PID>` (macOS/Linux) or `taskkill /PID <PID> /F` (Windows)
3. Use different port: `uvicorn agent_factory.api.main:app --port 8001`

**Fallback:** Use different port or production URL

---

## Common Demo Issues

### Issue: Demo Takes Too Long

**Solution:**
- Skip extended demo sections
- Focus on core flow (create → run agent)
- Use pre-created agents (if available)

### Issue: Viewer Asks Technical Questions

**Solution:**
- Answer honestly ("I'll check the docs")
- Defer to documentation: "See `docs/ARCHITECTURE_DETAILED.md`"
- Follow up after demo

### Issue: Viewer Wants to See Specific Feature

**Solution:**
- If available: Show it
- If not: "That's on our roadmap, let me show you what we have now"
- Follow up: "I'll send you details after the demo"

---

## Post-Demo Checklist

- [ ] **Share Resources**
  - Documentation links
  - GitHub repo
  - Demo video (if available)

- [ ] **Follow Up**
  - Answer any unanswered questions
  - Send additional resources
  - Schedule follow-up if needed

- [ ] **Document Issues**
  - Note any problems encountered
  - Update demo checklist if needed
  - Fix issues for next demo

---

## Demo Environment Recommendations

### For Live Demos

**Recommended Setup:**
- Production URL (most reliable)
- Pre-created demo agents
- Screenshots/video backup

**Avoid:**
- Local development environment (may have issues)
- Unstable features
- Complex workflows (keep it simple)

### For Recorded Demos

**Recommended Setup:**
- Production URL
- Pre-recorded video
- Edited highlights

**Benefits:**
- No live issues
- Can edit mistakes
- Can add annotations

---

## Emergency Contacts

**If Demo Fails Completely:**
- Have backup demo video ready
- Have screenshots ready
- Have documentation links ready
- Explain: "Let me show you the docs instead"

---

**See Also:**
- `demo/DEMO_PATH.md` - Demo steps
- `demo/DEMO_SCRIPT.md` - Talking points
- `docs/demo-script.md` - Detailed demo script
- `docs/SETUP_LOCAL.md` - Setup guide

---

**Last Updated:** 2024-01-XX  
**Maintained by:** Venture OS Supervisor
