# === PONGPONGER TEMİZLİK SCRIPTİ ===

Write-Host ">>> Başlangıç kayıtları temizleniyor..."

# HKCU Run'daki explorer.exe girişini sil
try {
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "user" -ErrorAction SilentlyContinue
    Write-Host "HKCU Run içindeki 'user' girdisi silindi (varsa)."
} catch { }

# HKLM Run'da varsa onu da temizle
try {
    Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "user" -ErrorAction SilentlyContinue
    Write-Host "HKLM Run içindeki 'user' girdisi silindi (varsa)."
} catch { }

# ScreenRec klasörünü kaldır
$screenrecPath = "$env:LOCALAPPDATA\StreamingVideoProvider"
if (Test-Path $screenrecPath) {
    Write-Host ">>> ScreenRec bulunuyor, durduruluyor ve siliniyor..."
    Stop-Process -Name "screenrec" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $screenrecPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "ScreenRec klasörü silindi."
} else {
    Write-Host "ScreenRec bulunamadı."
}

# Zamanlanmış görevlerde explorer.exe kullananları bul ve sil
Write-Host ">>> Zamanlanmış görevler kontrol ediliyor..."
$tasks = Get-ScheduledTask | Where-Object {$_.Actions.Execute -match "explorer.exe"}
if ($tasks) {
    foreach ($task in $tasks) {
        Write-Host ("Zamanlanmış görev temizleniyor: " + $task.TaskName)
        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
    }
} else {
    Write-Host "explorer.exe içeren zamanlanmış görev bulunamadı."
}

Write-Host ">>> Temizlik tamamlandı. Lütfen bilgisayarınızı yeniden başlatın."
