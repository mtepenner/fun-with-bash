# 🛠️ Fun With Bash: Utility Scripts Collection

## Description
This repository contains a collection of powerful, automated Bash scripts designed to streamline everyday developer tasks and enhance system management. From leveraging local LLMs to intelligently sort your downloads, to instantly bootstrapping and publishing new code repositories, to securing your Linux system with malware scans, these scripts provide robust automation right from your terminal.

## 📑 Table of Contents
- [Features](#-features)
- [Scripts Overview](#-scripts-overview)
  - [AI File Organizer (`organizer.sh`)](#1-ai-file-organizer-organizersh)
  - [Project Initializer (`init-project.sh`)](#2-project-initializer-init-projectsh)
  - [System Antivirus (`antivirus.sh`)](#3-system-antivirus-antivirussh)
- [Installation & Prerequisites](#-installation--prerequisites)
- [Usage](#-usage)
- [Technologies Used](#-technologies-used)
- [Contributing](#-contributing)

## 🚀 Features
* **AI-Powered Sorting:** Uses a local instance of Ollama to analyze file contents and metadata, automatically renaming and categorizing files into appropriately named directories.
* **Instant Project Bootstrapping:** Scaffolds directories, initializes Git, creates a private GitHub repository, and pushes initial boilerplate code for Python, JavaScript, or C++ in a single command.
* **Automated Security Auditing:** Runs ClamAV virus signature updates, scans common vulnerability points (`/home`, `/tmp`, `/var/www`), quarantines malicious files, and checks for rootkits and suspicious network ports.

## 📂 Scripts Overview

### 1. AI File Organizer (`organizer.sh`)
An intelligent file manager that cleans up your `Downloads` directory. It reads file metadata and extracts text snippets (even from PDFs), then prompts a local LLM to assign a descriptive name and place it into one of 24 specific categories (e.g., `DOCUMENTS`, `ARCHIVES`, `CODE`, `TAXES`).

### 2. Project Initializer (`init-project.sh`)
A massive time-saver for starting new projects. It sets up standard directories (`src/`, `docs/`, `tests/`), generates a starter `Makefile`, and uses the GitHub CLI (`gh`) to automatically create and push to a remote repository.

### 3. System Antivirus (`antivirus.sh`)
A comprehensive security sweep script. It handles the installation of missing dependencies (like ClamAV), updates virus definitions, performs recursive malware scans, and inspects active listening ports and potential rootkits.

## ⚙️ Installation & Prerequisites

To use these scripts, you will need a Linux/Unix-based environment. Specific scripts require different dependencies:

* **General:** `bash`, `git`, standard GNU coreutils.
* **For `organizer.sh`:** * [Ollama](https://ollama.com/) (with the `llama3.2` model downloaded)
  * `pdftotext` (optional, for PDF scanning support)
* **For `init-project.sh`:** * [GitHub CLI (`gh`)](https://cli.github.com/) authenticated to your account.
* **For `antivirus.sh`:** * Root (`sudo`) privileges
  * `clamav` and `rkhunter` (The script will attempt to install ClamAV if missing).

Clone the repository and make the scripts executable:

```bash
git clone https://github.com/mtepenner/fun-with-bash.git
cd fun-with-bash
chmod +x *.sh
```

## 💻 Usage

**Running the AI Organizer:**
```bash
./organizer.sh
```

**Initializing a new Python Project:**
```bash
./init-project.sh my-awesome-app python
# Supported languages: python, js (or javascript), cpp
```

**Running a System Security Scan:**
```bash
sudo ./antivirus.sh
```

## 🧰 Technologies Used
* **Bash** - Core scripting language.
* **Ollama (Llama 3.2)** - Local LLM processing for contextual file renaming.
* **GitHub CLI (`gh`)** - Automated remote repository management.
* **ClamAV & RKHunter** - Malware and rootkit detection.

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/yourusername/fun-with-bash/issues). 

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
