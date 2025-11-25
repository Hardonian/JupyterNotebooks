# Screenshots & Demo Plan - Agent Factory

**For:** Y Combinator Application & Interview  
**Last Updated:** 2024-01-XX

---

## Overview

This document outlines what screenshots and demos to create for YC application and interview. Visual proof is critical for YC partners to understand the product.

---

## Required Screenshots

### 1. Product Overview Screenshot

**What:** Main dashboard or landing page showing the platform

**Where to Capture:**
- Main dashboard (if exists)
- Agent list view
- Blueprint marketplace
- Or: Create a mockup if UI doesn't exist yet

**Use Cases:**
- README.md
- YC application
- Website

**Priority:** HIGH

---

### 2. Agent Creation Flow

**What:** Screenshot showing how to create an agent

**Steps to Capture:**
1. Agent creation form/page
2. Agent configuration (instructions, model, tools)
3. Agent created successfully

**Use Cases:**
- Product documentation
- YC application
- User guides

**Priority:** HIGH

---

### 3. Notebook Converter Demo

**What:** Before/after showing notebook → agent conversion

**Steps to Capture:**
1. Jupyter notebook with agent code
2. Running conversion command: `agent-factory notebook convert`
3. Generated agent files
4. Agent running successfully

**Use Cases:**
- Key differentiator demonstration
- YC application
- Marketing materials

**Priority:** HIGH

---

### 4. Agent Execution

**What:** Screenshot showing agent running and producing output

**Steps to Capture:**
1. Agent input (user query)
2. Agent processing (if visible)
3. Agent output (response)
4. Tool calls (if visible)

**Use Cases:**
- Product demo
- YC interview
- Case studies

**Priority:** HIGH

---

### 5. Blueprint Marketplace

**What:** Screenshot of blueprint marketplace/browser

**Steps to Capture:**
1. Marketplace homepage
2. Blueprint listing
3. Blueprint details page
4. Installation flow

**Use Cases:**
- Network effects demonstration
- YC application
- Marketing

**Priority:** MEDIUM

---

### 6. Metrics Dashboard

**What:** Screenshot of metrics/analytics dashboard

**Steps to Capture:**
1. Metrics overview
2. User metrics (DAU, WAU, MAU)
3. Revenue metrics (MRR, ARR)
3. Product metrics (agent runs, blueprints)

**Use Cases:**
- YC interview (show you know your numbers)
- Investor meetings
- Internal tracking

**Priority:** MEDIUM

---

### 7. Education-Specific Features

**What:** Screenshot showing FERPA compliance, LMS integration

**Steps to Capture:**
1. Compliance settings
2. LMS integration (Canvas, Blackboard)
3. Education-specific blueprints

**Use Cases:**
- Education market differentiation
- YC application
- Education sales

**Priority:** MEDIUM

---

## Video Demo Script

### 2-Minute Demo (For YC Application)

**Script:**

**[0:00-0:15] Introduction**
- "Agent Factory turns AI agent prototypes into production products in minutes"
- Show problem: Prototype in notebook → stuck

**[0:15-0:45] Notebook Conversion**
- Show Jupyter notebook with agent code
- Run: `agent-factory notebook convert support_bot.ipynb`
- Show generated agent files
- "5 minutes from notebook to deployable agent"

**[0:45-1:15] Agent Deployment**
- Show agent configuration
- Deploy agent: `agent-factory agent deploy support_bot`
- Show API endpoint
- "Production-ready in 10 minutes"

**[0:15-1:45] Agent Execution**
- Show agent running
- Input: Customer support query
- Output: Agent response
- "Works out of the box"

**[1:45-2:00] Key Features**
- Show billing integration
- Show multi-tenancy
- Show marketplace
- "Everything you need to ship SaaS products"

**Total:** ~2 minutes

---

### 5-Minute Demo (For YC Interview)

**Extended Script:**

**[0:00-0:30] Problem & Solution**
- Problem: Prototypes die because infrastructure is too hard
- Solution: Agent Factory provides complete platform
- Show before/after comparison

