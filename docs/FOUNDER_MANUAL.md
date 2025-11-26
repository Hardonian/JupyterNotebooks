# Founder Manual

**For:** Non-technical founders who need to get things done  
**Style:** Step-by-step, no fluff, actionable commands

---

## Section 1: MUST DO NOW (Blockers)

### 1.1 Get App Running Locally

**Why:** You need to see it work before anything else.

**Steps:**
```bash
# 1. Clone repo
git clone https://github.com/agentfactory/platform.git
cd platform

# 2. Install Python dependencies
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -e ".[dev]"

# 3. Set up environment
cp .env.example .env
# Edit .env - you MUST set:
# - DATABASE_URL (get from Supabase dashboard)
# - OPENAI_API_KEY (get from OpenAI)
# - JWT_SECRET_KEY (run: openssl rand -hex 32)

# 4. Set up database
make migrate

# 5. Start server
uvicorn agent_factory.api.main:app --reload

# 6. Test it works
curl http://localhost:8000/health
```

**If it fails:** See `docs/SETUP_LOCAL.md` troubleshooting section.

**Time:** 15-30 minutes

---

### 1.2 Deploy to Production

**Why:** Investors need to see a live demo.

**Steps:**

**Option A: Vercel (Easiest)**
1. Create Vercel account: https://vercel.com
2. Create new project, connect GitHub repo
3. Set environment variables in Vercel dashboard:
   - `DATABASE_URL` (production database)
   - `OPENAI_API_KEY`
   - `JWT_SECRET_KEY`
   - (See `.env.example` for full list)
4. Deploy (automatic via GitHub Actions or manual)

**Option B: Render**
1. Create Render account: https://render.com
2. Create new Web Service
3. Connect GitHub repo
4. Set environment variables
5. Deploy

**Full Guide:** `docs/deploy-strategy.md`

**Time:** 30-60 minutes

**TODO:** [ ] Deploy to production  
**TODO:** [ ] Test production URL works  
**TODO:** [ ] Share production URL with team

---

### 1.3 Get First Real User

**Why:** You need customer validation for YC application.

**Steps:**
1. Deploy to production (see 1.2)
2. Find 3-5 potential users (friends, colleagues, beta testers)
3. Give them access, ask them to try it
4. Interview them: "What did you try? What worked? What didn't?"
5. Document feedback in `yc/EARLY_ADOPTERS.md`

**Time:** 1-2 weeks

**TODO:** [ ] Get 3-5 early users  
**TODO:** [ ] Document feedback  
**TODO:** [ ] Get testimonials (even brief ones)

---

## Section 2: DO THIS SOON (NEXT)

### 2.1 Collect Real Metrics

**Why:** YC asks for metrics. You need real numbers.

**Steps:**
1. Deploy telemetry (already built, just needs deployment)
2. Use the app yourself, generate some activity
3. Check metrics endpoint: `curl http://localhost:8000/metrics`
4. Document baseline in `yc/METRICS_SNAPSHOT.md`:
   - User count (even if 0)
   - Agent runs (even if 0)
   - Revenue (even if $0)

**Metrics to Track:**
- Users: Signups, activations, retention
- Usage: Agent runs, API calls
- Revenue: MRR, ARR (when you have paying customers)

**See:** `yc/YC_METRICS_CHECKLIST.md` for full list

**Time:** Ongoing

**TODO:** [ ] Deploy telemetry  
**TODO:** [ ] Document current metrics  
**TODO:** [ ] Set up metrics dashboard (Mixpanel/Amplitude)

---

### 2.2 Document Team/Founders

**Why:** YC needs to know who you are.

**Steps:**
1. Create `yc/TEAM.md`:
   - Founder names and backgrounds
   - Why you're building this
   - Previous experience
2. Create `yc/FOUNDER_MARKET_FIT.md`:
   - Why these founders for this problem
   - Domain expertise
   - Personal connection to problem

**Template:**
```markdown
# Team

## Founder 1: [Name]
- Background: [Previous roles, companies]
- Why this problem: [Personal story]
- Skills: [Technical, business, domain]

## Founder 2: [Name]
- Background: ...
```

**Time:** 1-2 hours

**TODO:** [ ] Write team bios  
**TODO:** [ ] Document founder-market fit story

---

### 2.3 Create Screenshots/Demo Video

**Why:** Visual proof is powerful.

**Steps:**
1. Use the app, create a demo agent
2. Take screenshots of:
   - Creating an agent
   - Running an agent
   - Dashboard/metrics
