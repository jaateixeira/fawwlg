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


## Git PDF History Cleaner -> remove_pdfs_git_rep_history.sh

![Shell Script](https://img.shields.io/badge/Shell_Script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Git](https://img.shields.io/badge/Git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

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
