# Rebrand portal berita menjadi Gema Jabar
# Menjaga encoding UTF-8, backup data penting, dan membuat laporan verifikasi

$ErrorActionPreference = 'Stop'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$WorkspaceRoot = $PSScriptRoot
$Timestamp = Get-Date -Format 'yyyyMMddHHmmss'
$ReportPath = Join-Path $WorkspaceRoot 'rebrand-gema-jabar-report.json'

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$ChangedFiles = New-Object 'System.Collections.Generic.HashSet[string]'
$Counts = [ordered]@{
    main_pages    = 0
    article_pages = 0
    css           = 0
    package       = 0
    docs          = 0
}

function Save-Utf8 {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Content
    )

    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Register-Change {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Category
    )

    if ($ChangedFiles.Add($Path)) {
        $Counts[$Category]++
    }
}

function Normalize-Text {
    param([string]$Content)

    if ($null -eq $Content) { return $Content }

    $normalized = $Content
    $normalized = $normalized.Replace([char]0x201C, '"')
    $normalized = $normalized.Replace([char]0x201D, '"')
    $normalized = $normalized.Replace([char]0x2018, "'")
    $normalized = $normalized.Replace([char]0x2019, "'")
    $normalized = $normalized.Replace([char]0x2013, '-')
    $normalized = $normalized.Replace([char]0x2014, '-')
    $normalized = $normalized.Replace([char]0x00A0, ' ')
    $normalized = $normalized.Replace([char]0xFFFD, ' ')

    return $normalized
}

$logoMarkup = '<span style="font-weight: bold; color: #9A3412; font-size: 24px; letter-spacing: -0.5px;">GEMA<span style="color: #7F2B2B; font-weight: normal; font-size: 18px; margin-left: 2px;">JABAR</span></span>'

$legacyIndonesiaDisplay = 'Indonesia Daily'
$legacyIndonesiaCompact = 'indonesiadaily'
$legacyIndonesiaCamel = 'IndonesiaDaily'
$legacyLogoFile = 'logo.png'

$textReplacements = @(
    @{ Old = 'https://twitter.com/WartaJanten'; New = 'https://twitter.com/gemajabar' },
    @{ Old = 'https://twitter.com/wartajanten'; New = 'https://twitter.com/gemajabar' },
    @{ Old = 'https://twitter.com/indonesiadaily'; New = 'https://twitter.com/gemajabar' },
    @{ Old = 'https://facebook.com/WartaJanten'; New = 'https://facebook.com/gemajabar' },
    @{ Old = 'https://facebook.com/wartajanten'; New = 'https://facebook.com/gemajabar' },
    @{ Old = 'https://facebook.com/indonesiadaily'; New = 'https://facebook.com/gemajabar' },
    @{ Old = 'https://instagram.com/WartaJanten'; New = 'https://instagram.com/gemajabar' },
    @{ Old = 'https://instagram.com/wartajanten'; New = 'https://instagram.com/gemajabar' },
    @{ Old = 'https://instagram.com/indonesiadaily'; New = 'https://instagram.com/gemajabar' },
    @{ Old = 'https://youtube.com/@WartaJanten'; New = 'https://youtube.com/@gemajabar' },
    @{ Old = 'https://youtube.com/@wartajanten'; New = 'https://youtube.com/@gemajabar' },
    @{ Old = 'https://youtube.com/@indonesiadaily'; New = 'https://youtube.com/@gemajabar' },
    @{ Old = 'https://linkedin.com/company/WartaJanten'; New = 'https://linkedin.com/company/gemajabar' },
    @{ Old = 'https://linkedin.com/company/wartajanten'; New = 'https://linkedin.com/company/gemajabar' },
    @{ Old = 'https://linkedin.com/company/indonesiadaily'; New = 'https://linkedin.com/company/gemajabar' },
    @{ Old = 'WartaJanten33@gmail.com'; New = 'gemajabar@gmail.com' },
    @{ Old = 'wartajanten33@gmail.com'; New = 'gemajabar@gmail.com' },
    @{ Old = 'WartaJanten@gmail.com'; New = 'gemajabar@gmail.com' },
    @{ Old = 'wartajanten@gmail.com'; New = 'gemajabar@gmail.com' },
    @{ Old = 'indonesiadaily@gmail.com'; New = 'gemajabar@gmail.com' },
    @{ Old = 'to=WartaJanten33@gmail.com'; New = 'to=gemajabar@gmail.com' },
    @{ Old = 'to=wartajanten33@gmail.com'; New = 'to=gemajabar@gmail.com' },
    @{ Old = 'to=wartajanten@gmail.com'; New = 'to=gemajabar@gmail.com' },
    @{ Old = 'to=indonesiadaily@gmail.com'; New = 'to=gemajabar@gmail.com' },
    @{ Old = 'Warta Janten'; New = 'Gema Jabar' },
    @{ Old = 'WartaJanten'; New = 'Gema Jabar' },
    @{ Old = 'wartajanten'; New = 'gemajabar' },
    @{ Old = 'Indonesia Daily'; New = 'Gema Jabar' },
    @{ Old = 'IndonesiaDaily'; New = 'Gema Jabar' },
    @{ Old = 'indonesiadaily'; New = 'gemajabar' },
    @{ Old = 'BizNews'; New = 'Gema Jabar' }
)

