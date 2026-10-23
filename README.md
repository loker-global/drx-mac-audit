# drx-mac-audit

Migration plan for moving an M2 Max MacBook Pro from macOS Sequoia to macOS Tahoe, in preparation for iPhone Duo development — without losing source code, certificates, credentials, or personal files.

This is treated as an engineering migration, not a factory reset: audit first, back up, verify, then upgrade/reset, then rebuild.

## Migration Plan

| Phase | Operation | Risk |
|---|---|---|
| 1 | Audit everything on the Mac | 🟢 None |
| 2 | Back up projects, credentials, and files | 🟢 Low |
| 3 | Verify backups and prepare for migration | 🟡 Low |
| 4 | Install Tahoe and perform a clean reset | 🔴 Destructive |
| 5 | Install Xcode and rebuild development environment | 🟢 Low |

> **Note:** Apple's *Erase All Content and Settings* retains the currently installed macOS version. The plan is to upgrade to Tahoe first, then use that function to produce a fresh Tahoe environment — avoiding a manual disk erase from Recovery.

---

## Phase 1 — Mac Forensic Audit

Before deleting anything, establish exactly what's on the machine.

**Inspected:**
- Installed development environments
- Xcode installations and simulator storage
- Git repositories
- Homebrew packages
- SSH keys and signing certificate presence
- Large directories consuming storage
- Existing backups
- External LaCie drive configuration

### Running the audit

```bash
chmod +x drx-mac-audit.sh
./drx-mac-audit.sh
```

This generates `~/Desktop/DrX-Mac-Audit.txt`.

### What the script does

Collects system information and developer-tool metadata. It does **not**:

- Delete applications
- Erase files
- Modify partitions
- Uninstall Xcode
- Access the contents of private keys
- Format the LaCie drive

It **does** list SSH key filenames, signing identity names, and some hardware identifiers. Review the generated report before sharing it, and redact serial numbers, personal paths, or anything sensitive.

---

## Phase 2 — Backup Strategy

The most important phase. The external LaCie drive (2 TB) has an existing CoreStorage configuration suggesting an older macOS volume — it will **not** be formatted until confirmed safe.

| Category | Strategy |
|---|---|
| Personal documents and media | Verified external backup |
| Project repos (Snake, SFX, Split Wallet, etc.) | Git remote + local file backup |
| Certificates, secrets, signing keys | Encrypted backup |

Apple distribution certificates and Split Wallet payment integration credentials require particular care. **A Git repository alone is not a complete backup.**

---

## Phase 3 — Upgrade and Reset

Sequence:

```
Sequoia → Tahoe → Erase All Content and Settings → Fresh Tahoe
```

The M2 Max is compatible with Tahoe. Xcode 27.1 requires Tahoe 26.6 or later. Install the required version, verify it starts correctly, then proceed with the clean reset.

---

## Phase 4 — Development Environment

Minimal, deliberate toolchain on the fresh install:

- Xcode
- Git
- Homebrew
- Swift
- Node.js
- Only the simulator runtimes actually needed per project

Projects are restored via Git rather than migrating years of accumulated application state and configuration files.

---

## Phase 5 — iPhone Duo

First milestone:

```
Compile Split Wallet → Deploy to physical iPhone Duo → Launch successfully → Test adaptive interface
```

Once verified, proceed to modernizing layouts, then SFX and Snake.

---

## Status / Next Step

Run the Phase 1 script (`drx-mac-audit.sh`) and review the resulting audit file.

**Do not** delete DerivedData, clear simulators, format the LaCie drive, or reset the Mac until the audit and backup phases are complete.
