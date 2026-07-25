# Creates Intune policies from a bundle file
Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All"
$b = Get-Content C:\Source\bundle.json -Raw | ConvertFrom-Json
foreach ($i in $b.items) {
    $p = $i.content | Select-Object name, description, platforms, technologies, settings
    Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies" -Body ($p | ConvertTo-Json -Depth 100)
}
