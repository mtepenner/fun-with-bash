#!/bin/bash

# Usage: ./init-project.sh <project_name> <language>

PROJECT_NAME=$1
LANG=$2

if [[ -z "$PROJECT_NAME" || -z "$LANG" ]]; then
    echo "Usage: ./init-project.sh <project_name> <python|js|cpp>"
    exit 1
fi

# Create directory structure
mkdir -p "$PROJECT_NAME"/{src,docs,tests}
cd "$PROJECT_NAME" || exit

# Initialize based on language
case $LANG in
    python)
        touch src/main.py docs/README.md
        echo 'if __name__ == "__main__":\n    print("Hello, World!")' > src/main.py
        echo "# $PROJECT_NAME (Python)" > docs/README.md
        ;;
    js|javascript)
        npm init -y > /dev/null
        touch src/index.js
        echo 'console.log("Hello, World!");' > src/index.js
        ;;
    cpp)
        touch src/main.cpp
        echo -e '#include <iostream>\n\nint main() {\n    std::cout << "Hello, World!" << std::endl;\n    return 0;\n}' > src/main.cpp
        ;;
    *)
        echo "Language '$LANG' not supported yet. Folders created anyway."
        ;;
esac

echo "Project '$PROJECT_NAME' initialized for $LANG."
