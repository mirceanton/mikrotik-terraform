#!/bin/bash

GRAY='\033[0;37m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

verbose=false

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -v | --verbose)
        verbose=true
        shift
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Read ignore patterns from .sopsignore if it exists
declare -a ignore_patterns=()
if [ -f ".sopsignore" ]; then
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
            # Remove leading/trailing whitespace
            line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            if [[ -n "$line" ]]; then
                ignore_patterns+=("$line")
            fi
        fi
    done < ".sopsignore"
fi

# Function to check if a path should be ignored
should_ignore() {
    local file_path="$1"
    
    for pattern in "${ignore_patterns[@]}"; do
        # Convert relative path to match against pattern
        local check_path="${file_path#./}"
        
        # Handle directory patterns (ending with /)
        if [[ "$pattern" == */ ]]; then
            if [[ "$check_path/" == $pattern* ]]; then
                return 0
            fi
        else
            # Handle file patterns
            if [[ "$check_path" == $pattern* ]] || [[ "$check_path" == */$pattern* ]] || [[ "$(basename "$check_path")" == $pattern ]]; then
                return 0
            fi
        fi
    done
    
    return 1
}

# Function to encrypt a file
encrypt_file() {
    local plain_file="$1"
    local encrypted_file="$2"
    
    if [ -f "$encrypted_file" ]; then
        # Decrypt the encrypted version to compare
        decrypted_temp=$(mktemp)
        sops --decrypt "$encrypted_file" >"$decrypted_temp"

        # Compare the decrypted version with the file on disk
        if cmp -s "$plain_file" "$decrypted_temp"; then
            echo -e "${GREEN}No changes detected. Skipping encryption for file: $plain_file${NC}"
        else
            echo -e "${RED}Changes detected. Re-encrypting file: $plain_file${NC}"
            sops --encrypt "$plain_file" >"$encrypted_file"
        fi

        rm "$decrypted_temp"
    else
        # No encrypted version exists, encrypt the file
        echo -e "${RED}Encrypting file: $plain_file${NC}"
        sops --encrypt "$plain_file" >"$encrypted_file"
    fi
}

# Find and encrypt tfstate.json files
find . -name "tfstate.json" -type f | while IFS= read -r file; do
    if should_ignore "$file"; then
        if [ "$verbose" = true ]; then
            echo -e "${GRAY}Ignoring file: $file${NC}"
        fi
        continue
    fi
    encrypted_file="${file%.json}.sops.json"
    encrypt_file "$file" "$encrypted_file"
done

# Find and encrypt credentials.auto.tfvars files
find . -name "credentials.auto.tfvars" -type f | while IFS= read -r file; do
    if should_ignore "$file"; then
        if [ "$verbose" = true ]; then
            echo -e "${GRAY}Ignoring file: $file${NC}"
        fi
        continue
    fi
    encrypted_file="${file%.tfvars}.sops.tfvars"
    encrypt_file "$file" "$encrypted_file"
done