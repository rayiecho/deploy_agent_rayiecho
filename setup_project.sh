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

touch "$PROJECT_DIR/attendance_checker.py"
touch "$PROJECT_DIR/Helpers/assets.csv"
touch "$PROJECT_DIR/Helpers/config.json"
touch "$PROJECT_DIR/reports/reports.log"

cat > "$PROJECT_DIR/Helpers/config.json" << EOF
{
  "warning_threshold": 75,
  "failure_threshold": 50
}
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
    sed -i "s/\"warning_threshold\": 75/\"warning_threshold\": $WARNING/" "$PROJECT_DIR/Helpers/config.json"
    sed -i "s/\"failure_threshold\": 50/\"failure_threshold\": $FAILURE/" "$PROJECT_DIR/Helpers/config.json"
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
