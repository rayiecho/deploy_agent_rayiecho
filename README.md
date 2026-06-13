# deploy_agent_rayiecho

## What it does
This script automates the creation of the workspace, configures 
settings via the command line, and handles system signals gracefully.

## How to run it
bash setup_project.sh

## How to trigger the archive feature
While the script is running, press Ctrl+C to interrupt it.
The script will automatically archive the incomplete project folder
and delete it to keep the workspace clean.

## How it works

### 1. Directory Architecture
Creates attendance_tracker_{input} folder with the required 
structure including Helpers/ and reports/ subdirectories.

### 2. Dynamic Configuration
Prompts user to update warning and failure thresholds.
Uses sed to edit config.json in place with new values.

### 3. Process Management (Signal Trap)
Implements a SIGINT trap. When Ctrl+C is pressed mid-execution,
the script bundles the incomplete project into a .tar.gz archive
and deletes the original folder.

### 4. Environment Validation
Checks if python3 is installed using python3 --version.
Prints success message with version or warning if missing.
