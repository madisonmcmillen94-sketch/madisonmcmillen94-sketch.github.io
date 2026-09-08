#!/bin/bash
# Usage: ./add-ga4.sh G-XXXXXXXXXX
# Adds the GA4 tracking snippet to every .html file in this directory.
# Run once after creating your GA4 property and getting the Measurement ID.

if [ -z "$1" ]; then
  echo "Usage: ./add-ga4.sh G-XXXXXXXXXX"
  echo "Pass your GA4 Measurement ID as the first argument."
  exit 1
fi

GA4_ID="$1"

GA4_SNIPPET="<!-- Google Analytics 4 -->\n<script async src=\"https://www.googletagmanager.com/gtag/js?id=${GA4_ID}\"></script>\n<script>\nwindow.dataLayer = window.dataLayer || [];\nfunction gtag(){dataLayer.push(arguments);}\ngtag('js', new Date());\ngtag('config', '${GA4_ID}');\n</script>"

count=0
for file in *.html; do
  if grep -q "googletagmanager.com/gtag" "$file"; then
    echo "SKIP (already has GA4): $file"
    continue
  fi
  # Insert after the opening <head> tag (before the AdSense script)
  sed -i "s|<head>|<head>\n${GA4_SNIPPET}|" "$file"
  echo "ADDED GA4 to: $file"
  count=$((count + 1))
done

echo ""
echo "Done — added GA4 (${GA4_ID}) to ${count} file(s)."
echo "Commit and push to deploy."
