#!/bin/bash

# ==========================================
# CONFIGURATION
# ==========================================
# Define directories
DOWNLOADS_DIR="$HOME/Downloads"
TARGET_DIR="$HOME/SortedDownloads"

# Define the local LLM model to use
OLLAMA_MODEL="llama3.2"

# Exhaustive Categories List
CATEGORIES=(
    "GAMES" "AUDIO" "IMAGES" "VIDEOS" "ARCHIVES" "INSTALLERS" 
    "CODE" "SCRIPTS" "DOCUMENTS" "SPREADSHEETS" "PRESENTATIONS" 
    "EBOOKS" "TAXES" "RECEIPTS" "ESSAYS" "FONTS" "3D_MODELS" 
    "CONFIGS" "KEYS" "DATA" "LOGS" "TORRENTS" "BACKUPS" "UNKNOWN"
)

# ==========================================
# SETUP & DEPENDENCY CHECKS
# ==========================================
if ! command -v ollama &> /dev/null; then
    echo "❌ Error: 'ollama' is required but not installed."
    exit 1
fi

echo "Checking for Ollama model: $OLLAMA_MODEL..."
if ollama show "$OLLAMA_MODEL" &> /dev/null; then
    echo "✅ Model '$OLLAMA_MODEL' is ready."
else
    echo "⬇️ Model '$OLLAMA_MODEL' not found. Downloading..."
    ollama pull "$OLLAMA_MODEL"
    if [ $? -ne 0 ]; then
        echo "❌ Error: Failed to download the model."
        exit 1
    fi
fi

for category in "${CATEGORIES[@]}"; do
    mkdir -p "$TARGET_DIR/$category"
done

echo "Starting massive categorization and renaming..."

# ==========================================
# PROCESSING
# ==========================================
for filepath in "$DOWNLOADS_DIR"/*; do
    [ -d "$filepath" ] && continue
    [ -e "$filepath" ] || continue

    filename=$(basename "$filepath")
    filetype=$(file -b "$filepath")
    preview=""

    # 1. Extract extension
    extension="${filename##*.}"
    if [[ "$filename" == "$extension" ]]; then
        ext_string=""
    else
        ext_string=".$extension"
    fi

    # 2. Extract modification date
    if stat -c %Y "$filepath" &>/dev/null; then
        mod_time=$(stat -c %Y "$filepath")
        file_date=$(date -d "@$mod_time" +"%m-%d-%y")
    else
        mod_time=$(stat -f %m "$filepath")
        file_date=$(date -r "$mod_time" +"%m-%d-%y")
    fi

    # 3. Extract text snippet for context
    if [[ "$filetype" == *"text"* ]]; then
        preview=$(head -c 300 "$filepath" 2>/dev/null)
    elif [[ "$filetype" == *"PDF"* ]] && command -v pdftotext &> /dev/null; then
        preview=$(pdftotext "$filepath" - 2>/dev/null | head -c 300)
    fi

    # 4. Construct prompt for Ollama
    prompt="You are an advanced automated file sorter. 
Task 1: Categorize the file into exactly ONE of these categories: ${CATEGORIES[*]}. 
Task 2: Determine a short, highly descriptive, appropriate base name for the file based on its contents or original name (DO NOT include dates, spaces, or file extensions. Use hyphens for spaces).
Output EXACTLY one line with the format: CATEGORY|Appropriate-Name
Do not output any conversational text or explanations.

Filename: $filename
File type: $filetype
File content preview: $preview"

    # Call Ollama
    response=$(echo "$prompt" | ollama run "$OLLAMA_MODEL")

    # Clean LLM output
    llm_output=$(echo "$response" | tr -d '\r' | xargs)

    # 5. Parse response
    IFS='|' read -r category base_name <<< "$llm_output"

    category=$(echo "$category" | tr '[:lower:]' '[:upper:]' | tr -d ' ')
    base_name=$(echo "$base_name" | tr -d ' ')

    # Fallbacks
    if [[ -z "$base_name" || "$base_name" == "Error" ]]; then
        base_name="unnamed-file"
    fi

    # 6. Construct new filename
    new_filename="${base_name}-${file_date}${ext_string}"

    # 7. Validate and Move
    if [[ " ${CATEGORIES[*]} " =~ " ${category} " ]]; then
        if [ "$category" != "UNKNOWN" ]; then
            destination="$TARGET_DIR/$category/$new_filename"
            counter=1
            while [[ -e "$destination" ]]; do
                new_filename="${base_name}-${file_date}-${counter}${ext_string}"
                destination="$TARGET_DIR/$category/$new_filename"
                ((counter++))
            done

            echo "✅ Moving: '$filename' -> $category/$new_filename"
            mv "$filepath" "$destination"
        else
            echo "➖ Skipping: '$filename' (Categorized as UNKNOWN)"
        fi
    else
        echo "❌ Error processing '$filename' (Model output: $llm_output)"
    fi
done

echo "Sorting and renaming complete."
