# Frugal Academic Writing With LaTex and Git - Towards a more efficient use of compute resources in collaborative academic writing 

A set of bash scripts that help towards a more efficient use of compute resources in collaborative academic writing. 
Convenient as the price of hosted and vendor managed Git repositories is going up. 


# Git Repository Optimization Scripts 🛠️

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

A collection of Bash scripts to optimize and manage Git repositories—**reduce bloat**, **improve performance**, and **clean history** with PDF files.

---

## 📜 Scripts Overview

### 1. **`assume-unchanged.sh`**  
🔹 **Purpose**: Marks files as "assume unchanged" in Git to ignore local changes (without removing from tracking).  
🔹 **Use Case**:  
   - Mark published pdf files as assume-unchanged. Git should know about it sit ut threats them differently 
   - No need to remember the "git update-index --assume-unchanged <file>" command 
   - Temporary ignore configuration/log files  
   - Improve performance in large repos  
🔹 **Usage**:  
   ```bash
   ./assume-unchanged.sh file1.txt dir/file2.pdf
   ```


### 2. **`mark_all_pdfs_in_rep_unchanged.sh`**
🔹 **Purpose**: Recursively marks all PDFs in a repo as "assume unchanged". 
🔹 **Use Case**:  
   - Key sources in pdf format (e.g., set of articles) added to repository will not change, so let Git know about it. 
   - Improve performance in large repos  
🔹 **Usage**:  
   ```bash
   ./mark_all_pdfs_in_rep_unchanged.sh
   ```
 
### 3. **`remove_pdfs_git_rep_history.sh`**  
🔹 **Purpose**: permanently removes PDF files from your Git repository history using BFG Repo-Cleaner, significantly reducing repository size.
🔹 **Use Case**:  
   - You been adding articles to read and cite to your project. Then, problem, you run out of space. Solution, you remove all pdf files from the history using remove_pdfs_git_rep_history.sh
   - Improve performance in large repos  
🔹 **Usage**:  
   ```bash
   ./remove_pdfs_git_rep_history.sh
   ```


## 1 Git Assume-Unchanged Script  -> assume-unchanged.sh

![Bash](https://img.shields.io/badge/Bash-Script-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![Git](https://img.shields.io/badge/Git-Integration-F05032?style=flat&logo=git&logoColor=white)

A Bash script to mark files as "assume unchanged" in Git, preventing local changes from being tracked without removing files from version control.

### 📝 Description

This script allows you to:
- Mark one or multiple files as `--assume-unchanged` in Git
- Verify current Git status of files
- Check which files are currently marked as assume-unchanged
- Provides color-coded output for better visibility
- The same as "git update-index --assume-unchanged <file>" command 

### 🛠️ Features

- ✅ Color-coded terminal output (errors in red, success in green)
- ✅ Checks if files exist and are tracked by Git
- ✅ Shows current Git status before modification
- ✅ Verification step after marking files
- ✅ Handles multiple files at once

### 🚀 Usage

```bash
./assume-unchanged.sh <file1> [file2 ...]
```

## 2 Git PDF Assume-Unchanged Script -> mark_all_pdfs_in_rep_unchanged.sh

![Bash](https://img.shields.io/badge/Bash-Script-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![Git](https://img.shields.io/badge/Git-Integration-F05032?style=flat&logo=git&logoColor=white)
![PDF](https://img.shields.io/badge/PDF-Handling-FF0000?style=flat&logo=adobe-acrobat-reader&logoColor=white)

A recursive Bash script to mark all PDF files in a Git repository as "assume unchanged" with verbose output and safety checks.

### 📝 Description

This script automatically:
- Finds all PDF files in your repository (including subdirectories)
- Displays a summary of files to be modified
- Requires user confirmation before proceeding
- Marks all found PDFs as `--assume-unchanged`
- Provides detailed progress reporting
- Shows final statistics and helpful undo instructions

### ✨ Features

- 🔍 **Recursive PDF detection** - Finds all `.pdf` files in repository
- ✅ **Interactive confirmation** - Prevents accidental execution
- 📊 **Progress tracking** - Shows count of processed files
- 🎨 **Color-coded output** - Easy-to-read terminal feedback
- 📝 **Post-execution notes** - Helpful Git commands for management
- 🔒 **Safety checks** - Verifies Git repository first

### 🚀 Usage

```bash
./mark_all_pdfs_in_rep_unchanged.sh
```

## 3 Git PDF History Cleaner -> remove_pdfs_git_rep_history.sh

![Bash](https://img.shields.io/badge/Bash-Script-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![Git](https://img.shields.io/badge/Git-Integration-F05032?style=flat&logo=git&logoColor=white)
![PDF](https://img.shields.io/badge/PDF-Handling-FF0000?style=flat&logo=adobe-acrobat-reader&logoColor=white)

A powerful bash script that permanently removes PDF files from your Git repository history using BFG Repo-Cleaner, significantly reducing repository size.

### Features

- 🔍 **Automatically detects PDFs** in repository history (case-insensitive)
- ⚡ **Optimized cleaning** using the industry-standard BFG tool
- 💾 **Automatic download** of BFG (if not present) from Maven repository
- 🔒 **Safety first** with automatic backup branch creation
- 📉 **Repository size metrics** before/after cleanup
- 🗑️ **Optional cleanup** of downloaded BFG jar
- 🎨 **Color-coded output** for better readability
- ✔️ **Verification step** to confirm PDF removal

### Use Cases

- Reduce repository bloat from committed PDF files
- Remove sensitive PDF documents from history
- Prepare repositories for open-source publication
- Optimize CI/CD pipeline performance by reducing clone times

### Requirements

- Git
- Java Runtime Environment (JRE)
- Bash shell
- `wget` or `curl` (for automatic download)

### How It Works

The script:
1. Checks for and downloads BFG if needed
2. Creates a backup branch of your current state
3. Scans and removes all PDF files from Git history
4. Performs aggressive garbage collection
5. Provides verification of removal
6. Offers to clean up the BFG jar file

### Safety Features

✅ Pre-operation repository size measurement  
✅ Mandatory user confirmation before proceeding  
✅ Automatic backup branch creation  
✅ Verification of PDF removal  
✅ Clean working directory check  

> **Warning**  
> This script rewrites Git history. After running, all collaborators will need to reclone the repository.
