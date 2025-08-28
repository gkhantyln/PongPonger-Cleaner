# === PONGPONGER KALINTI KONTROL SCRIPTİ ===

Write-Host ">>> Başlatılıyor: Pongponger kalıntı taraması..."

# 1. Başlangıç kayıtları
$runKeys = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($key in $runKeys) {
    Write-Host "Kontrol ediliyor: $key"
    try {
        $props = Get-ItemProperty -Path $key
        if ($props.PSObject.Properties.Name -contains "user") {
            Write-Host "[!] Şüpheli başlangıç kaydı bulundu: 'user' → $($props.user)"
        } else {
            Write-Host "Başlangıç kaydı temiz."
        }
    } catch {
        Write-Host "Anahtar bulunamadı veya okunamadı: $key"
    }
}

# 2. Scheduled Task kontrolü
Write-Host ">>> Scheduled Task kontrol ediliyor..."
$tasks = Get-ScheduledTask | Where-Object {$_.Actions.Execute -match "explorer.exe"}
if ($tasks) {
    foreach ($task in $tasks) {
        Write-Host "[!] Şüpheli zamanlanmış görev bulundu: $($task.TaskName) → $($task.Actions.Execute)"
    }
} else {
    Write-Host "Scheduled Task’ta şüpheli görev yok."
}

# 3. ScreenRec / StreamingVideoProvider klasör kontrolü
$screenrecPath = "$env:LOCALAPPDATA\StreamingVideoProvider"
if (Test-Path $screenrecPath) {
    Write-Host "[!] ScreenRec klasörü mevcut: $screenrecPath"
} else {
    Write-Host "ScreenRec klasörü bulunamadı."
}

# 4. Çalışan süreçlerde şüpheli exe kontrolü
Write-Host ">>> Çalışan süreçler kontrol ediliyor..."
$processes = Get-Process | Where-Object { $_.Name -match "screenrec|explorer" }
foreach ($p in $processes) {
    if ($p.Path -and $p.Path -match "StreamingVideoProvider") {
        Write-Host "[!] Şüpheli süreç çalışıyor: $($p.Name) → $($p.Path)"
    }
}

# 5. Başka programdan tetikleme kontrolü
Write-Host ">>> Otomatik tetikleme olasılığı kontrol ediliyor..."
# Windows otomatik başlatma konumları
$autostartDirs = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
)
foreach ($dir in $autostartDirs) {
    if (Test-Path $dir) {
        $items = Get-ChildItem $dir -Recurse | Where-Object { $_.Extension -match "\.lnk|\.exe" }
        foreach ($item in $items) {
            Write-Host "[!] Otomatik başlatma dosyası bulundu: $($item.FullName)"
        }
    }
}

Write-Host ">>> Tarama tamamlandı."
Write-Host "NOT: Eğer yukarıda şüpheli bir kayıt veya görev çıktıysa, temizlik scripti ile silinmelidir."
