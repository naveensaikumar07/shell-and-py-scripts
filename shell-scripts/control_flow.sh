#!/bin/bash
# Control Flow Helper Script
# Purpose: Check list of services on a list of servers (local or remote),
# restart failed services, and create a summary report.
#
# Usage:
#   ./control_flow.sh check      # run checks only
#   ./control_flow.sh repair     # attempt restart when services are inactive
#   ./control_flow.sh report     # print summary report
#
# The script demonstrates: if/elif/else, for/while loops, case, functions, exit codes.

SERVERS=("localhost")
# Example services to check — replace or extend when running on real systems
SERVICES=("ssh" "cron" "docker")

LOGFILE="./service_check.log"
SUMMARYFILE="./service_summary.txt"

print_header() {
  echo "========================================"
  echo "  $1"
  echo "========================================"
}

check_service_local() {
  local svc="$1"
  # Use systemctl if available, otherwise fallback to pidof
  if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active --quiet "$svc"
    return $?
  else
    pidof "$svc" >/dev/null 2>&1
    return $?
  fi
}

attempt_restart_local() {
  local svc="$1"
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl restart "$svc" >/dev/null 2>&1
    return $?
  else
    return 1
  fi
}

check_and_maybe_repair() {
  local server="$1"
  local svc="$2"
  # For this lab we treat "localhost" specially — expansion to SSH is left as an exercise
  if [ "$server" = "localhost" ]; then
    if check_service_local "$svc"; then
      echo "$(date) | $server | $svc | OK" >> "$LOGFILE"
      echo "OK: $server $svc"
      echo "OK: $svc" >> "$SUMMARYFILE"
    else
      echo "$(date) | $server | $svc | FAILED" >> "$LOGFILE"
      echo "FAILED: $server $svc"
      if [ "$ACTION" = "repair" ]; then
        echo "Attempting restart of $svc on $server..."
        if attempt_restart_local "$svc"; then
          echo "$(date) | $server | $svc | RESTARTED" >> "$LOGFILE"
          echo "RESTARTED: $svc" >> "$SUMMARYFILE"
        else
          echo "$(date) | $server | $svc | RESTART_FAILED" >> "$LOGFILE"
          echo "RESTART_FAILED: $svc" >> "$SUMMARYFILE"
        fi
      else
        echo "No repair attempted (run with 'repair' action to restart services)."
      fi
    fi
  else
    # Placeholder for remote check — show how you'd branch logic
    echo "Skipping remote server $server in this lab (placeholder)."
    echo "$(date) | $server | $svc | SKIPPED" >> "$LOGFILE"
    echo "SKIPPED: $svc on $server" >> "$SUMMARYFILE"
  fi
}

run_checks() {
  : > "$LOGFILE"
  : > "$SUMMARYFILE"
  print_header "Service Check - Action: $ACTION"
  for srv in "${SERVERS[@]}"; do
    echo "Checking server: $srv"
    for svc in "${SERVICES[@]}"; do
      check_and_maybe_repair "$srv" "$svc"
    done
  done
  print_header "Done. Summary written to $SUMMARYFILE and log to $LOGFILE"
}

show_report() {
  print_header "Service Summary Report"
  if [ -s "$SUMMARYFILE" ]; then
    cat "$SUMMARYFILE"
  else
    echo "No summary found. Run with 'check' or 'repair' first."
  fi
}

usage() {
  cat <<'EOF'
Usage: ./control_flow.sh <action>
Actions:
  check   - Run service checks (no repairs)
  repair  - Attempt to restart failed services
  report  - Show summary report
EOF
}

# Main: use case statement to dispatch actions
ACTION="${1:-check}"
case "$ACTION" in
  check)
    run_checks
    ;;
  repair)
    run_checks
    ;;
  report)
    show_report
    ;;
  *)
    echo "Invalid action: $ACTION"
    usage
    # In lab environment, don't exit - just show error
    ;;
esac

# Script completed successfully
echo ""
