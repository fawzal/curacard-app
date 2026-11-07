# Panduan Pengujian Otomatis Maestro - CuraCard

Dokumen ini berisi petunjuk instalasi, konfigurasi, dan eksekusi skrip pengujian otomatis (*automated testing*) menggunakan **Maestro** untuk aplikasi mobile **CuraCard**.

---

## 📋 Daftar Flow Pengujian

Semua skrip otomasi pengujian disimpan di dalam direktori `maestro/`:

| No | File Flow | Deskripsi Pengujian | Kategori Skenario | Assertion Utama |
|---|---|---|---|---|
| 1 | `01_app_launch.yaml` | Pembukaan aplikasi, Splash Screen, Onboarding, dan redirect ke Auth Screen. | *App Launch & Splash* | `CuraCard`, `Selamat Datang di CuraCard`, `Masuk`, `Daftar` |
| 2 | `02_navigation.yaml` | Navigasi menu utama: ID Medis (Pass ID) ➔ Pelacak Obat ➔ Kontak Darurat ➔ ID Medis. | *Navigation Flow* | `Emergency Health Pass`, `Pelacak Obat`, `Kontak Darurat` |
| 3 | `03_crud_medication.yaml` | Menambahkan jadwal resep obat baru melalui modal sheet dan memverifikasi data tampil di list. | *Transaction / CRUD* | `Tambah Resep Baru`, `Parasetamol 500mg`, `1 Tablet sesudah makan` |
| 4 | `04_error_validation.yaml` | Menguji penanganan kesalahan input form: email kosong, format email invalid, password < 6 karakter, form daftar kosong. | *Error Validation* | `Email tidak valid`, `Minimal 6 karakter`, `Nama lengkap wajib diisi` |

---

## 🛠️ Prasyarat Lingkungan (Prerequisites)

1. **Java JDK 17 atau lebih baru**:
   - Pastikan variabel lingkungan `JAVA_HOME` telah dikonfigurasi.
   - Contoh verifikasi di terminal:
     ```bash
     java -version
     ```
2. **Android SDK & ADB**:
   - Pastikan path `platform-tools` Android SDK ada di variabel PATH.
   - Periksa koneksi perangkat / emulator:
     ```bash
     adb devices
     ```
3. **Emulator Android / Perangkat Fisik**:
   - Minimal Android 8.0 (API level 26).
   - Pastikan fitur *USB Debugging* aktif jika menggunakan perangkat fisik.

---

## 📥 Panduan Instalasi Maestro

### Metode 1: Menggunakan Script Resmi (Git Bash / WSL / macOS / Linux)
```bash
curl -fsSL "https://get.maestro.mobile.dev" | bash
```

### Metode 2: Instalasi Manual di Windows (PowerShell)
1. Unduh arsip rilis terbaru dari [Maestro GitHub Releases](https://github.com/mobile-dev-inc/Maestro/releases/latest/download/maestro.zip).
2. Ekstrak folder arsip ke direktori tetap, misalnya `C:\maestro` atau `%USERPROFILE%\.maestro`.
3. Tambahkan subfolder `bin` ke variabel *Environment Variables* `PATH`:
   ```powershell
   setx PATH "%PATH%;C:\Users\<Username>\.maestro\bin"
   ```
4. Buka terminal baru dan verifikasi instalasi:
   ```bash
   maestro --version
   ```

---

## 🚀 Perintah Menjalankan Pengujian

Pastikan emulator atau perangkat Android Anda sudah aktif dan aplikasi CuraCard sudah terpasang.

### 1. Menjalankan Seluruh Flow Secara Berurutan (Suite Test)
```bash
maestro test maestro/
```

### 2. Menjalankan Flow Tertentu
- **Flow 1: Pembukaan Aplikasi & Splash**
  ```bash
  maestro test maestro/01_app_launch.yaml
  ```
- **Flow 2: Navigasi Antar Halaman**
  ```bash
  maestro test maestro/02_navigation.yaml
  ```
- **Flow 3: Alur Transaksi / CRUD Obat**
  ```bash
  maestro test maestro/03_crud_medication.yaml
  ```
- **Flow 4: Validasi Kesalahan Form**
  ```bash
  maestro test maestro/04_error_validation.yaml
  ```

### 3. Menghasilkan Laporan Pengujian (HTML / XML JUnit Report)
```bash
maestro test maestro/ --format junit --output test-results.xml
```

---

## 📸 Bukti Pengujian (Screenshots & Logs)
Setiap alur flow di atas dilengkapi perintah `takeScreenshot` yang otomatis menyimpan tangkapan layar ke subfolder `maestro/screenshots/` sebagai bukti bahwa seluruh kriteria pengujian berhasil terverifikasi:
- `01_app_launch_onboarding.png`
- `01_auth_screen_ready.png`
- `02_nav_id_medis.png`
- `02_nav_pelacak_obat.png`
- `02_nav_kontak_darurat.png`
- `02_nav_kembali_id_medis.png`
- `03_crud_open_sheet.png`
- `03_crud_form_filled.png`
- `03_crud_success.png`
- `04_err_email_kosong.png`
- `04_err_email_format_salah.png`
- `04_err_password_pendek.png`
- `04_err_register_nama_kosong.png`