$colorReplacements = @(
    @{ Old = '#065F46'; New = '#9A3412' },
    @{ Old = '#022C22'; New = '#9A3412' },
    @{ Old = '#1E3A5F'; New = '#7F2B2B' },
    @{ Old = '#31404B'; New = '#7F2B2B' },
    @{ Old = '#FFCC00'; New = '#9A3412' },
    @{ Old = '#ffcc00'; New = '#9A3412' },
    @{ Old = '#fc0'; New = '#9A3412' },
    @{ Old = '#1E2024'; New = '#9A3412' },
    @{ Old = '#1e2024'; New = '#9A3412' },
    @{ Old = '#cca300'; New = '#7F2B2B' },
    @{ Old = '#b38f00'; New = '#7F2B2B' },
    @{ Old = '#bf9900'; New = '#7F2B2B' },
    @{ Old = '#d39e00'; New = '#7F2B2B' },
    @{ Old = '#ba8b00'; New = '#7F2B2B' },
    @{ Old = 'rgba(255,204,0,0.5)'; New = 'rgba(154,52,18,0.35)' },
    @{ Old = 'rgba(222,179,6,0.5)'; New = 'rgba(154,52,18,0.35)' },
    @{ Old = 'rgba(49,64,75,0.5)'; New = 'rgba(127,43,43,0.35)' },
    @{ Old = 'rgba(30,32,36,0.5)'; New = 'rgba(154,52,18,0.35)' }
)

# Backup data penting
$articlesJson = Join-Path $WorkspaceRoot 'articles.json'
$articlesBackup = Join-Path $WorkspaceRoot 'articles.json.bak'
if (Test-Path $articlesJson) {
    Copy-Item -Path $articlesJson -Destination $articlesBackup -Force
}

