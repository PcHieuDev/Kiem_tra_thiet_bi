@echo off
:: Cài đặt giao thức vnpost:// để nút "Làm mới thông tin máy" hoạt động
:: Chạy file này một lần trên mỗi máy nhân viên

title VNPost - Cai dat giao thuc vnpost://

echo.
echo === Cai dat giao thuc vnpost:// cho VNPost Device Inventory ===
echo.

:: Chạy PowerShell script cùng thư mục
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_client_protocol.ps1"

if %errorlevel% equ 0 (
    echo.
    echo Cai dat thanh cong! Co the dong cua so nay.
) else (
    echo.
    echo Co loi xay ra. Vui long bao cao quan tri vien.
)

echo.
pause
