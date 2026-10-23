#!/bin/bash

set -u

REPORT="$HOME/Desktop/DrX-Mac-Audit.txt"

{
echo "========================================"
echo "       DR. X — MAC CLEAN SLATE"
echo "========================================"
echo "Generated: $(date)"
echo

echo "========== HARDWARE =========="
system_profiler SPHardwareDataType
echo

echo "========== MACOS =========="
sw_vers
echo

echo "========== INTERNAL STORAGE =========="
df -h /
echo

echo "========== EXTERNAL DISKS =========="
diskutil list external physical
echo

echo "========== HOME FOLDER USAGE =========="
du -sh "$HOME"/Documents \
       "$HOME"/Downloads \
       "$HOME"/Desktop \
       "$HOME"/Movies \
       "$HOME"/Pictures \
       "$HOME"/Library \
       2>/dev/null
echo

echo "========== XCODE =========="
xcode-select -p 2>&1
xcodebuild -version 2>&1
echo

echo "========== XCODE STORAGE =========="
du -sh \
 "$HOME/Library/Developer/Xcode/DerivedData" \
 "$HOME/Library/Developer/CoreSimulator" \
 "$HOME/Library/Developer/Xcode/Archives" \
 2>/dev/null
echo

echo "========== INSTALLED XCODE APPS =========="
find /Applications \
 -maxdepth 1 \
 -iname '*xcode*.app' \
 -print 2>/dev/null
echo

echo "========== DEVELOPMENT TOOLS =========="

for tool in \
 git node npm python3 ruby swift brew docker
do
  echo "--- $tool ---"
  command -v "$tool" || true
done
echo

echo "========== HOMEBREW PACKAGES =========="
if command -v brew >/dev/null 2>&1; then
  brew list --formula
  echo "--- CASKS ---"
  brew list --cask
else
  echo "Homebrew not found"
fi
echo

echo "========== SSH KEY FILES =========="
if [ -d "$HOME/.ssh" ]; then
  find "$HOME/.ssh" -maxdepth 1 -type f \
    -exec basename {} \;
else
  echo "No SSH directory found"
fi
echo

echo "========== SIGNING IDENTITIES =========="
security find-identity -v -p codesigning
echo

echo "========== POSSIBLE GIT REPOSITORIES =========="
find "$HOME/Documents" "$HOME/Desktop" \
 "$HOME/Developer" "$HOME/Projects" \
 -maxdepth 5 \
 -name .git \
 -prune \
 -print 2>/dev/null
echo

echo "========== TIME MACHINE =========="
tmutil destinationinfo 2>&1
echo
tmutil latestbackup 2>&1
echo

echo "========================================"
echo "AUDIT COMPLETE"
echo "========================================"

} > "$REPORT" 2>&1

echo
echo "Audit saved to:"
echo "$REPORT"
echo
echo "No files were deleted or modified by the audit."
