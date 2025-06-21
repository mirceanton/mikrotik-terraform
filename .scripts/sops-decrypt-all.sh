#!/bin/bash

GRAY='\033[0;37m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

force=false
verbose=false

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -f | --force)
        force=true
        shift
        ;;
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

# Function to decrypt a file
decrypt_file() {
    local encrypted_file="$1"
    local decrypted_file="$2"
    
    if [ -f "$decrypted_file" ]; then
        # Decrypt the encrypted version to temp file
        decrypted_temp=$(mktemp)
        sops --decrypt "$encrypted_file" >"$decrypted_temp"

        # Compare the decrypted version with the existing decrypted file
        if cmp -s "$decrypted_file" "$decrypted_temp"; then
            echo -e "${GREEN}No changes detected. Skipping decryption for file: $encrypted_file${NC}"
        else
            if [ "$force" = true ]; then
                mv "$decrypted_temp" "$decrypted_file"
                echo -e "${RED}File replaced with the decrypted content: $decrypted_file${NC}"
            else
                echo -e "${RED}Changes detected. Use -f or --force flag to overwrite $encrypted_file${NC}"
            fi
        fi

        if [ -f "$decrypted_temp" ]; then
            rm "$decrypted_temp"
        fi
    else
        # No decrypted file exists, decrypt and create it
        echo -e "${RED}Decrypting file: $encrypted_file${NC}"
        sops --decrypt "$encrypted_file" >"$decrypted_file"
    fi
}

# Find and decrypt tfstate.sops.json files
find . -name "tfstate.sops.json" -type f | while IFS= read -r file; do
    if should_ignore "$file"; then
        if [ "$verbose" = true ]; then
            echo -e "${GRAY}Ignoring file: $file${NC}"
        fi
        continue
    fi
    decrypted_file="${file%.sops.json}.json"
    decrypt_file "$file" "$decrypted_file"
done

# Find and decrypt credentials.auto.sops.tfvars files
find . -name "credentials.auto.sops.tfvars" -type f | while IFS= read -r file; do
    if should_ignore "$file"; then
        if [ "$verbose" = true ]; then
            echo -e "${GRAY}Ignoring file: $file${NC}"
        fi
        continue
    fi
    decrypted_file="${file%.sops.tfvars}.tfvars"
    decrypt_file "$file" "$decrypted_file"
done