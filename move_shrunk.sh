#!/bin/bash

set -euo pipefail

# overwrites old files with the smaller ones if they exist
find . -name '*.png.new' | while read -r line; do
	new_file="${line%.new}"
	mv "$line" "$new_file"
done
