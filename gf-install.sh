#!/bin/bash

# Colors for interactive text
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create directory to store files if it doesn't already exist
GF_DIR="$HOME/.gf"
mkdir -p $GF_DIR

# List of GitHub URLs
repos=(
  "https://github.com/scumdestroy/YouthCrew-GF-Patterns"
  "https://github.com/NitinYadav00/gf-patterns"
  "https://github.com/Jude-Paul/GF-Patterns-For-Dangerous-PHP-Functions"
  "https://github.com/seqrity/Allin1gf"
  "https://github.com/cypher3107/GF-Patterns"
  "https://github.com/R0X4R/Garud"
  "https://github.com/arthur4ires/gfPatterns"
  "https://github.com/Matir/gf-patterns"
  "https://github.com/cypher3107/GF-Patterns"
  "https://github.com/bp0lr/myGF_patterns"
  "https://github.com/dwisiswant0/gf-secrets"
  "https://github.com/1ndianl33t/Gf-Patterns"
  "https://github.com/robre/gf-patterns"
  "https://github.com/mrofisr/gf-patterns"
  "https://github.com/r00tkie/grep-pattern"
)

# Function to download JSON files from GitHub repo
download_json() {
    repo_url=$1
    echo -e "${YELLOW}Downloading JSON files from ${repo_url}...${NC}"

    # Get the repo name from the URL
    repo_name=$(basename $repo_url)

    # Use git clone --depth=1 for faster cloning
    git clone --depth=1 "$repo_url" "$GF_DIR/$repo_name" &> /dev/null

    # Find .json files and move them to ~/.gf folder
    find "$GF_DIR/$repo_name" -type f -name "*.json" -exec mv {} $GF_DIR \;

    # Remove the cloned folder after downloading
    rm -rf "$GF_DIR/$repo_name"

    echo -e "${GREEN}Finished downloading .json files from ${repo_name}.${NC}"
}

# Interactive intro
echo -e "${GREEN}Welcome to the GF Patterns downloader script!${NC}"
echo -e "${YELLOW}This script will download all JSON files from several GitHub repositories and save them to $GF_DIR.${NC}"
echo -e "${YELLOW}The process will begin shortly...${NC}"

# Loop through all repos and download JSON files
for repo in "${repos[@]}"; do
    download_json "$repo"
done

# Interactive outro
echo -e "${GREEN}All .json files have been successfully downloaded and saved to $GF_DIR.${NC}"
echo -e "${GREEN}Thank you for using this script!${NC}"
cd ~/
