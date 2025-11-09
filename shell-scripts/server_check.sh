#!/bin/bash

# --- Function to print section headers ---
print_header() {
    echo ""
    echo "============================="
    echo "  $1"
    echo "============================="
}

# --- Main health check ---
echo "🚀 DevOps Server Health Check"
echo "Report generated on: $(date)"

# 1. Current Location
print_header "📍 Current Location"
pwd

# 2. Files in Current Directory
print_header "📂 Files in Current Directory"
ls -la

# 3. Running Processes (Top 10 by CPU)
print_header "⚡ Running Processes"
ps aux --sort=-%cpu | head -n 11

# 4. Disk Usage
print_header "💾 Disk Usage"
df -h

echo ""
echo "✅ Server check complete!"
