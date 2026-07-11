# Guppy's Intune Deployment Kit

Reusable Intune configuration library for deploying standardized baselines, compliance policies, configuration profiles, and Win32 apps across multiple tenants.

## How it works

1. Every policy lives as a JSON file in its section folder. JSONs are the source of truth.
2. `builder/index.html` is the config picker. Open it, check what you want, click Generate. You get one combined bundle JSON.
3. Deploy manually for now (see below). PowerShell + Graph API deployment script is Phase 2.

## Repo structure

```
├── builder/
│   └── index.html              # Checkbox picker, generates bundle JSON
├── oib-windows/                # OpenIntuneBaseline Windows policies (73, real Graph exports)
├── security-baselines/         # Custom hardening not covered by OIB (removable storage)
├── compliance-policies/        # Windows compliance policy JSONs
├── configuration-profiles/     # OneDrive KFM, Edge, Wi-Fi/VPN templates, restrictions
├── apps-win32/                 # App definitions (M365, Chrome, remote support)
├── device-catalog/             # Hardware standards, Autopilot profiles, naming
├── catalog.json                # Master index, consumed by the builder
└── tools/
    └── Build-Catalog.ps1       # Regenerates catalog.json + embeds it in index.html
```

## OpenIntuneBaseline

`oib-windows/` is the Windows baseline from [SkipToTheEndpoint/OpenIntuneBaseline](https://github.com/SkipToTheEndpoint/OpenIntuneBaseline) (GPL-3.0). Full credit to SkipToTheEndpoint. These are real Graph exports: settings catalog, compliance, WUfB rings (Pilot/UAT/Production), driver update profiles.

Import them with the [IntuneManagement tool](https://github.com/Micke-K/IntuneManagement) (point it at the folder, bulk import). That is the format they ship in. Check upstream for new versions before deploying; policy files carry their version in the filename.

OIB files have no `_meta` block on purpose. They stay verbatim so you can diff against upstream. `Build-Catalog.ps1` auto-derives catalog metadata from the filename.

### Portal (web GUI) import

The portal can only import Settings Catalog JSONs: **Devices > Configuration > Create > Import policy**. `native-import/` holds cleaned, portal-ready copies of the 47 OIB policies that qualify (raw Graph exports get rejected). Regenerate them after an OIB update with `tools/Convert-ToNativeImport.ps1`.

Not portal-importable, use the IntuneManagement tool or Graph: 15 Endpoint Security policies (BitLocker, ASR, LAPS, Firewall, AV), 4 compliance policies, 3 WUfB rings, 3 driver update profiles, Endpoint Analytics.

## Adding or editing a config

1. Drop your JSON into the right section folder.
2. Add a `_meta` block at the top of the file (see any existing file for the shape):

```json
"_meta": {
  "id": "unique-kebab-id",
  "name": "Display Name",
  "description": "One-liner about what it does",
  "type": "settingsCatalog | compliance | win32app | autopilot | reference"
}
```

3. Run `tools/Build-Catalog.ps1`. It rescans the folders, rewrites `catalog.json`, and re-embeds everything into `builder/index.html`.
4. Commit and push.

## Manual import (current workflow)

| Type | How to import |
|------|---------------|
| Settings catalog (baselines, most config profiles) | Intune portal > Devices > Configuration > Create > Import policy. Feed it the JSON. |
| Compliance policies | No portal JSON import. Recreate by hand using the JSON as the spec, or wait for Phase 2 Graph script. |
| Win32 apps | JSONs define install/uninstall commands and detection rules. Package the installer with the Win32 Content Prep Tool, then key in the values from the JSON. |
| Autopilot profiles | Recreate by hand from the JSON, or Phase 2. |

## Phase 2 (planned)

`Deploy-Bundle.ps1`: reads a generated bundle, authenticates to any tenant with Microsoft Graph PowerShell, and creates everything via `deviceManagement` endpoints. The builder already prints the future command for each bundle.

## Cert relevance

This repo maps directly to MD-102 exam objectives: compliance policies, configuration profiles, app deployment, and Autopilot are all core exam domains. The Phase 2 Graph work overlaps with AZ-104 identity and governance.

## GitHub Pages

Settings > Pages > deploy from branch, root. The builder then lives at `https://<user>.github.io/<repo>/builder/`. It works double-clicked locally too since the catalog is embedded.