**[0:30-2:00] Core Workflow**
- Notebook conversion (same as 2-min demo)
- Agent deployment (same as 2-min demo)
- Agent execution (same as 2-min demo)

**[2:00-3:30] Key Features**
- Billing integration (Stripe)
- Multi-tenancy (show tenant isolation)
- Marketplace (browse, install blueprints)
- Compliance (FERPA, SOC2-ready)

**[3:30-4:30] Metrics & Traction**
- Show metrics dashboard
- Key numbers: [DAU, MRR, growth]
- Customer testimonials (if available)

**[4:30-5:00] Vision**
- Education focus (McGraw Hill partnership)
- Marketplace network effects
- Long-term vision

**Total:** ~5 minutes

---

## Demo Environment Setup

### Public Demo Environment

**Requirements:**
- [ ] Set up demo environment (staging/production)
- [ ] Create demo accounts
- [ ] Pre-populate with example agents/blueprints
- [ ] Ensure demo data is clean and professional
- [ ] Test demo flow end-to-end

**URL:** [To be created]
- Example: `demo.agentfactory.io` or `try.agentfactory.io`

**Access:**
- Public access (no login required for demo)
- Or: Demo login credentials

---

### Screenshot Assets

**File Structure:**
```
/docs/screenshots/
├── product-overview.png
├── agent-creation.png
├── notebook-converter-before.png
├── notebook-converter-after.png
├── agent-execution.png
├── blueprint-marketplace.png
├── metrics-dashboard.png
└── education-features.png
```

**Specifications:**
- Format: PNG (high quality)
- Size: 1920x1080 or larger
- Naming: Descriptive, kebab-case
- Optimization: Compress for web (but keep originals)

---

## Implementation Plan

### Phase 1: Screenshots (Week 1)

**Tasks:**
- [ ] Set up demo environment
- [ ] Create example agents/blueprints
- [ ] Capture all required screenshots
- [ ] Optimize screenshots for web
- [ ] Add to README.md
- [ ] Add to `/yc/` documents

**Deliverables:**
- 7+ high-quality screenshots
- Screenshots added to README
- Screenshots added to YC docs

---

### Phase 2: Video Demo (Week 2)

**Tasks:**
- [ ] Write demo script (see above)
- [ ] Record screen capture
- [ ] Edit video (add titles, transitions)
- [ ] Add voiceover or captions
- [ ] Upload to YouTube/Vimeo
- [ ] Add to README and website

**Deliverables:**
- 2-minute demo video
- 5-minute demo video (optional)
- Video embedded in README
- Video link in YC docs

---

### Phase 3: Interactive Demo (Week 3, Optional)

**Tasks:**
- [ ] Set up public demo environment
- [ ] Create demo flow
- [ ] Add "Try Demo" button to website
- [ ] website
- [ ] Track demo usage

**Deliverables:**
- Public demo environment
-  demo flow
-  - usage metrics

---

## TODO: Founders to Execute

**Required Actions:**
- [ ] Set up demo environment
- [ ] Track signup source
- [ ] Track conversion rates channel
- [ ] Compute CAC by channel
- [ ] Fill In `/yc/DISTRIBUTION_RESULTS.md`

**Optional:**
- [ ] Create channel dashboard
- [ ] Export metrics CSV/PDF
- [ ] Real-time updates

---

## Summary

**Implemented:**
- ✅ Channel Attribution tracking in telemetry
- Referral system code structure
- Export/import tools structure
- SEO landing page structure
- Screenshots/demo plan
- Team template
- Funding status template
- Financial model template
- Financial model template
- Unit economics framework

**Next Steps:**
- Fill in templates with real data
- Capture screenshots
- Record demo video
- Deploy referral system
- Create SEO landing pages
- Deploy to production and collect metrics

All templates and frameworks are ready for founders to fill in with real data. The code infrastructure is in place to track metrics, referrals, and channel attribution once deployed.
