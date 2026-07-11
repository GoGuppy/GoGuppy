# Converts OIB settings catalog exports to portal-importable JSONs
$root = Split-Path $PSScriptRoot -Parent
$out = Join-Path $root "native-import"
New-Item -ItemType Directory -Path $out -Force | Out-Null

function Clean-Node($node) {
    if ($node -is [System.Collections.IEnumerable] -and $node -isnot [string]) {
        return @($node | ForEach-Object { Clean-Node $_ })
    }
    if ($node -is [PSCustomObject]) {
        $o = [ordered]@{}
        foreach ($p in $node.PSObject.Properties) {
            if ($p.Name -like "*@odata.*" -and $p.Name -ne "@odata.type") { continue }
            if ($p.Name -in "settingInstanceTemplateReference","settingValueTemplateReference" -and $null -eq $p.Value) { continue }
            if ($p.Name -eq "id") { continue }
            $o[$p.Name] = Clean-Node $p.Value
        }
        return [PSCustomObject]$o
    }
    return $node
}

$done = 0
Get-ChildItem (Join-Path $root "oib-windows") -Filter *.json | ForEach-Object {
    $j = Get-Content $_.FullName -Raw | ConvertFrom-Json
    if ($j.'@odata.type' -notlike "*deviceManagementConfigurationPolicy*") { return }
    if ($j.templateReference.templateId) { return }   # Endpoint Security: tool/Graph only
    [ordered]@{
        name            = $j.name
        description     = $j.description
        platforms       = $j.platforms
        technologies    = $j.technologies
        roleScopeTagIds = @("0")
        settings        = Clean-Node $j.settings
    } | ConvertTo-Json -Depth 60 | Set-Content (Join-Path $out $_.Name) -Encoding UTF8
    $done++
}
Write-Host "$done portal-ready files in native-import\" -ForegroundColor Green
