# Git PDF History Cleaner

![Shell Script](https://img.shields.io/badge/Shell_Script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Git](https://img.shields.io/badge/Git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

A powerful bash script that permanently removes PDF files from your Git repository history using BFG Repo-Cleaner, significantly reducing repository size.

## Features

- 🔍 **Automatically detects PDFs** in repository history (case-insensitive)
- ⚡ **Optimized cleaning** using the industry-standard BFG tool
- 💾 **Automatic download** of BFG (if not present) from Maven repository
- 🔒 **Safety first** with automatic backup branch creation
- 📉 **Repository size metrics** before/after cleanup
- 🗑️ **Optional cleanup** of downloaded BFG jar
- 🎨 **Color-coded output** for better readability
- ✔️ **Verification step** to confirm PDF removal

## Use Cases

- Reduce repository bloat from committed PDF files
- Remove sensitive PDF documents from history
- Prepare repositories for open-source publication
- Optimize CI/CD pipeline performance by reducing clone times

## Requirements

- Git
- Java Runtime Environment (JRE)
- Bash shell
- `wget` or `curl` (for automatic download)

## How It Works

The script:
1. Checks for and downloads BFG if needed
2. Creates a backup branch of your current state
3. Scans and removes all PDF files from Git history
4. Performs aggressive garbage collection
5. Provides verification of removal
6. Offers to clean up the BFG jar file

## Safety Features

✅ Pre-operation repository size measurement  
✅ Mandatory user confirmation before proceeding  
✅ Automatic backup branch creation  
✅ Verification of PDF removal  
✅ Clean working directory check  

> **Warning**  
> This script rewrites Git history. After running, all collaborators will need to reclone the repository.
