# Win32 App Definitions

Each JSON is the spec sheet for one app: install command, uninstall command, detection rule, requirements, return codes.

Workflow:

1. Download the installer from `sourceUrl`.
2. Wrap it: `IntuneWinAppUtil.exe -c .\source -s installer.msi -o .\output`
3. Create the Win32 app in Intune and copy the values from the JSON.
4. For MSI product codes marked `{PRODUCT-CODE}`, grab the real code after downloading:

Get MSI product code.

```powershell
$msi = "C:\path\to\installer.msi"
$wi = New-Object -ComObject WindowsInstaller.Installer
$db = $wi.GetType().InvokeMember("OpenDatabase","InvokeMethod",$null,$wi,@($msi,0))
$view = $db.GetType().InvokeMember("OpenView","InvokeMethod",$null,$db,@("SELECT Value FROM Property WHERE Property='ProductCode'"))
$view.GetType().InvokeMember("Execute","InvokeMethod",$null,$view,$null)
$rec = $view.GetType().InvokeMember("Fetch","InvokeMethod",$null,$view,$null)
$rec.GetType().InvokeMember("StringData","GetProperty",$null,$rec,1)
```

Phase 2: the deploy script will create these via `New-MgDeviceAppManagementMobileApp`.
