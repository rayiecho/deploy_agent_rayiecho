#!/bin/bash

cleanup() {
    echo ""
    echo "Script interrupted! Archiving incomplete project..."
    tar -czf "${PROJECT_DIR}_archive.tar.gz" "$PROJECT_DIR" 2>/dev/null
    rm -rf "$PROJECT_DIR"
    echo "Archived to: ${PROJECT_DIR}_archive.tar.gz"
    echo "Incomplete directory deleted."
    exit 1
}

trap cleanup SIGINT

echo "Welcome to the Attendance Tracker Setup"
echo "========================================"
echo "Enter project name:"
read INPUT

PROJECT_DIR="attendance_tracker_${INPUT}"
echo "Creating project: $PROJECT_DIR"

mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

cat > "$PROJECT_DIR/attendance_checker.py" << 'EOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])
            attendance_pct = (attended / total_sessions) * 100
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
EOF

cat > "$PROJECT_DIR/Helpers/assets.csv" << 'EOF'
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF

cat > "$PROJECT_DIR/Helpers/config.json" << EOF
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF

cat > "$PROJECT_DIR/reports/reports.log" << 'EOF'
--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie Davis, your attendance is 26.7%. You will fail this class.
EOF

echo "Default config written to config.json"
echo "Directory structure created successfully"
echo "========================================"
echo "Do you want to update attendance thresholds? (yes/no)"
read UPDATE

if [ "$UPDATE" = "yes" ]; then
    echo "Enter Warning threshold (default 75):"
    read WARNING
    echo "Enter Failure threshold (default 50):"
    read FAILURE
    sed -i "s/\"warning\": 75/\"warning\": $WARNING/" "$PROJECT_DIR/Helpers/config.json"
    sed -i "s/\"failure\": 50/\"failure\": $FAILURE/" "$PROJECT_DIR/Helpers/config.json"
    echo "Thresholds updated successfully"
    cat "$PROJECT_DIR/Helpers/config.json"
else
    echo "Keeping default thresholds"
fi

echo "========================================"
echo "Running environment health check..."

if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "Python3 is installed: $PYTHON_VERSION"
else
    echo "WARNING: Python3 is not installed. Please install it before running the tracker."
fi

echo "========================================"
echo "Setup complete! Your project is ready at: $PROJECT_DIR"
