# Reduce el peso de las imágenes de assets/src/ y escribe versiones
# optimizadas en assets/ (que son las que usa la app).
#   - fondo    -> JPEG de calidad (sin transparencia)
#   - line art -> PNG reescalado (conserva transparencia)
# Uso:  powershell -ExecutionPolicy Bypass -File tools\optimize-assets.ps1

Add-Type -AssemblyName System.Drawing

$root   = Split-Path -Parent $PSScriptRoot
$srcDir = Join-Path $root "assets\src"
$outDir = Join-Path $root "assets"

function Resize-Bitmap {
    param([string]$inPath, [int]$maxW)
    $img = [System.Drawing.Image]::FromFile($inPath)
    try {
        $scale = [Math]::Min(1.0, $maxW / [double]$img.Width)
        $w = [int][Math]::Round($img.Width * $scale)
        $h = [int][Math]::Round($img.Height * $scale)
        $bmp = New-Object System.Drawing.Bitmap($w, $h)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        $g.DrawImage($img, 0, 0, $w, $h)
        $g.Dispose()
    } finally {
        $img.Dispose()
    }
    return $bmp
}

function Save-Jpeg {
    param([System.Drawing.Bitmap]$bmp, [string]$path, [int]$quality)
    $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $p = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $p.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)
    $flat = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)
    $g = [System.Drawing.Graphics]::FromImage($flat)
    $g.Clear([System.Drawing.Color]::White)
    $g.DrawImage($bmp, 0, 0, $bmp.Width, $bmp.Height)
    $g.Dispose()
    $flat.Save($path, $enc, $p)
    $flat.Dispose()
}

$jobs = @(
    @{ in = "fondo.png";    out = "fondo.jpg";    w = 1200; kind = "jpeg"; q = 82 },
    @{ in = "frasco.png";   out = "frasco.png";   w = 520;  kind = "png" },
    @{ in = "matraz.png";   out = "matraz.png";   w = 520;  kind = "png" },
    @{ in = "balanza.png";  out = "balanza.png";  w = 560;  kind = "png" },
    @{ in = "pizarron.png"; out = "pizarron.png"; w = 1000; kind = "png" }
)

foreach ($j in $jobs) {
    $inPath  = Join-Path $srcDir $j.in
    $outPath = Join-Path $outDir $j.out
    $bmp = Resize-Bitmap -inPath $inPath -maxW $j.w
    $wpx = $bmp.Width
    if ($j.kind -eq "jpeg") {
        Save-Jpeg -bmp $bmp -path $outPath -quality $j.q
    } else {
        $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    $bmp.Dispose()
    $kb = [Math]::Round((Get-Item $outPath).Length / 1KB)
    Write-Host ("{0,-14} -> {1,-14} {2,6} KB  ({3}px ancho)" -f $j.in, $j.out, $kb, $wpx)
}
