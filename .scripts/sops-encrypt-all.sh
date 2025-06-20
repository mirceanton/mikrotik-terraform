#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

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
    encrypted_file="${file%.json}.sops.json"
    encrypt_file "$file" "$encrypted_file"
done

# Find and encrypt credentials.auto.tfvars files
find . -name "credentials.auto.tfvars" -type f | while IFS= read -r file; do
    encrypted_file="${file%.tfvars}.sops.tfvars"
    encrypt_file "$file" "$encrypted_file"
done