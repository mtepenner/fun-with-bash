#!/bin/bash

PROJECT_NAME=$1
LANG=$2

if [[ -z "$PROJECT_NAME" || -z "$LANG" ]]; then
    echo "Usage: ./init-project.sh <project_name> <python|js|cpp>"
    exit 1
fi

# 1. Create Structure
mkdir -p "$PROJECT_NAME"/{src,docs,tests}
cd "$PROJECT_NAME" || exit

# 2. Initialize Git and GitHub Repo
git init > /dev/null
# Creates a private repo and sets 'origin' automatically
gh repo create "$PROJECT_NAME" --private --source=. --remote=origin

# 3. Create Language-Specific Files
case $LANG in
    python)
        echo 'if __name__ == "__main__":' > src/main.py
        echo '    print("Hello!")' >> src/main.py
        ;;
    js|javascript)
        npm init -y > /dev/null
        echo 'console.log("Hello!");' > src/index.js
        ;;
    cpp)
        echo -e '#include <iostream>\n\nint main() {\n    std::cout << "Hello!" << std::endl;\n    return 0;\n}' > src/main.cpp
        ;;
esac

# 4. Generate the Makefile
cat <<EOF > Makefile
# Sync code to GitHub
sync:
	git add .
	git commit -m "Automated update via Makefile"
	git push origin main

# Clean up temporary files (example)
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
EOF

# 5. Initial Push
git add .
git commit -m "Initial project setup"
git branch -M main
git push -u origin main

echo "Project '$PROJECT_NAME' is live at https://github.com/$(gh api user -q .login)/$PROJECT_NAME"
