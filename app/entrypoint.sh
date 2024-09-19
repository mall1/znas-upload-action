#!/bin/sh -l

# Run the Puppeteer script
node /app/uploadScript.js

echo "file=aaa" >>"$GITHUB_OUTPUT"

exit 0
