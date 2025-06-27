# 画面サイズを取得（1920x1080固定なら下記2行を削除してWidth/Heightを直接書く）
Add-Type -AssemblyName System.Windows.Forms
$Screen = [System.Windows.Forms.Screen]::PrimaryScreen
$width = $Screen.Bounds.Width
$height = $Screen.Bounds.Height

# 真っ赤な画像を生成して保存
Add-Type -AssemblyName System.Drawing
$bitmap = New-Object System.Drawing.Bitmap $width, $height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([System.Drawing.Color]::Red)

# メッセージを描画
$font = New-Object System.Drawing.Font "Arial", 80, ([System.Drawing.FontStyle]::Bold)
$white = [System.Drawing.Brushes]::White
$mainText = "Ransomware!!"
$payText = "Pay 5 Bit Coin To xxxxxxxx"

# 文字サイズ計算と配置
$size1 = $graphics.MeasureString($mainText, $font)
$size2 = $graphics.MeasureString($payText, $font)
$graphics.DrawString($mainText, $font, $white, ($width - $size1.Width) / 2, $height / 3 - $size1.Height / 2)
$graphics.DrawString($payText, $font, $white, ($width - $size2.Width) / 2, $height * 2 / 3 - $size2.Height / 2)

# BMPで保存
$tmp = [System.IO.Path]::GetTempFileName() -replace ".tmp$", ".bmp"
$bitmap.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Bmp)

# 壁紙に設定
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll", SetLastError = true)]
  public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $tmp, 3)

# リソース解放
$graphics.Dispose()
$bitmap.Dispose()
