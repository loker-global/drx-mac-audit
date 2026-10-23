#!/bin/bash

REPORT="$HOME/Desktop/DrX-Storage-Audit.txt"

{
  echo "=================================="
  echo "DR. X — STORAGE DEEP AUDIT"
  echo "=================================="
  date
  echo

  echo "=== MAIN DIRECTORIES ==="
  du -sh "$HOME"/{Documents,Downloads,Desktop,Movies,Pictures,Library} 2>/dev/null

  echo
  echo "=== DOCUMENTS ==="
  du -h -d 2 "$HOME/Documents" 2>/dev/null | sort -h | tail -30

  echo
  echo "=== LIBRARY ==="
  du -h -d 2 "$HOME/Library" 2>/dev/null | sort -h | tail -35

  echo
  echo "=== XCODE INSTALLATIONS ==="
  for app in \
    "/Applications/Xcode.app" \
    "/Applications/Xcode New.app" \
    "/Applications/Xcode-beta.app"
  do
    if [ -d "$app" ]; then
      du -sh "$app"
      /usr/libexec/PlistBuddy \
        -c 'Print CFBundleShortVersionString' \
        "$app/Contents/Info.plist" 2>/dev/null
    fi
  done

  echo
  echo "=== SIMULATOR STORAGE ==="
  du -h -d 2 "$HOME/Library/Developer/CoreSimulator" \
    2>/dev/null | sort -h | tail -20

  echo
  echo "=== DOWNLOADS ==="
  du -h -d 1 "$HOME/Downloads" \
    2>/dev/null | sort -h | tail -20

  echo
  echo "=== EXTERNAL DRIVES ==="
  diskutil list external physical

  echo
  echo "=== AVAILABLE STORAGE ==="
  df -h "$HOME"

} > "$REPORT" 2>&1

echo "Report created: $REPORT"
