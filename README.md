# Advanced PongPonger Cleaner

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Turkish

### Açıklama
Bu depo, bilgisayarınızda PongPonger adware yazılımının kalıntılarını tespit edip temizlemek için kullanılan gelişmiş PowerShell betiklerini içerir. Bu betikler, orijinal temizlik betiklerine göre daha kapsamlı tarama ve temizlik seçenekleri sunar.

![Açıklayıcı Metin](https://raw.githubusercontent.com/gkhantyln/PongPonger-Cleaner/main/advanced_2.png)


### Betikler

#### 1. advanced_pongponger_cleaner.ps1
Bu gelişmiş betik, kullanıcı dostu bir menü arayüzü ile PongPonger kalıntılarını tespit etmek ve temizlemek için kullanılır. Aşağıdaki özellikleri içerir:

- **Otomatik Tam Tarama ve Temizlik:** Tüm bileşenleri tek seferde tarar ve temizler
- **Manuel Adım Adım İşlem:** Her bileşeni ayrı ayrı tarama ve temizleme seçeneği
- **Bileşen Bazlı Tarama:** Registry, zamanlanmış görevler, dosyalar, kısayollar, hosts dosyası ve servisler için ayrı tarama seçenekleri
- **Özel PongPonger Girişi Temizliği:** PongPonger'e özgü "user" registry girişini özel olarak hedef alır
- **Günlükleme:** Tüm işlemler ayrıntılı günlük dosyasına kaydedilir

##### Menü Seçenekleri:
1. Otomatik Tam Tarama ve Temizlik
2. Manuel Adım Adım İşlem
3. Yalnızca Registry Taraması
4. Yalnızca Zamanlanmış Görevler Taraması
5. Yalnızca Dosya/Klasör Taraması
6. Yalnızca Tarayıcı Kısayolları Taraması
7. Yalnızca Hosts Dosyası Taraması
8. Yalnızca Servisler Taraması
9. Çıkış

#### 2. advanced_pongponger_cleaner_plus.ps1
Bu geliştirilmiş betik, [advanced_pongponger_cleaner.ps1](file:///C:/Users/user/Desktop/Pongor/advanced_pongponger_cleaner.ps1) betiğine ek olarak tarayıcı uzantılarını kontrol etme özelliğine sahiptir. Tüm [advanced_pongponger_cleaner.ps1](file:///C:/Users/user/Desktop/Pongor/advanced_pongponger_cleaner.ps1) özelliklerine sahip olup, ek olarak:

- **Tarayıcı Uzantıları Kontrolü:** Chrome, Firefox, Edge ve Opera tarayıcıları için uzantı kontrolü bilgisi sağlar

##### Menü Seçenekleri:
1. Otomatik Tam Tarama ve Temizlik (Tüm Bileşenler)
2. Manuel Adım Adım İşlem
3. Yalnızca Registry Taraması
4. Yalnızca Zamanlanmış Görevler Taraması
5. Yalnızca Dosya/Klasör Taraması
6. Yalnızca Tarayıcı Kısayolları Taraması
7. Yalnızca Hosts Dosyası Taraması
8. Yalnızca Servisler Taraması
9. Tarayıcı Uzantıları Kontrolü (Yalnızca Bilgi)
10. Çıkış

### Kullanım Talimatları

#### Önkoşullar
- Windows işletim sistemi
- PowerShell yürütme izinleri

#### 1. Adım: Betiklerin İndirilmesi
Bu depodaki [advanced_pongponger_cleaner.ps1](file:///C:/Users/user/Desktop/Pongor/advanced_pongponger_cleaner.ps1) ve [advanced_pongponger_cleaner_plus.ps1](file:///C:/Users/user/Desktop/Pongor/advanced_pongponger_cleaner_plus.ps1) betiklerini indirin.

#### 2. Adım: PowerShell Yetkilendirmesi
PowerShell'i yönetici olarak çalıştırın ve aşağıdaki komutu girin:
```powershell
Set-ExecutionPolicy RemoteSigned
```

#### 3. Adım: Betiklerin Çalıştırılması
PowerShell'i yönetici olarak çalıştırın ve betik dosyasının bulunduğu dizine gidin:

```powershell
cd "C:\Path\To\Script"
```

Ardından betiklerden birini çalıştırın:

```powershell
.\advanced_pongponger_cleaner.ps1
```

veya

```powershell
.\advanced_pongponger_cleaner_plus.ps1
```

#### 4. Adım: Menü Seçeneklerini Kullanma
Betiği çalıştırdıktan sonra ekrandaki menü yönergelerini izleyin. Otomatik tam tarama ve temizlik için "1" seçeneğini seçin veya manuel olarak adım adım işlem yapmak için diğer seçenekleri kullanın.

> **Not:** Temizlik işleminden sonra bilgisayarınızı yeniden başlatmanız önerilir.

### Güvenlik Uyarısı
Bu betikleri çalıştırmadan önce, bilgisayarınızda önemli verilerin yedeklendiğinden emin olun. Betikler sistem kayıtları ve dosyalar üzerinde değişiklik yapar.

---

## English

### Description
This repository contains advanced PowerShell scripts to detect and clean remnants of the PongPonger adware software from your computer. These scripts offer more comprehensive scanning and cleaning options compared to the original cleanup scripts.

### Scripts

#### 1. advanced_pongponger_cleaner.ps1
This advanced script is used to detect and clean PongPonger remnants with a user-friendly menu interface. It includes the following features:

- **Automatic Full Scan and Cleanup:** Scans and cleans all components at once
- **Manual Step-by-Step Process:** Option to scan and clean each component individually
- **Component-Based Scanning:** Separate scanning options for registry, scheduled tasks, files, shortcuts, hosts file, and services
- **Specific PongPonger Entry Cleanup:** Specifically targets the PongPonger-specific "user" registry entry
- **Logging:** All operations are logged to a detailed log file

##### Menu Options:
1. Automatic Full Scan and Cleanup
2. Manual Step-by-Step Process
3. Registry Scan Only
4. Scheduled Tasks Scan Only
5. File/Folder Scan Only
6. Browser Shortcuts Scan Only
7. Hosts File Scan Only
8. Services Scan Only
9. Exit

#### 2. advanced_pongponger_cleaner_plus.ps1
This enhanced script has all the features of [advanced_pongponger_cleaner.ps1](file:///C:/Users/user/Desktop/Pongor/advanced_pongponger_cleaner.ps1) plus browser extension checking capabilities:

- **Browser Extensions Check:** Provides information for checking extensions in Chrome, Firefox, Edge, and Opera browsers

##### Menu Options:
1. Automatic Full Scan and Cleanup (All Components)
2. Manual Step-by-Step Process
3. Registry Scan Only
4. Scheduled Tasks Scan Only
5. File/Folder Scan Only
6. Browser Shortcuts Scan Only
7. Hosts File Scan Only
8. Services Scan Only
9. Browser Extensions Check (Information Only)
10. Exit

### Usage Instructions

#### Prerequisites
- Windows operating system
- PowerShell execution permissions

#### Step 1: Download Scripts
Download the [advanced_pongponger_cleaner.ps1](file:///C:/Users/user/Desktop/Pongor/advanced_pongponger_cleaner.ps1) and [advanced_pongponger_cleaner_plus.ps1](file:///C:/Users/user/Desktop/Pongor/advanced_pongponger_cleaner_plus.ps1) scripts from this repository.

#### Step 2: PowerShell Authorization
Run PowerShell as administrator and enter the following command:
```powershell
Set-ExecutionPolicy RemoteSigned
```

#### Step 3: Running the Scripts
Run PowerShell as administrator and navigate to the directory where the script file is located:

```powershell
cd "C:\Path\To\Script"
```

Then run one of the scripts:

```powershell
.\advanced_pongponger_cleaner.ps1
```

or

```powershell
.\advanced_pongponger_cleaner_plus.ps1
```

#### Step 4: Using Menu Options
After running the script, follow the on-screen menu instructions. Select option "1" for automatic full scan and cleanup, or use other options to process manually step by step.

> **Note:** It is recommended to restart your computer after the cleanup process.

### Security Warning
Before running these scripts, ensure that important data on your computer is backed up. The scripts make changes to system registry and files.

## Repository Information

**Repository Name:** Advanced-PongPonger-Cleaner
**Short Description:** Advanced PowerShell scripts to detect and remove PongPonger adware remnants from Windows systems

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