# Main pages + article pages + template HTML
Get-ChildItem -Path $WorkspaceRoot -Recurse -Include *.html -File |
    Where-Object {
        $_.FullName -notmatch '\\.bak(\\.|$)' -and
        $_.FullName -notmatch '\\node_modules\\'
    } |
    ForEach-Object {
        $file = $_.FullName
        $original = [System.IO.File]::ReadAllText($file)
        $content = Normalize-Text $original

        foreach ($pair in $textReplacements) {
            $content = $content.Replace($pair.Old, $pair.New)
        }

        foreach ($pair in $colorReplacements) {
            $content = $content.Replace($pair.Old, $pair.New)
        }

        $content = $content.Replace('<span style="font-weight: bold; color: #065F46; font-size: 24px; letter-spacing: -0.5px;">WARTA<span style="color: #1E3A5F; font-weight: normal; font-size: 18px; margin-left: 2px;">JANTEN</span></span>', $logoMarkup)
        $content = $content.Replace('<span style="font-weight: bold; color: #9A3412; font-size: 24px; letter-spacing: -0.5px;">WARTA<span style="color: #7F2B2B; font-weight: normal; font-size: 18px; margin-left: 2px;">JANTEN</span></span>', $logoMarkup)
        $content = $content.Replace('<span style="font-weight: bold; color: #065F46; font-size: 24px; letter-spacing: -0.5px;">GEMA<span style="color: #1E3A5F; font-weight: normal; font-size: 18px; margin-left: 2px;">JABAR</span></span>', $logoMarkup)

        $content = [regex]::Replace($content, '<img[^>]*src="\.\./img/logo\.png"[^>]*>', $logoMarkup, 'IgnoreCase')
        $content = [regex]::Replace($content, '<img[^>]*src="img/logo\.png"[^>]*>', $logoMarkup, 'IgnoreCase')
        $content = $content.Replace('alt="Gema Jabar"', 'alt="GemaJabar"')
        $content = $content.Replace('alt="Gema Jabar Logo"', 'alt="GemaJabar"')
        $content = $content -replace ' - GemaJabar', ' - Gema Jabar'

        if ($content -ne $original) {
            Save-Utf8 -Path $file -Content $content
            if ($file -match '\\article\\') {
                Register-Change -Path $file -Category 'article_pages'
            }
            else {
                Register-Change -Path $file -Category 'main_pages'
            }
        }
    }

# CSS global theme
Get-ChildItem -Path $WorkspaceRoot -Recurse -Include *.css -File |
    Where-Object { $_.FullName -notmatch '\\node_modules\\' } |
    ForEach-Object {
        $file = $_.FullName
        $original = [System.IO.File]::ReadAllText($file)
        $content = Normalize-Text $original

        foreach ($pair in $colorReplacements) {
            $content = $content.Replace($pair.Old, $pair.New)
        }

        $content = $content -replace '(--primary:\s*)#9A3412', '$1#9A3412'
        $content = $content -replace '(--secondary:\s*)#7F2B2B', '$1#7F2B2B'
        $content = $content -replace '(--dark:\s*)#9A3412', '$1#9A3412'

        if ($content -ne $original) {
            Save-Utf8 -Path $file -Content $content
            Register-Change -Path $file -Category 'css'
        }
    }

# Package metadata
$packageFiles = @(
    (Join-Path $WorkspaceRoot 'package.json'),
    (Join-Path $WorkspaceRoot 'package-lock.json'),
    (Join-Path $WorkspaceRoot 'tools\package.json'),
    (Join-Path $WorkspaceRoot 'tools\sites-config.json')
)

foreach ($file in $packageFiles) {
    if (-not (Test-Path $file)) { continue }

    $original = [System.IO.File]::ReadAllText($file)
    $content = Normalize-Text $original

    $content = $content.Replace('"name": "wartajanten"', '"name": "gemajabar"')
    $content = $content.Replace('"name": "indonesiadaily"', '"name": "gemajabar"')
    $content = $content.Replace('"name": "wartajanten-article-generator"', '"name": "gemajabar-article-generator"')
    $content = $content.Replace('"name": "indonesiadaily-article-generator"', '"name": "gemajabar-article-generator"')
    $content = $content.Replace('"siteName": "Gema Jabar"', '"siteName": "Gema Jabar"')
    $content = $content.Replace('"email": "gemajabar@gmail.com"', '"email": "gemajabar@gmail.com"')
    $content = $content.Replace('"socialHandle": "gemajabar"', '"socialHandle": "gemajabar"')

    foreach ($pair in $textReplacements) {
        $content = $content.Replace($pair.Old, $pair.New)
    }
    foreach ($pair in $colorReplacements) {
        $content = $content.Replace($pair.Old, $pair.New)
    }

    if ($content -ne $original) {
        Save-Utf8 -Path $file -Content $content
        if ($file -match 'package(-lock)?\.json$' -or $file -match 'tools\\package\.json$') {
            Register-Change -Path $file -Category 'package'
        } else {
            Register-Change -Path $file -Category 'docs'
        }
    }
}

