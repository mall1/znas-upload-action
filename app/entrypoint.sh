#!/bin/sh -l

# Variables
UPLOAD_PATH=${UPLOAD_PATH:-"."} # Default to current directory if not provided
ZIP_FILE=""

# Determine if the path is a file or directory and create a zip file accordingly
if [ -d "$UPLOAD_PATH" ]; then
	# If it's a directory, zip the folder
	ZIP_FILE="${UPLOAD_PATH##*/}_$(date +"%Y%m%d_%H%M%S")_$(git rev-parse --short HEAD).zip"
	zip -r "$ZIP_FILE" "$UPLOAD_PATH"
elif [ -f "$UPLOAD_PATH" ]; then
	# If it's a file, zip the file
	ZIP_FILE="$(basename "$UPLOAD_PATH" ."${UPLOAD_PATH##*.}")_$(date +"%Y%m%d_%H%M%S")_$(git rev-parse --short HEAD).zip"
	zip "$ZIP_FILE" "$UPLOAD_PATH"
else
	echo "Error: $UPLOAD_PATH is not a valid file or directory."
	exit 1
fi

# Run the Puppeteer script with the zip file path
UPLOAD_FILE=$ZIP_FILE node /app/uploadScript.js

# Set the output
echo "uploaded_file=$ZIP_FILE" >>"$GITHUB_OUTPUT"

exit 0