3. Create 2-3 minute video demo:
   - Screen recording of using the app
   - Voiceover explaining what you're doing
4. Add to README.md

**Tools:**
- Screenshots: Built-in OS tools
- Video: Loom, OBS, or QuickTime

**Time:** 2-3 hours

**TODO:** [ ] Create screenshots  
**TODO:** [ ] Create demo video  
**TODO:** [ ] Add to README

---

### 2.4 Conduct Security Audit

**Why:** Critical for enterprise/education customers.

**Steps:**
1. Hire security auditor (or use automated tools)
2. Fix identified issues
3. Document results in `yc/SECURITY_AUDIT.md`

**Automated Tools:**
- `bandit` (already in dev dependencies): `bandit -r agent_factory/`
- `safety` (check dependencies): `safety check`

**Time:** 1-2 weeks (if hiring auditor)

**TODO:** [ ] Run automated security scan  
**TODO:** [ ] Fix critical issues  
**TODO:** [ ] Consider professional audit

---

## Section 3: NICE TO HAVE LATER

### 3.1 Build Referral System

**Why:** Drives organic growth.

**Status:** Infrastructure exists, needs UI implementation

**See:** `yc/REFERRAL_FLOW.md` for plan

**Time:** 1-2 weeks

---

### 3.2 Create Financial Model

**Why:** Shows you understand unit economics.

**Steps:**
1. Create spreadsheet:
   - Revenue projections (next 12-24 months)
   - Cost projections (infrastructure, team, marketing)
   - Unit economics (CAC, LTV, payback period)
2. Document assumptions
3. Save in `yc/FINANCIAL_MODEL.md` (or `.xlsx`)

**Time:** 4-8 hours

---

### 3.3 Content Marketing

**Why:** Drives organic signups.

**Steps:**
1. Write 4 blog posts:
   - "How to build AI agents"
   - "From notebook to production"
   - Case study
   - Technical deep dive
2. Publish on blog/Medium/Dev.to
3. Share on Hacker News, Reddit, Twitter

**See:** `docs/marketing/CONTENT_CALENDAR.md` for plan

**Time:** Ongoing

---

## Section 4: Quick Reference

### Key Commands

```bash
# Development
make install          # Install dependencies
make test             # Run tests
make migrate          # Run database migrations
make seed             # Seed demo data

# Server
uvicorn agent_factory.api.main:app --reload  # Start dev server

# CLI
agent-factory agent create <id> --name "<name>" --instructions "<instructions>"
agent-factory agent run <id> --input "<input>"
```

### Key Files

- **Setup:** `docs/SETUP_LOCAL.md`
- **Deployment:** `docs/deploy-strategy.md`
- **Environment:** `.env.example`, `docs/env-and-secrets.md`
- **YC Docs:** `yc/` directory
- **Investor Assets:** `dataroom/` directory (create if needed)

### Key URLs

- **Local API:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs
- **Health Check:** http://localhost:8000/health
- **Production:** [Set after deployment]

### Key Metrics to Track

- Users: Signups, activations, Day 1/7/30 retention
- Usage: Agent runs, API calls, workflows
- Revenue: MRR, ARR, growth rate
- Unit Economics: CAC, LTV, payback period

**See:** `yc/YC_METRICS_CHECKLIST.md` for complete list

---

## Common Tasks

### Reset Database

```bash
alembic downgrade base
alembic upgrade head
make seed
```

### Check Environment

```bash
make env-check
# OR
python scripts/env-doctor.py
```

### Run Smoke Tests

```bash
./scripts/smoke-tests.sh
```

### Update Dependencies

```bash
pip install --upgrade -e ".[dev]"
```

---

## Getting Help

- **Documentation:** `docs/` directory
- **YC Prep:** `yc/` directory
- **Issues:** GitHub Issues
- **Troubleshooting:** See `docs/SETUP_LOCAL.md` troubleshooting section

---

## Priority Checklist

**This Week:**
- [ ] Get app running locally
- [ ] Deploy to production
- [ ] Get 3-5 early users

**This Month:**
- [ ] Collect real metrics
- [ ] Document team/founders
- [ ] Create screenshots/demo video
- [ ] Conduct security audit

**This Quarter:**
- [ ] Build referral system
- [ ] Create financial model
- [ ] Start content marketing

---

**Last Updated:** 2024-01-XX  
**Maintained by:** Venture OS Supervisor
