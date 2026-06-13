# deploy_agent_rayiecho

## What it does
This script automates the creation of the workspace, configures 
settings via the command line, and handles system signals gracefully.

## How to run it

1. Clone the repository:
   git clone https://github.com/rayiecho/deploy_agent_rayiecho.git

2. Enter the directory:
   cd deploy_agent_rayiecho

3. Make the script executable:
   chmod +x setup_project.sh

4. Run the script:
   bash setup_project.sh

5. Enter your project name when prompted (e.g. v1)

6. Choose yes or no to update thresholds

7. If yes, enter Warning threshold (default 75) and Failure threshold (default 50)

8. Script will validate Python3 installation and complete setup

9. To trigger the archive feature, press Ctrl+C at any prompt during execution

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
