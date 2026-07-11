# Recreates dynamic groups in a tenant from JSON
Connect-MgGraph -Scopes "Group.ReadWrite.All"
$path = Join-Path (Split-Path $PSScriptRoot -Parent) "device-catalog\dynamic-groups.json"
$json = Get-Content $path -Raw | ConvertFrom-Json

foreach ($g in $json.groups) {
    if (Get-MgGroup -Filter "displayName eq '$($g.displayName)'") {
        Write-Warning "$($g.displayName) already exists, skipping"
        continue
    }
    New-MgGroup -DisplayName $g.displayName `
        -Description "$($g.description)" `
        -MailEnabled:$false `
        -MailNickname (($g.displayName -replace '[^a-zA-Z0-9]', '').ToLower()) `
        -SecurityEnabled `
        -GroupTypes @("DynamicMembership") `
        -MembershipRule $g.membershipRule `
        -MembershipRuleProcessingState "On" | Out-Null
    Write-Host "Created: $($g.displayName)" -ForegroundColor Green
}
