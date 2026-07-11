# Exports all dynamic groups from a tenant to JSON
Connect-MgGraph -Scopes "Group.Read.All"
$groups = Get-MgGroup -Filter "groupTypes/any(c:c eq 'DynamicMembership')" -All |
    Select-Object displayName, description, membershipRule, membershipRuleProcessingState

$out = [ordered]@{
    _meta = [ordered]@{
        id          = "dc-dynamic-groups"
        name        = "Catalog - Dynamic Groups"
        description = "Dynamic group definitions exported $(Get-Date -Format yyyy-MM-dd), redeploy with Import-DynamicGroups.ps1"
        type        = "reference"
    }
    groups = $groups
}
$path = Join-Path (Split-Path $PSScriptRoot -Parent) "device-catalog\dynamic-groups.json"
$out | ConvertTo-Json -Depth 10 | Set-Content $path -Encoding UTF8
Write-Host "$($groups.Count) dynamic groups exported to $path" -ForegroundColor Green
