# drx-mac-audit
Steps from Sequoia to Tahoe. iPhone Duo Prep.

Dr. X, we’re doing this properly. Project Clean Slate: M2 Max → macOS Tahoe → iPhone Duo Development. 🚀

And yes, we’re going to use a script. But I want to approach this like an engineering migration, not a factory reset.

The goal: Transform your MacBook Pro into a clean, fast development machine without losing your source code, certificates, credentials, or personal files.

I’m choosing a five-phase migration, with a checkpoint after each phase.

The migration plan

Phase	Operation	Risk
1	Audit everything on your Mac	🟢 None
2	Back up projects, credentials, and files	🟢 Low
3	Verify backups and prepare for migration	🟡 Low
4	Install Tahoe and perform a clean reset	🔴 Destructive
5	Install Xcode and rebuild development environment	🟢 Low

One detail: Apple’s Erase All Content and Settings retains the currently installed macOS version. That means we can first upgrade to Tahoe, then use that function to establish a fresh Tahoe environment. We don’t necessarily need to manually erase the disk from Recovery.  

⸻

PHASE 1 — Mac Forensic Audit

Before deleting anything, let’s find out exactly what we’re dealing with.

I want to inspect:

* Installed development environments.
* Xcode installations and simulator storage.
* Git repositories.
* Homebrew packages.
* SSH keys and signing certificate presence.
* Large directories consuming storage.
* Existing backups.
* External LaCie drive configuration.

We’re going to produce a report you can inspect.

Step 1. Open Terminal

Copy and paste this entire script:

cat > ~/Desktop/drx-mac-audit.sh <<'SCRIPT'
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
SCRIPT
chmod +x ~/Desktop/drx-mac-audit.sh
~/Desktop/drx-mac-audit.sh

Step 2. What this script does

It creates:

Desktop/DrX-Mac-Audit.txt

The audit collects system information and developer-tool metadata.

It does not:

* Delete applications.
* Erase files.
* Modify partitions.
* Uninstall Xcode.
* Access the contents of your private keys.
* Format the LaCie drive.

It does list SSH key filenames, signing identity names, and potentially identifying hardware information. Review the report before sharing it, and redact serial numbers, personal paths, or anything sensitive.

Step 3. Send me the audit

You can upload DrX-Mac-Audit.txt here.

I’ll use it to identify what needs to be preserved, what can be reinstalled, and what can be discarded.

⸻

PHASE 2 — Backup strategy

This is the most important phase.

Your LaCie has 2 TB of storage, but its existing CoreStorage configuration suggests it may contain an older macOS volume.

We will not format it until we’ve established whether it contains important files.

For your Mac, we need to preserve three categories:

Category	Strategy
Personal documents and media	Verified external backup
Snake, SFX, Split Wallet, other apps	Git remote + backup of local files
Certificates, secrets, signing keys	Encrypted backup

I especially want to protect your Apple distribution certificates and any Split Wallet payment integration credentials.

A Git repository alone is not a complete backup.

⸻

PHASE 3 — Upgrade and reset

After verification, the sequence will be:

Sequoia → Tahoe → Erase All Content and Settings → Fresh Tahoe

Your M2 Max is compatible with Tahoe. And Apple’s Xcode requirements confirm that Xcode 27.1 requires Tahoe 26.6 or later.  

We’ll install the required version, verify that it starts correctly, and only then proceed with the clean reset.

⸻

PHASE 4 — Development environment

The new Mac will have a deliberate, minimal toolchain.

I want Xcode, Git, Homebrew, Swift, Node.js, and only the simulator runtimes your projects actually need.

We’ll use Git to restore your projects instead of automatically migrating years of applications and configuration files.

⸻

PHASE 5 — iPhone Duo

Our first milestone will be straightforward:

Compile Split Wallet → Deploy to your physical iPhone Duo → Launch successfully → Test the adaptive interface.

Once that works, we’ll begin modernizing the layouts and then move to SFX and Snake.

⸻

Your next move

Run the Phase 1 script and send me the resulting audit file.

Don’t delete DerivedData, clear simulators, format the LaCie, or reset your Mac yet.

We’ll first establish exactly what your current machine contains. Then we’ll preserve what matters and remove the rest.

One migration. One clean development environment. Your M2 Max gets a fresh start.
