#!/bin/bash
# Agent Factory Backup Automation Script
# Automated backup of database, files, and configurations

set -euo pipefail

# Configuration
BACKUP_DIR="${BACKUP_DIR:-/var/backups/agentfactory}"
DB_HOST="${DB_HOST:-localhost}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="${DB_NAME:-agentfactory}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
S3_BUCKET="${S3_BUCKET:-}"
LOG_FILE="${LOG_FILE:-/var/log/agentfactory/backup.log}"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Create backup directory
create_backup_dir() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="${BACKUP_DIR}/${timestamp}"
    mkdir -p "$backup_path"
    echo "$backup_path"
}

# Backup database
backup_database() {
    local backup_path="$1"
    local backup_file="${backup_path}/database.sql.gz"
    
    log "Starting database backup..."
    
    if command -v pg_dump &> /dev/null; then
        export PGPASSWORD="${DB_PASSWORD:-}"
        pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" | gzip > "$backup_file"
        unset PGPASSWORD
        
        if [ -f "$backup_file" ]; then
            local size=$(du -h "$backup_file" | cut -f1)
            log "SUCCESS: Database backup completed (size: $size)"
            echo "$backup_file"
        else
            log "ERROR: Database backup failed"
            return 1
        fi
    else
        log "ERROR: pg_dump not available"
        return 1
    fi
}

# Backup files
backup_files() {
    local backup_path="$1"
    local files_dir="${FILES_DIR:-/var/lib/agentfactory/files}"
    local backup_file="${backup_path}/files.tar.gz"
    
    log "Starting files backup..."
    
    if [ -d "$files_dir" ]; then
        tar -czf "$backup_file" -C "$(dirname "$files_dir")" "$(basename "$files_dir")"
        
        if [ -f "$backup_file" ]; then
            local size=$(du -h "$backup_file" | cut -f1)
            log "SUCCESS: Files backup completed (size: $size)"
            echo "$backup_file"
        else
            log "ERROR: Files backup failed"
            return 1
        fi
    else
        log "WARNING: Files directory not found: $files_dir"
        return 0
    fi
}

# Backup configurations
backup_configs() {
    local backup_path="$1"
    local config_dir="${CONFIG_DIR:-/etc/agentfactory}"
    local backup_file="${backup_path}/configs.tar.gz"
    
    log "Starting configuration backup..."
    
    if [ -d "$config_dir" ]; then
        tar -czf "$backup_file" -C "$(dirname "$config_dir")" "$(basename "$config_dir")"
        
        if [ -f "$backup_file" ]; then
            local size=$(du -h "$backup_file" | cut -f1)
            log "SUCCESS: Configuration backup completed (size: $size)"
            echo "$backup_file"
        else
            log "ERROR: Configuration backup failed"
            return 1
        fi
    else
        log "WARNING: Configuration directory not found: $config_dir"
        return 0
    fi
}

# Upload to S3
upload_to_s3() {
    local backup_path="$1"
    
    if [ -z "$S3_BUCKET" ]; then
        log "INFO: S3_BUCKET not set, skipping S3 upload"
        return 0
    fi
    
    log "Uploading backups to S3..."
    
    if command -v aws &> /dev/null; then
        aws s3 sync "$backup_path" "s3://${S3_BUCKET}/backups/$(basename "$backup_path")/" || {
            log "ERROR: S3 upload failed"
            return 1
        }
        log "SUCCESS: Backups uploaded to S3"
    else
        log "ERROR: AWS CLI not available"
        return 1
    fi
}

# Cleanup old backups
cleanup_old_backups() {
    log "Cleaning up backups older than $RETENTION_DAYS days..."
    
    find "$BACKUP_DIR" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} + 2>/dev/null || true
    
    log "SUCCESS: Old backups cleaned up"
}

# Verify backup
verify_backup() {
    local backup_file="$1"
    
    if [ -f "$backup_file" ] && [ -s "$backup_file" ]; then
        log "SUCCESS: Backup verification passed"
        return 0
    else
        log "ERROR: Backup verification failed"
        return 1
    fi
}

# Main backup function
main() {
    log "Starting backup process..."
    
    # Create backup directory
    local backup_path=$(create_backup_dir)
    log "Backup directory: $backup_path"
    
    local failed_backups=0
    
    # Backup database
    if ! backup_database "$backup_path"; then
        ((failed_backups++))
    fi
    
    # Backup files
    if ! backup_files "$backup_path"; then
        ((failed_backups++))
    fi
    
    # Backup configurations
    if ! backup_configs "$backup_path"; then
        ((failed_backups++))
    fi
    
    # Upload to S3
    if [ -n "$S3_BUCKET" ]; then
        upload_to_s3 "$backup_path" || ((failed_backups++))
    fi
    
    # Cleanup old backups
    cleanup_old_backups
    
    # Summary
    if [ $failed_backups -eq 0 ]; then
        log "SUCCESS: Backup process completed successfully"
        exit 0
    else
        log "WARNING: Backup process completed with $failed_backups error(s)"
        exit 1
    fi
}

# Run main function
main "$@"
