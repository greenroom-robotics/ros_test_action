#!/bin/bash

# Script to find changed ROS packages based on changed files
# Using colcon would be more resilient but this saves installing it...
# Usage: find_changed_packages.sh "file1 file2 file3..."

CHANGED_FILES="$1"
changed_packages=()

for file in $CHANGED_FILES; do
  dir=$(dirname "$file")
  # Walk up to find package.xml
  while [[ "$dir" != "." ]]; do
    if [[ -f "$dir/package.xml" ]]; then
      # Extract package name from package.xml
      package_name=$(grep -oP '<name>\K[^<]+' "$dir/package.xml" 2>/dev/null || echo "")
      if [[ -n "$package_name" ]]; then
        changed_packages+=("$package_name")
      fi
      break
    fi
    dir=$(dirname "$dir")
  done
done

# Remove duplicates
unique_packages=($(printf '%s\n' "${changed_packages[@]}" | sort -u))
echo "${unique_packages[@]}"