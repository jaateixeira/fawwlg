#!/bin/bash

# Script to mark all PDF files in a Git repository as 'assume unchanged'
# Verbose version that shows commands before executing them

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in a Git repository
echo -e "${YELLOW}Checking if we're in a Git repository...${NC}"
echo "> git rev-parse --is-inside-work-tree"
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo -e "${RED}Error: Not inside a Git repository. Please run this script from within your repo.${NC}"
  exit 1
fi
echo -e "${GREEN}✓ In a Git repository${NC}\n"

# Find all PDF files recursively
echo -e "${YELLOW}Searching for PDF files in the repository...${NC}"
echo "> find . -type f -name '*.pdf'"
pdf_files=$(find . -type f -name '*.pdf')

if [ -z "$pdf_files" ]; then
  echo -e "${GREEN}No PDF files found in the repository.${NC}"
  exit 0
fi

count=$(echo "$pdf_files" | wc -l)
echo -e "${GREEN}Found $count PDF files.${NC}\n"

# Display summary
echo -e "${YELLOW}The following PDF files will be marked as assume-unchanged:${NC}"
echo "$pdf_files"
echo ""

# Ask for confirmation
read -p "Do you want to proceed? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${RED}Operation canceled.${NC}"
  exit 0
fi

# Process each PDF file
echo -e "\n${YELLOW}Processing files...${NC}"
counter=0
while IFS= read -r file; do
  # Remove leading ./ if present
  file="${file#./}"
  
  echo -e "\n${YELLOW}Marking as assume-unchanged:${NC} $file"
  echo "> git update-index --assume-unchanged \"$file\""
  git update-index --assume-unchanged "$file"
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Success${NC}"
    ((counter++))
  else
    echo -e "${RED}✗ Failed${NC}"
  fi
  
  # Display progress every 10 files
  if (( counter % 10 == 0 )); then
    echo -e "${YELLOW}Processed $counter files...${NC}"
  fi
done <<< "$pdf_files"

# Final summary
echo -e "\n${YELLOW}Final Summary:${NC}"
echo -e "${GREEN}Successfully marked $counter PDF files as assume-unchanged.${NC}"
if [ $counter -ne $count ]; then
  echo -e "${RED}Warning: $((count - counter)) files could not be processed.${NC}"
fi

echo -e "\n${YELLOW}Notes:${NC}"
echo "1. These files are still in the repository but Git will ignore changes to them."
echo "2. To undo this for a specific file:"
echo "   git update-index --no-assume-unchanged <file>"
echo "3. To list all assume-unchanged files:"
echo "   git ls-files -v | grep '^h'"
echo "4. This setting is local to your repository clone."

#git ls-files -v | grep '^h'
