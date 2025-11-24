# Backup & Recovery Runbook

**Last Updated:** 2024-01-XX  
**Purpose:** Procedures for backing up and recovering Agent Factory platform data

---

## Overview

This runbook documents backup and recovery procedures for the Agent Factory platform.

**Backup Scope:**
- Database (PostgreSQL via Supabase)
- Application code (Git)
- Configuration (GitHub Secrets, Vercel env vars)
- Storage (Supabase Storage)

---

## Backup Strategy

### Database Backups

**Automatic Backups (Supabase):**
- **Frequency:** Daily
- **Retention:** 7 days (Free tier), 30 days (Pro tier)
- **Location:** Supabase managed backups
- **Type:** Full database dumps

**Manual Backups:**
- **Frequency:** Before major changes (migrations, deployments)
- **Retention:** 30 days
- **Location:** S3 or local storage
- **Type:** Full database dumps

### Code Backups

**Git Repository:**
- **Frequency:** Continuous (every commit)
- **Retention:** Permanent
- **Location:** GitHub
- **Type:** Version control

**Backup Strategy:**
- Main branch protected
- All changes via PRs
- Tagged releases
- GitHub backup (automatic)

### Configuration Backups

**GitHub Secrets:**
- **Frequency:** Manual (before changes)
- **Retention:** 90 days
- **Location:** Secure password manager
- **Type:** Encrypted export

**Vercel Environment Variables:**
- **Frequency:** Manual (before changes)
- **Retention:** 90 days
- **Location:** Secure password manager
- **Type:** Encrypted export

---

## Backup Procedures

### Database Backup

**Automatic (Supabase):**
- Handled by Supabase
- No action required
- Access via Supabase dashboard

**Manual Backup:**
```bash
# Set database URL
export DATABASE_URL="postgresql://..."

# Create backup
pg_dump $DATABASE_URL > backup-$(date +%Y%m%d-%H%M%S).sql

# Compress backup
gzip backup-$(date +%Y%m%d-%H%M%S).sql

# Upload to S3 (if configured)
aws s3 cp backup-*.sql.gz s3://backups/agent-factory/
```

**Via Supabase Dashboard:**
1. Go to Supabase Dashboard → Database → Backups
2. Click "Create Backup"
3. Download backup file
4. Store securely

### Code Backup

**Git Backup:**
```bash
# Create backup branch
git checkout -b backup/$(date +%Y%m%d)
git push origin backup/$(date +%Y%m%d)

# Create release tag
git tag -a v$(date +%Y%m%d) -m "Backup tag"
git push origin v$(date +%Y%m%d)
```

**GitHub Archive:**
- GitHub automatically archives repositories
- Access via GitHub Settings → Archive

### Configuration Backup

**Export GitHub Secrets:**
```bash
# List secrets (requires GitHub CLI)
gh secret list

# Export to secure file
gh secret list > secrets-backup-$(date +%Y%m%d).txt
# Encrypt file
gpg -c secrets-backup-$(date +%Y%m%d).txt
```

**Export Vercel Environment Variables:**
```bash
# Via Vercel CLI
vercel env pull .env.backup

# Encrypt backup
gpg -c .env.backup
```

---

## Recovery Procedures

### Database Recovery

**From Supabase Backup:**
1. Go to Supabase Dashboard → Database → Backups
2. Select backup to restore
3. Click "Restore"
4. Confirm restore
5. Verify data

**From Manual Backup:**
```bash
# Set database URL
export DATABASE_URL="postgresql://..."

# Restore from backup
gunzip backup-YYYYMMDD-HHMMSS.sql.gz
psql $DATABASE_URL < backup-YYYYMMDD-HHMMSS.sql

# Verify restore
python3 scripts/db-validate-schema.py
```

**Point-in-Time Recovery (Pro tier):**
1. Go to Supabase Dashboard → Database → Backups
2. Select point-in-time recovery
3. Choose recovery point
4. Restore to new database
5. Verify and migrate data

### Code Recovery

**From Git:**
```bash
# Restore from tag
git checkout vYYYYMMDD

# Restore from branch
git checkout backup/YYYYMMDD

# Restore specific commit
git checkout <commit-hash>
```

**From GitHub:**
- Access via GitHub repository
- Browse commit history
- Restore specific version

### Configuration Recovery

