Add-Type -AssemblyName System.Drawing

# Raíz del repo (este script vive en tools/)
$outDir = Split-Path -Parent $PSScriptRoot
$iconsDir = Join-Path $outDir "icons"
if (-not (Test-Path $iconsDir)) { New-Item -ItemType Directory -Path $iconsDir | Out-Null }

function New-Icon {
    param([int]$size, [string]$path, [bool]$pad = $false)

    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Fondo ambar (mismo acento que la app)
    $bg = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml('#9c5a1c'))
    $g.FillRectangle($bg, 0, 0, $size, $size)

    # Marco de dibujo: 40 unidades de diseno; con pad, dejamos zona segura del 12%
    $inset = if ($pad) { $size * 0.12 } else { 0 }
    $span = $size - 2 * $inset
    $s = $span / 40.0
    $ox = $inset
    $oy = $inset
    function X($u) { return $ox + $u * $s }
    function Y($u) { return $oy + $u * $s }

    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::White, ($s * 2.2))
    $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)

    # Viga vertical
    $g.DrawLine($pen, (X 20), (Y 7), (X 20), (Y 33))
    # Viga superior
    $g.DrawLine($pen, (X 6.5), (Y 12), (X 33.5), (Y 12))
    # Base
    $g.DrawLine($pen, (X 12), (Y 33), (X 28), (Y 33))
    # Perilla superior
    $r = 2.7 * $s
    $g.FillEllipse($white, (X 20) - $r, (Y 8) - $r, 2 * $r, 2 * $r)
    # Platos: colgadores + arco tipo cuenco en cada extremo
    $pr = 4.6 * $s
    foreach ($cx in 6.5, 33.5) {
        $g.DrawLine($pen, (X $cx), (Y 12), (X $cx), (Y 16.5))
        $rect = New-Object System.Drawing.RectangleF (([single]((X $cx) - $pr)), ([single]((Y 16.5) - $pr)), ([single](2 * $pr)), ([single](2 * $pr)))
        $g.DrawArc($pen, $rect, 20, 140)
    }

    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "escrito: $path"
}

New-Icon 512 (Join-Path $iconsDir "icon-512.png") $false
New-Icon 192 (Join-Path $iconsDir "icon-192.png") $false
New-Icon 512 (Join-Path $iconsDir "icon-maskable-512.png") $true
New-Icon 180 (Join-Path $outDir  "apple-touch-icon.png") $false
