# Rebuilds catalog.json and embeds it into builder/index.html
$root = Split-Path $PSScriptRoot -Parent
$sections = @(
    @{ id = "oib-windows";            name = "OpenIntuneBaseline (Windows)" },
    @{ id = "security-baselines";     name = "Security Baselines" },
    @{ id = "compliance-policies";    name = "Compliance Policies" },
    @{ id = "configuration-profiles"; name = "Configuration Profiles" },
    @{ id = "apps-win32";             name = "Apps" },
    @{ id = "device-catalog";         name = "Device Catalog" }
)

$catalog = [ordered]@{
    generated = (Get-Date -Format "yyyy-MM-dd HH:mm")
    sections  = @()
}

foreach ($s in $sections) {
    $items = @()
    Get-ChildItem -Path (Join-Path $root $s.id) -Filter *.json | Sort-Object Name | ForEach-Object {
        $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
        if ($json._meta) {
            $meta = $json._meta
        }
        else {
            # No _meta block (OIB exports): derive it from the file
            $base = $_.BaseName
            $desc = if ($json.description) { $json.description } else { $json.'@odata.type' -replace '#microsoft.graph.', '' }
            $meta = [ordered]@{
                id          = ($base -replace '[^a-zA-Z0-9]+', '-').Trim('-').ToLower()
                name        = $base
                description = "$desc"
                type        = if ($json.'@odata.type') { $json.'@odata.type' -replace '#microsoft.graph.', '' } else { "settingsCatalog" }
            }
        }
        $items += [ordered]@{
            id          = $meta.id
            name        = $meta.name
            description = $meta.description
            type        = $meta.type
            file        = "$($s.id)/$($_.Name)"
            content     = $json
        }
    }
    $catalog.sections += [ordered]@{ id = $s.id; name = $s.name; items = $items }
}

$catalogJson = $catalog | ConvertTo-Json -Depth 60 -Compress
Set-Content -Path (Join-Path $root "catalog.json") -Value $catalogJson -Encoding UTF8

$htmlPath = Join-Path $root "builder\index.html"
$html = Get-Content $htmlPath -Raw
$html = $html -replace '(?s)/\*CATALOG-START\*/.*?/\*CATALOG-END\*/', "/*CATALOG-START*/$catalogJson/*CATALOG-END*/"
Set-Content -Path $htmlPath -Value $html -Encoding UTF8

Write-Host "catalog.json rebuilt and embedded into builder/index.html" -ForegroundColor Green