**Restore GitHub Secrets:**
1. Go to GitHub Settings → Secrets
2. Add secrets manually from backup
3. Verify secrets are correct

**Restore Vercel Environment Variables:**
```bash
# Decrypt backup
gpg -d .env.backup.gpg > .env.backup

# Push to Vercel
vercel env push .env.backup production
```

---

## Disaster Recovery

### Complete System Recovery

**Scenario:** Complete system failure

**Steps:**
1. **Assess Damage:**
   - Identify what's lost
   - Determine recovery point objective (RPO)
   - Determine recovery time objective (RTO)

2. **Restore Infrastructure:**
   - Restore database from backup
   - Restore code from Git
   - Restore configuration

3. **Verify System:**
   - Run schema validation
   - Run smoke tests
   - Verify key features

4. **Communicate:**
   - Notify team
   - Update status page
   - Communicate to users

### Partial Recovery

**Scenario:** Partial data loss

**Steps:**
1. **Identify Affected Data:**
   - Review logs
   - Identify data loss scope
   - Determine recovery method

2. **Restore Data:**
   - Restore from backup
   - Verify data integrity
   - Update affected records

3. **Verify:**
   - Check data consistency
   - Verify functionality
   - Monitor for issues

---

## Backup Verification

### Regular Verification

**Frequency:** Monthly

**Checks:**
- [ ] Backup files exist
- [ ] Backup files are accessible
- [ ] Backup files are not corrupted
- [ ] Backup retention policy followed
- [ ] Recovery procedures tested

### Test Recovery

**Frequency:** Quarterly

**Procedure:**
1. Create test environment
2. Restore from backup
3. Verify data integrity
4. Test key features
5. Document results

---

## Backup Retention

### Retention Policy

**Database Backups:**
- Daily backups: 7 days
- Weekly backups: 4 weeks
- Monthly backups: 12 months

**Code Backups:**
- Permanent (Git)
- Release tags: Permanent

**Configuration Backups:**
- 90 days
- Encrypted storage

### Cleanup

**Automated:**
- Supabase handles automatic cleanup
- GitHub handles repository archival

**Manual:**
```bash
# Cleanup old backups (keep last 30 days)
find backups/ -name "backup-*.sql.gz" -mtime +30 -delete
```

---

## Best Practices

### Backup

1. **Automate Where Possible:**
   - Use Supabase automatic backups
   - Use Git for code
   - Schedule manual backups

2. **Test Backups Regularly:**
   - Verify backup integrity
   - Test recovery procedures
   - Document results

3. **Store Securely:**
   - Encrypt sensitive backups
   - Use secure storage
   - Limit access

### Recovery

1. **Have a Plan:**
   - Document recovery procedures
   - Test recovery regularly
   - Train team members

2. **Verify After Recovery:**
   - Check data integrity
   - Verify functionality
   - Monitor for issues

3. **Document Everything:**
   - Document recovery process
   - Note any issues
   - Update procedures

---

## Tools & Resources

### Backup Tools
- `pg_dump` - PostgreSQL backup
- `psql` - PostgreSQL restore
- `git` - Code version control
- `gpg` - Encryption

### Storage
- Supabase backups (automatic)
- S3 (for manual backups)
- Secure password manager (for secrets)

### Documentation
- [Deployment Runbook](DEPLOYMENT.md)
- [Incident Response](INCIDENT_RESPONSE.md)

---

## Review & Updates

**Review Frequency:** Quarterly  
**Last Reviewed:** [Date]  
**Next Review:** [Date]

**Update Triggers:**
- When backup strategy changes
- After recovery incidents
- When new data sources added
- Quarterly review cycle

---

## Appendix: Quick Reference

### Backup Commands
```bash
# Database backup
pg_dump $DATABASE_URL > backup-$(date +%Y%m%d).sql

# Compress backup
gzip backup-*.sql

# Code backup
git tag -a v$(date +%Y%m%d) -m "Backup"
git push origin v$(date +%Y%m%d)
```

### Recovery Commands
```bash
# Database restore
psql $DATABASE_URL < backup-YYYYMMDD.sql

# Code restore
git checkout vYYYYMMDD
```

### Verification Commands
```bash
# Schema validation
python3 scripts/db-validate-schema.py

# Smoke tests
./scripts/smoke-tests.sh production https://api.agentfactory.io
```

---

**Remember:** Regular backups, test recovery, and document everything.