# Docs / config / support files
Get-ChildItem -Path $WorkspaceRoot -Recurse -Include *.md,*.txt,*.toml,*.ps1,*.js -File |
    Where-Object {
        $_.FullName -notmatch '\\.bak(\\.|$)' -and
        $_.FullName -notmatch '\\node_modules\\'
    } |
    ForEach-Object {
        $file = $_.FullName
        $original = [System.IO.File]::ReadAllText($file)
        $content = Normalize-Text $original

        foreach ($pair in $textReplacements) {
            $content = $content.Replace($pair.Old, $pair.New)
        }
        foreach ($pair in $colorReplacements) {
            $content = $content.Replace($pair.Old, $pair.New)
        }

        if ($file -match '\.js$') {
            $content = $content.Replace("!src.includes('logo.png')", "!src.includes('favicon.ico')")
            $content = $content.Replace("return 'img/logo.png';", "return 'img/news-700x435-1.jpg';")
        }
        else {
            $content = $content.Replace('logo.png', 'text logo Gema Jabar')
        }

        if ($content -ne $original) {
            Save-Utf8 -Path $file -Content $content
            Register-Change -Path $file -Category 'docs'
        }
    }

# Verifikasi akhir
$verificationPatterns = @(
    'Indonesia Daily',
    'indonesiadaily',
    'IndonesiaDaily',
    'Warta Janten',
    'WartaJanten',
    'wartajanten',
    'logo.png'
)

$remaining = @()
foreach ($pattern in $verificationPatterns) {
    $patternMatches = Get-ChildItem -Path $WorkspaceRoot -Recurse -Include *.html,*.css,*.md,*.txt,*.toml,*.json,*.js,*.ps1 -File |
        Where-Object {
            $_.FullName -notmatch '\\.bak(\\.|$)' -and
            $_.FullName -notmatch '\\node_modules\\'
        } |
        Select-String -Pattern $pattern -SimpleMatch -ErrorAction SilentlyContinue

    foreach ($match in $patternMatches) {
        $remaining += [ordered]@{
            pattern = $pattern
            path    = $match.Path
            line    = $match.LineNumber
        }
    }
}

$themeChecks = [ordered]@{
    '#9A3412' = ((Get-ChildItem -Path $WorkspaceRoot -Recurse -Include *.css,*.html -File | Select-String -Pattern '#9A3412' -SimpleMatch -ErrorAction SilentlyContinue).Count -gt 0)
    '#7F2B2B' = ((Get-ChildItem -Path $WorkspaceRoot -Recurse -Include *.css,*.html -File | Select-String -Pattern '#7F2B2B' -SimpleMatch -ErrorAction SilentlyContinue).Count -gt 0)
}

$report = [ordered]@{
    portal = 'Gema Jabar'
    backup = [ordered]@{
        source = $articlesJson
        destination = $articlesBackup
        exists = (Test-Path $articlesBackup)
    }
    counts = $Counts
    total_changed = $ChangedFiles.Count
    verification = [ordered]@{
        remaining_references = $remaining
        required_absent = [ordered]@{
            legacy_display_name_absent = (-not ($remaining.pattern -contains $legacyIndonesiaDisplay))
            legacy_handle_absent = (-not ($remaining.pattern -contains $legacyIndonesiaCompact))
            legacy_camel_name_absent = (-not ($remaining.pattern -contains $legacyIndonesiaCamel))
            legacy_logo_reference_absent = (-not ($remaining.pattern -contains $legacyLogoFile))
        }
        theme_colors_present = $themeChecks
    }
    executed_steps = @(
        'Get-ChildItem -Recurse -Include *.html | ForEach-Object {...}',
        'UTF-8 normalization applied to updated files',
        'articles.json backed up to articles.json.bak'
    )
    message = 'Rebrand Gema Jabar selesai ✅'
    generated_at = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
}

Save-Utf8 -Path $ReportPath -Content ($report | ConvertTo-Json -Depth 8)
$report | ConvertTo-Json -Depth 8