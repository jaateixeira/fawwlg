#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print command being executed
print_command() {
    echo -e "${YELLOW}Executing:${NC} ${BLUE}$1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}Error:${NC} Not in a Git repository"
    exit 1
fi

# Check if any files were provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error:${NC} No files specified"
    echo "Usage: $0 <file1> [file2 ...]"
    exit 1
fi

# Process each file
for file in "$@"; do
    echo -e "\n${GREEN}Processing file:${NC} $file"
    
    # Check if file exists
    if [ ! -e "$file" ]; then
        echo -e "${RED}Error:${NC} File '$file' does not exist"
        continue
    fi
    
    # Check if file is tracked by git
    if ! git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
        echo -e "${RED}Error:${NC} File '$file' is not tracked by Git"
        continue
    fi
    
    # Get current git status of the file
    status=$(git status --porcelain "$file")
    echo -e "Current status: ${YELLOW}${status}${NC}"
    
    # Update the index
    print_command "git update-index --assume-unchanged \"$file\""
    git update-index --assume-unchanged "$file"
    
    # Verify the operation
    if git ls-files -v | grep "^[a-z] $file" >/dev/null; then
        echo -e "${GREEN}Success:${NC} File '$file' is now marked as assume-unchanged"
    else
        echo -e "${RED}Warning:${NC} Could not verify if file '$file' was successfully marked as assume-unchanged"
    fi
done

echo -e "\n${GREEN}Operation complete.${NC}"
echo "The following files are now marked as assume-unchanged:"
print_command "git ls-files -v | grep '^[a-z]'"
git ls-files -v | grep '^[a-z]'
