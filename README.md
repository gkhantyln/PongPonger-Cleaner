# PongPonger Cleaner

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Turkish

### Açıklama
Bu depo, bilgisayarınızda PongPonger adware yazılımının kalıntılarını tespit edip temizlemek için kullanılan PowerShell betiklerini içerir. PongPonger, genellikle istenmeden yüklenen ve bilgisayar performansını etkileyen bir reklam yazılımıdır.

### Betikler

#### 1. check_pongponger.ps1
Bu betik, sisteminizde PongPonger'in kalıntılarını tespit etmek için kullanılır. Aşağıdaki alanları kontrol eder:
- Windows başlangıç kayıtları (HKCU ve HKLM)
- Zamanlanmış görevler
- StreamingVideoProvider klasörü (ScreenRec)
- Şüpheli çalışan süreçler
- Otomatik başlatma konumları

#### 2. cleanup.ps1
Bu betik, tespit edilen PongPonger kalıntılarını temizlemek için kullanılır:
- Başlangıç kayıtlarını kaldırır
- Zamanlanmış görevleri siler
- StreamingVideoProvider klasörünü siler
- İlgili işlemleri durdurur

### Kullanım Talimatları

#### Önkoşullar
- Windows işletim sistemi
- PowerShell yürütme izinleri

#### 1. Adım: İnceleme
```powershell
.\check_pongponger.ps1
```
Bu komut, sisteminizde PongPonger kalıntılarını arar ve sonuçları gösterir.

#### 2. Adım: Temizlik
```powershell
.\cleanup.ps1
```
Bu komut, tespit edilen tüm PongPonger kalıntılarını temizler.

> **Not:** Temizlik işleminden sonra bilgisayarınızı yeniden başlatmanız önerilir.

### Güvenlik Uyarısı
Bu betikleri çalıştırmadan önce, bilgisayarınızda önemli verilerin yedeklendiğinden emin olun. Betikler sistem kayıtları ve dosyalar üzerinde değişiklik yapar.

---

## English

### Description
This repository contains PowerShell scripts to detect and clean remnants of the PongPonger adware software from your computer. PongPonger is an adware that is often installed unintentionally and affects computer performance.

### Scripts

#### 1. check_pongponger.ps1
This script is used to detect PongPonger remnants on your system. It checks the following areas:
- Windows registry run entries (HKCU and HKLM)
- Scheduled tasks
- StreamingVideoProvider folder (ScreenRec)
- Suspicious running processes
- Autostart locations

#### 2. cleanup.ps1
This script is used to clean detected PongPonger remnants:
- Removes registry run entries
- Deletes scheduled tasks
- Removes StreamingVideoProvider folder
- Stops related processes

### Usage Instructions

#### Prerequisites
- Windows operating system
- PowerShell execution permissions

#### Step 1: Detection
```powershell
.\check_pongponger.ps1
```
This command searches for PongPonger remnants on your system and displays the results.

#### Step 2: Cleanup
```powershell
.\cleanup.ps1
```
This command cleans all detected PongPonger remnants.

> **Note:** It is recommended to restart your computer after the cleanup process.

### Security Warning
Before running these scripts, ensure that important data on your computer is backed up. The scripts make changes to system registry and files.

## Repository Information

**Repository Name:** PongPonger-Cleaner
**Short Description:** PowerShell scripts to detect and remove PongPonger adware remnants from Windows systems

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.