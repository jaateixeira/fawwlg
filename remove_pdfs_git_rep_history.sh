#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# BFG Repository URL
BFG_URL="https://repo1.maven.org/maven2/com/madgag/bfg/1.15.0/bfg-1.15.0.jar"
BFG_JAR="bfg-1.15.0.jar"

# Function to print command being executed
print_command() {
    echo -e "${YELLOW}Executing:${NC} ${BLUE}$1${NC}"
}

# Function to download file with progress
download_file() {
    local url=$1
    local output=$2
    echo -e "${GREEN}Downloading ${url}...${NC}"
    
    if command -v wget &> /dev/null; then
        wget --show-progress -q -O "$output" "$url"
    elif command -v curl &> /dev/null; then
        curl -# -L -o "$output" "$url"
    else
        echo -e "${RED}Error:${NC} Neither wget nor curl found. Please install one of them."
        exit 1
    fi
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error:${NC} Failed to download $url"
        exit 1
    fi
}

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}Error:${NC} Not in a Git repository"
    exit 1
fi

# Check if BFG jar exists, download if not
if [ ! -f "$BFG_JAR" ]; then
    echo -e "${YELLOW}BFG jar not found in current directory.${NC}"
    download_file "$BFG_URL" "$BFG_JAR"
    echo -e "${GREEN}Downloaded BFG to:${NC} $(pwd)/$BFG_JAR"
else
    echo -e "${GREEN}Using existing BFG jar:${NC} $(pwd)/$BFG_JAR"
fi

# Verify Java is available
if ! command -v java &> /dev/null; then
    echo -e "${RED}Error:${NC} Java is not installed or not in PATH"
    exit 1
fi

# Safety check - ensure working directory is clean
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Error:${NC} Working directory has uncommitted changes"
    echo "Please commit or stash your changes before running this script"
    exit 1
fi

# Show repository size before cleanup
echo -e "\n${GREEN}Repository size before cleanup:${NC}"
print_command "du -sh .git"
du -sh .git

# Count PDF files in history
echo -e "\n${GREEN}Counting PDF files in repository history...${NC}"
print_command "git log --all --name-only --format='format:' | grep -i '\.pdf$' | sort | uniq -c | sort -nr"
PDF_COUNT=$(git log --all --name-only --format='format:' | grep -i '\.pdf$' | sort | uniq | wc -l)
echo -e "Found ${YELLOW}$PDF_COUNT${NC} unique PDF files in repository history"

if [ "$PDF_COUNT" -eq 0 ]; then
    echo -e "${GREEN}No PDF files found in history - nothing to do!${NC}"
    exit 0
fi

# Confirm with user
echo -e "\n${RED}WARNING:${NC} This will permanently remove all PDF files from your repository history"
echo -e "This operation ${RED}cannot be undone${NC} and will rewrite your repository history"
read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Operation cancelled${NC}"
    exit 0
fi

# Create backup branch just in case
BACKUP_BRANCH="backup-before-pdf-removal-$(date +%Y%m%d-%H%M%S)"
print_command "git branch $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH"
echo -e "Created backup branch: ${YELLOW}$BACKUP_BRANCH${NC}"

# Run BFG to remove PDFs
echo -e "\n${GREEN}Running BFG to remove PDF files...${NC}"
print_command "java -jar $BFG_JAR --delete-files '*.pdf' --no-blob-protection ."
java -jar "$BFG_JAR" --delete-files '*.pdf' --no-blob-protection .

# Clean up and garbage collect
echo -e "\n${GREEN}Cleaning up and optimizing repository...${NC}"
print_command "git reflog expire --expire=now --all && git gc --prune=now --aggressive"
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Verify PDFs are gone
echo -e "\n${GREEN}Verifying PDF files were removed...${NC}"
print_command "git log --all --name-only --format='format:' | grep -i '\.pdf$' | sort | uniq"
REMAINING_PDFS=$(git log --all --name-only --format='format:' | grep -i '\.pdf$' | sort | uniq | wc -l)

if [ "$REMAINING_PDFS" -eq 0 ]; then
    echo -e "${GREEN}Success:${NC} All PDF files removed from history"
else
    echo -e "${YELLOW}Warning:${NC} Found $REMAINING_PDFS PDF files remaining in history"
fi

# Show repository size after cleanup
echo -e "\n${GREEN}Repository size after cleanup:${NC}"
print_command "du -sh .git"
du -sh .git

# Ask user if they want to remove the downloaded jar
echo -e "\n${GREEN}Operation complete!${NC}"
echo -e "Remember to ${RED}force push${NC} your changes to all remotes:"
echo -e "${BLUE}git push --force --all${NC}"
echo -e "Your original state is saved in branch: ${YELLOW}$BACKUP_BRANCH${NC}"

read -p "Do you want to remove the downloaded BFG jar file? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_command "rm $BFG_JAR"
    rm "$BFG_JAR"
    echo -e "${GREEN}Removed BFG jar file.${NC}"
else
    echo -e "${GREEN}Keeping BFG jar file.${NC}"
fi
