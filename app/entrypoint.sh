#!/bin/sh -l

# Variables
UPLOAD_PATH=${UPLOAD_PATH:-"."}                      # Default to current directory if not provided
ADD_TIMESTAMP_SUFFIX=${ADD_TIMESTAMP_SUFFIX:-"true"} # Default to true if not provided
UPLOAD_TARGET=""
TIMESTAMP_SUFFIX=""

# Generate the timestamp suffix if the switch is enabled
if [ "$ADD_TIMESTAMP_SUFFIX" = "true" ]; then
	TIMESTAMP_SUFFIX="_$(date +"%Y%m%d_%H%M%S")"
fi

# Check if UPLOAD_PATH is a directory or a file
if [ -d "$UPLOAD_PATH" ]; then
	# If it's a directory, determine the zip file name and zip the folder
	if [ -n "$UPLOAD_NAME" ]; then
		UPLOAD_TARGET="${UPLOAD_NAME}${TIMESTAMP_SUFFIX}.zip"
	else
		UPLOAD_TARGET="${UPLOAD_PATH##*/}${TIMESTAMP_SUFFIX}.zip"
	fi
	# Zip the folder
	zip -r "$UPLOAD_TARGET" "$UPLOAD_PATH"
elif [ -f "$UPLOAD_PATH" ]; then
	# If it's a file and UPLOAD_NAME is provided, copy or rename the file accordingly
	if [ -n "$UPLOAD_NAME" ]; then
		# Extract the file extension
		EXT="${UPLOAD_PATH##*.}"
		# Create the new file name with or without the timestamp suffix
		UPLOAD_TARGET="${UPLOAD_NAME}${TIMESTAMP_SUFFIX}.${EXT}"
	else
		# Extract the file extension (everything after the last .)
		EXT="${UPLOAD_PATH##*.}"
		# Extract the base name (everything before the last .)
		BASENAME="$(basename "$UPLOAD_PATH" ".$EXT")"
		# Construct the new file name with the timestamp before the extension
		UPLOAD_TARGET="${BASENAME}${TIMESTAMP_SUFFIX}.${EXT}"
	fi

	# Only copy if the source and destination are different
	if [ "$UPLOAD_PATH" != "$UPLOAD_TARGET" ]; then
		cp "$UPLOAD_PATH" "$UPLOAD_TARGET"
	else
		echo "Source and destination are the same; skipping copy."
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
