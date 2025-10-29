#!/bin/sh
# generate-nginx.sh
# Render nginx.template.conf -> /etc/nginx/nginx.conf with proper 'backup' keyword
# Expects ACTIVE_POOL in environment (blue or green)
set -eu

# default to blue if not set
ACTIVE_POOL="${ACTIVE_POOL:-blue}"

# Decide which upstream gets "backup"
if [ "$ACTIVE_POOL" = "blue" ]; then
  export BACKUP_BLUE=""
  export BACKUP_GREEN=" backup"
else
  export BACKUP_BLUE=" backup"
  export BACKUP_GREEN=""
fi

# Use envsubst (from gettext) to replace placeholders
# Read template and produce final nginx.conf
envsubst '${BACKUP_BLUE} ${BACKUP_GREEN} ${ACTIVE_POOL}' < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf || {
  echo "[ERROR] envsubst failed"
  exit 1
}

echo "[INFO] Generated /etc/nginx/nginx.conf with ACTIVE_POOL=$ACTIVE_POOL"
# If nginx is running, reload. Caller may start nginx afterwards.
if pidof nginx >/dev/null 2>&1; then
  nginx -s reload || echo "[WARN] nginx reload failed"
fi
