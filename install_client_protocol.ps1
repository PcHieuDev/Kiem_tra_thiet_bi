<#
.SYNOPSIS
    Cài đặt giao thức tùy chỉnh vnpost:// để trình duyệt có thể kích hoạt
    lay_thong_tin.bat trực tiếp từ nút "Làm mới thông tin máy" trên web.

.DESCRIPTION
    Script này đăng ký vnpost:// vào Windows Registry của người dùng hiện tại.
    Không cần quyền Administrator.

    Sau khi chạy, khi trình duyệt mở vnpost://collect, Windows sẽ tự động
    chạy lay_thong_tin.bat để thu thập thông tin máy và mở form đã điền sẵn.

.USAGE
    Chạy một lần trên mỗi máy nhân viên:
        .\install_client_protocol.ps1
    Hoặc chỉ định đường dẫn BAT file khác:
        .\install_client_protocol.ps1 -BatPath "D:\VNPost\lay_thong_tin.bat"
#>

param(
    [string]$BatPath = ""
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== Cai dat giao thuc vnpost:// cho VNPost Device Inventory ===" -ForegroundColor Cyan
Write-Host ""

# Xác định đường dẫn BAT file
if (-not $BatPath) {
    $BatPath = Join-Path $PSScriptRoot "lay_thong_tin.bat"
}

if (-not (Test-Path $BatPath)) {
    Write-Host "Loi: Khong tim thay file lay_thong_tin.bat tai:" -ForegroundColor Red
    Write-Host "  $BatPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Hay chay script nay tu cung thu muc chua lay_thong_tin.bat." -ForegroundColor Yellow
    exit 1
}

# Sao chép BAT file vào thư mục ổn định (tránh vấn đề khi di chuyển folder)
$installDir = Join-Path $env:LOCALAPPDATA "VNPost"
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

$installedBat = Join-Path $installDir "lay_thong_tin.bat"
Copy-Item -Path $BatPath -Destination $installedBat -Force
Write-Host "Da sao chep BAT file vao: $installedBat" -ForegroundColor Gray

# Lệnh chạy khi protocol được kích hoạt (ẩn cửa sổ cmd)
$command = "`"cmd.exe`" /c start /min `"`" `"$installedBat`""

# Đăng ký vào Windows Registry (HKCU – không cần quyền Admin)
$regBase = "HKCU:\SOFTWARE\Classes\vnpost"

Write-Host "Dang dang ky giao thuc vnpost:// vao Registry..." -ForegroundColor Gray

New-Item -Path $regBase -Force | Out-Null
Set-ItemProperty -Path $regBase -Name "(Default)"    -Value "URL:VNPost Device Inventory"
New-Item -Path "$regBase" -Name "URL Protocol"        -Force | Out-Null
New-Item -Path "$regBase\DefaultIcon"                 -Force | Out-Null
Set-ItemProperty -Path "$regBase\DefaultIcon" -Name "(Default)" -Value "shell32.dll,13"
New-Item -Path "$regBase\shell"               -Force | Out-Null
New-Item -Path "$regBase\shell\open"          -Force | Out-Null
New-Item -Path "$regBase\shell\open\command"  -Force | Out-Null
Set-ItemProperty -Path "$regBase\shell\open\command" -Name "(Default)" -Value $command

Write-Host ""
Write-Host "=== CAI DAT THANH CONG ===" -ForegroundColor Green
Write-Host ""
Write-Host "Giao thuc vnpost:// da duoc dang ky." -ForegroundColor White
Write-Host "Khi nhan nut 'Lam moi thong tin may' tren trang web," -ForegroundColor White
Write-Host "trinh duyet se tu dong lay thong tin may tinh nay." -ForegroundColor White
Write-Host ""
Write-Host "URL ung dung: http://10.42.40.20:8789/" -ForegroundColor Cyan
Write-Host "Kiem tra thanh cong!" -ForegroundColor Green
Write-Host ""
