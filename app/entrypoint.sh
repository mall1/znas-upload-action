#!/bin/sh -l

# Variables
UPLOAD_PATH=${UPLOAD_PATH:-"."} # Default to current directory if not provided
UPLOAD_TARGET=""

# Check if UPLOAD_PATH is a directory or a file
if [ -d "$UPLOAD_PATH" ]; then
	# If it's a directory, determine the zip file name and zip the folder
	if [ -n "$UPLOAD_NAME" ]; then
		UPLOAD_TARGET="${UPLOAD_NAME}_$(date +"%Y%m%d_%H%M%S").zip"
	else
		UPLOAD_TARGET="${UPLOAD_PATH##*/}_$(date +"%Y%m%d_%H%M%S").zip"
	fi
	zip -r "$UPLOAD_TARGET" "$UPLOAD_PATH"
elif [ -f "$UPLOAD_PATH" ]; then
	# If it's a file and UPLOAD_NAME is provided, copy the file with the new name
	if [ -n "$UPLOAD_NAME" ]; then
		# Extract the file extension
		EXT="${UPLOAD_PATH##*.}"
		# Create the new file name with the original extension
		UPLOAD_TARGET="${UPLOAD_NAME}.${EXT}"
		# Copy the file to the new name
		cp "$UPLOAD_PATH" "$UPLOAD_TARGET"
	else
		# If no UPLOAD_NAME is provided, use the original file as the target
		UPLOAD_TARGET="$UPLOAD_PATH"
	fi
else
	echo "Error: $UPLOAD_PATH is not a valid file or directory."
	exit 1
fi

# Run the Puppeteer script with the file or zip path
UPLOAD_FILE=$UPLOAD_TARGET node /app/uploadScript.js

# Set the output
echo "uploaded_file=$UPLOAD_TARGET" >>"$GITHUB_OUTPUT"

exit 0
