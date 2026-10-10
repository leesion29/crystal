param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

# Normalize opaque grayscale PNGs to the source palette required by rgbgfx
# --colors dmg. Pixel positions and dimensions are preserved.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$resolvedPath = (Resolve-Path -LiteralPath $Path).Path
$bitmap = [System.Drawing.Bitmap]::new($resolvedPath)
$stream = [System.IO.MemoryStream]::new()
$levels = @(0, 85, 170, 255)
$changed = 0
try {
    # Check the complete image before changing any pixels.
    for ($y = 0; $y -lt $bitmap.Height; $y++) {
        for ($x = 0; $x -lt $bitmap.Width; $x++) {
            $color = $bitmap.GetPixel($x, $y)
            if ($color.A -ne 255 -or $color.R -ne $color.G -or $color.G -ne $color.B) {
                throw "Non-opaque or non-gray pixel at ($x, $y); conversion refused."
            }
        }
    }
    for ($y = 0; $y -lt $bitmap.Height; $y++) {
        for ($x = 0; $x -lt $bitmap.Width; $x++) {
            $color = $bitmap.GetPixel($x, $y)
            $gray = $color.R
            $nearest = $levels[0]
            $distance = [Math]::Abs($gray - $nearest)
            foreach ($level in $levels) {
                $candidateDistance = [Math]::Abs($gray - $level)
                if ($candidateDistance -lt $distance) {
                    $nearest = $level
                    $distance = $candidateDistance
                }
            }
            if ($gray -ne $nearest) {
                $bitmap.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $nearest, $nearest, $nearest))
                $changed++
            }
        }
    }
    $bitmap.Save($stream, [System.Drawing.Imaging.ImageFormat]::Png)
    $bytes = $stream.ToArray()
} finally {
    $bitmap.Dispose()
    $stream.Dispose()
}
if ($changed -gt 0) {
    [System.IO.File]::WriteAllBytes($resolvedPath, $bytes)
}
Write-Output "Normalized $changed pixels: $resolvedPath"
