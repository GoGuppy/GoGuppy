# GUI Test Plan

All 47 files below are in `native-import/` and import at **Devices > Configuration > Create > Import policy**. Work a phase, confirm on the test VM, take a checkpoint, move to the next. Do not start Phase 3 without a checkpoint you trust.

`D` = assign to device group, `U` = assign to user group (OIB naming convention).

## Phase 1 - Harmless, visible results (16)

Nothing here can lock you out. Good for validating the import + sync + report loop itself.

- [ ] Device Security - D - Timezone
- [ ] Microsoft OneDrive - D - Configuration
- [ ] Microsoft OneDrive - U - Configuration
- [ ] Microsoft Edge - D - Updates
- [ ] Microsoft Edge - U - Password Management
- [ ] Microsoft Edge - U - Profiles, Sign-In and Sync
- [ ] Microsoft Edge - U - User Experience
- [ ] Microsoft Office - D - Updates
- [ ] Microsoft Office - U - Config and Experience
- [ ] Windows User Experience - D - Feature Configuration
- [ ] Windows User Experience - D - Settings Sync
- [ ] Windows User Experience - U - Copilot
- [ ] Windows Apps - D - In-Box App Removal
- [ ] Device Security - U - Windows Spotlight and Org Messages
- [ ] Windows Update for Business - D - Delivery Optimisation
- [ ] Windows Update for Business - D - Reports and Telemetry

## Phase 2 - Security tightening, low lockout risk (21)

User-visible restrictions start here. Watch for app/store complaints.

- [ ] Device Security - D - Login and Lock Screen
- [ ] Device Security - U - Power and Device Lock
- [ ] Device Security - D - Enhanced Phishing Protection
- [ ] Device Security - D - Script File Associations
- [ ] Device Security - D - Audit and Event Logging
- [ ] Device Security - D - Location and Privacy
- [ ] Device Security - D - Printing
- [ ] Device Security - D - Config Refresh
- [ ] Device Security - D - Windows Package Manager
- [ ] Device Security - D - Windows Subsystem for Linux
- [ ] Device Security - U - Windows Sandbox
- [ ] Defender Antivirus - D - Additional Configuration
- [ ] Microsoft Edge - D - Security
- [ ] Microsoft Edge - U - Extensions
- [ ] Microsoft Office - D - Security
- [ ] Microsoft Office - U - Security
- [ ] Microsoft Store - D - Configuration
- [ ] Microsoft Store - U - Configuration
- [ ] Microsoft Accounts - D - Configuration
- [ ] Windows User Experience - D - Automatic Restart Sign-On
- [ ] Internet Explorer (Legacy) - D - Security

## Phase 3 - Can break things. Checkpoint first. (10)

Lockout and auth-breakage territory. Apply ONE at a time, sync, verify sign-in still works before the next.

- [ ] Device Security - D - Security Hardening
- [ ] Device Security - D - Local Security Policies  (OR the 24H2+ version, never both)
- [ ] Device Security - D - User Rights
- [ ] Device Security - D - Administrator Protection
- [ ] Device Security - U - Device Guard, Credential Guard and HVCI
- [ ] Device Security - D - Remote Desktop Services and RPC
- [ ] Network Security - D - Disable NTLM  (breaks legacy auth by design, audit first in prod)
- [ ] Credential Management - D - Passwordless
- [ ] Windows Hello for Business - D - Cloud Kerberos Trust  (needs hybrid + Cloud Kerberos setup, skip in a cloud-only test tenant)

## Not portal-importable (26)

BitLocker, ASR, LAPS, Firewall, Defender AV core (15 Endpoint Security), 4 compliance, 3 WUfB rings, 3 driver profiles, Endpoint Analytics. IntuneManagement tool or Graph. Test these as Phase 4 once the GUI phases are clean.

## Verify loop per policy

1. Import > assign to DEV-WIN-Test > sync device.
2. Portal: Devices > device > Device configuration = Succeeded.
3. Device: Event Viewer > DeviceManagement-Enterprise-Diagnostics-Provider > Admin for errors.
4. Anything broken: unassign, sync, confirm recovery, log it, move on.
