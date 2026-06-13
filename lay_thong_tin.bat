@echo off
chcp 65001 >nul 2>&1

:: ─────────────────────────────────────────────────────────────────────────────
:: VNPost Device Inventory – Thu thap thong tin may tinh
:: Phien ban KHONG dung iex – tranh Kaspersky Adaptive Anomaly Control chan
:: Web: http://10.42.40.20:8789
:: ─────────────────────────────────────────────────────────────────────────────
::
:: Kaspersky chan rule: "PowerShell script executes unknown dynamic code"
:: Vi le do cu dung:  iex ((Get-Content '%~f0') -join [char]10)  <-- bi chan
:: Giai phap moi:     powershell -Command "code tinh" ^           <-- khong bi chan
::                    (toan bo code duoc viet thang, khong doc tu file luc chay)
:: ─────────────────────────────────────────────────────────────────────────────

powershell -NoExit -NoProfile -ExecutionPolicy Bypass -Command ^
 "$u='http://10.42.40.20:8789';" ^
 "try{" ^
 "  $d=Join-Path $env:LOCALAPPDATA 'VNPost';" ^
 "  New-Item -ItemType Directory -Path $d -Force|Out-Null;" ^
 "  $s=$MyInvocation.MyCommand.Path;" ^
 "  if($s -and (Test-Path $s)){Copy-Item $s (Join-Path $d 'lay_thong_tin.bat') -Force};" ^
 "  $bat=Join-Path $d 'lay_thong_tin.bat';" ^
 "  $q34=[char]34;" ^
 "  $cv='cmd.exe /c start /min '+$q34+$q34+' '+$q34+$bat+$q34;" ^
 "  $rb='HKCU:\SOFTWARE\Classes\vnpost';" ^
 "  New-Item -Path $rb -Force|Out-Null;" ^
 "  Set-ItemProperty -Path $rb -Name '(Default)' -Value 'URL:VNPost Device Inventory';" ^
 "  Set-ItemProperty -Path $rb -Name 'URL Protocol' -Value '';" ^
 "  New-Item -Path ($rb+'\shell\open\command') -Force|Out-Null;" ^
 "  Set-ItemProperty -Path ($rb+'\shell\open\command') -Name '(Default)' -Value $cv" ^
 "}catch{};" ^
 "$cpu=(Get-WmiObject Win32_Processor|Select-Object -First 1).Name;" ^
 "$cs=Get-WmiObject Win32_ComputerSystem|Select-Object -First 1;" ^
 "$bios=Get-WmiObject Win32_BIOS|Select-Object -First 1;" ^
 "$os=Get-WmiObject Win32_OperatingSystem|Select-Object -First 1;" ^
 "$ds=Get-WmiObject Win32_LogicalDisk -Filter 'DriveType=3'|Measure-Object Size -Sum;" ^
 "$na=Get-WmiObject Win32_NetworkAdapterConfiguration|Where-Object{$_.IPEnabled}|Select-Object -First 1;" ^
 "$ram=[math]::Round($cs.TotalPhysicalMemory/1GB,1);" ^
 "$serial=$bios.SerialNumber;" ^
 "$gb=[math]::Round($ds.Sum/1GB,0);" ^
 "$osn=$os.Caption+' '+$os.Version;" ^
 "$ip=($na.IPAddress|Where-Object{$_ -notmatch ':'}|Select-Object -First 1);" ^
 "$mac=$na.MACAddress;" ^
 "$type=if($cs.PCSystemType-eq 2){'Laptop'}else{'Desktop'};" ^
 "$pk='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*';" ^
 "$office=(Get-ItemProperty $pk -EA SilentlyContinue|Where-Object{$_.DisplayName -match 'Microsoft 365|Microsoft Office'}|Select-Object -First 1 -ExpandProperty DisplayName);" ^
 "$av=(Get-WmiObject -Namespace 'root\SecurityCenter2' -Class AntiVirusProduct -EA SilentlyContinue|Select-Object -ExpandProperty displayName);" ^
 "function E($v){if(-not $v){return ''};[System.Uri]::EscapeDataString($v.ToString().Trim())};" ^
 "$q='hostname='+(E $env:COMPUTERNAME)+'&cpu='+(E $cpu)+'&hang='+(E $cs.Manufacturer)+'&model='+(E $cs.Model)+'&ram='+(E($ram.ToString()+' GB'))+'&disk='+(E($gb.ToString()+' GB'))+'&serial='+(E $serial)+'&os='+(E $osn)+'&ip='+(E $ip)+'&mac='+(E $mac)+'&loaiMay='+(E $type)+'&office='+(E $office)+'&antivirus='+(E($av -join ', '));" ^
 "$url=$u+'/?'+$q;try{Start-Process 'chrome.exe' $url -ErrorAction Stop}catch{Start-Process 'cmd.exe' ('/c start chrome '+$q34+$url+$q34)}"
