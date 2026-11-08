# CuraCard - Aplikasi Asisten Medis Pribadi
> **Ujian Tengah Semester (UTS) Ganjil Tahun Akademik 2026/2027**  
> **Mata Kuliah**: Mobile Testing  
> **Program Studi**: S1 Teknik Informatika  
> **Fakultas**: Fakultas Ilmu Komputer, Universitas Duta Bangsa Surakarta  
> **Dosen Pengampu**: Triyono, M.Kom  
> **Kelas**: TI23B  

---

## 👤 Identitas & Peran Anggota

| No | Nama Mahasiswa | NIM | Kelas | Peran dalam Proyek |
|---|---|---|---|---|
| 1 | Fawwaz Gibran S. A. F | 230103021 | TI23B | Project Lead, UI/UX Designer, Mobile Developer, QA & Test Engineer (UAT & Maestro), Dokumentasi & Video Penjelasan |

---

## 🔗 Tautan Pengumpulan Proyek (Submission Links)

- 🎥 **Tautan Video Penjelasan (Durasi 5–10 Menit)**:  
  `[Tautan YouTube / Google Drive Video Penjelasan Anda]`
- 🐙 **Tautan Repository Git (GitHub / GitLab)**:  
  `https://github.com/fawzal/curacard-app.git`
- 📦 **File APK Aplikasi**:  
  Dapat di-generate melalui perintah `flutter build apk` (berlokasi di `build/app/outputs/flutter-apk/app-release.apk` atau `app-debug.apk`).

---

## 📱 Gambaran Umum Aplikasi (CuraCard)

### 1. Tujuan Aplikasi
**CuraCard** adalah aplikasi mobile berbasis Flutter yang dirancang untuk menjadi asisten medis pribadi yang tangguh. Aplikasi ini bertujuan membantu pengguna menyimpan profil darurat (*Pass ID*) yang dapat diakses seketika (< 3 detik) oleh tenaga medis atau penolong pertama saat kecelakaan/kondisi gawat, sekaligus menyediakan pelacak jadwal minum obat harian untuk meningkatkan kepatuhan terapi pasien (*medication adherence*).

### 2. Target Pengguna
- **Pasien Rawat Jalan & Penderita Penyakit Kronis** (misal hipertensi, diabetes, jantung) yang harus rutin mengonsumsi obat tepat waktu.
- **Lansia dan Keluarga Pendamping** yang memerlukan monitoring pengingat obat dan kartu kontak darurat instan.
- **Masyarakat Umum / Penolong Pertama (First Responders)** yang membutuhkan informasi medis vital (golongan darah, alergi obat, penyakit kronis) dengan cepat di tempat kejadian.

### 3. Fitur Utama
1. **ID Medis Darurat (Emergency Pass ID)**:
   - Kartu digital visual yang menampilkan golongan darah, riwayat alergi, kondisi medis kronis, dan kontak darurat utama.
2. **Pelacak Resep & Kepatuhan Obat (Medication Tracker & Adherence Score)**:
   - Menambahkan jadwal resep obat harian (dosis, waktu minum obat, ikon obat).
   - Menandai obat yang telah diminum (*Taken*) atau terlewat (*Pending/Skipped*).
   - Menghitung persentase tingkat kepatuhan minum obat harian (*Adherence Score*) secara otomatis.
3. **Tombol SOS Cepat (One-Tap Emergency Call)**:
   - Tombol darurat di bagian tengah bawah untuk panggilan langsung ke kontak keluarga utama atau hotline layanan darurat 112.
4. **Sinkronisasi Cloud Real-Time (Supabase Backend)**:
   - Integrasi database PostgreSQL dan Supabase Auth dengan Row Level Security (RLS) untuk keamanan data privasi pengguna.

### 4. Alur Pengguna (User Journey)
1. **Onboarding & Autentikasi**: Pengguna membuka aplikasi, melihat ringkasan fitur di layar Onboarding, lalu mendaftar akun atau login dengan email & password.
2. **Dashboard & ID Medis**: Pengguna masuk ke Home Screen, melihat ID Medis personal, serta melengkapi profil kesehatan (golongan darah, riwayat alergi).
3. **Pelacakan Obat**: Pengguna berpindah ke tab "Pelacak", menambahkan jadwal obat yang perlu diminum hari ini, dan mencentang obat yang sudah dikonsumsi.
4. **Panggilan Darurat**: Jika terjadi insiden darurat, pengguna atau penolong pertama menekan tombol SOS merah di floating bar untuk memanggil kontak darurat.

### 5. Batasan Pengujian (Testing Scope & Boundaries)
- Pengujian difokuskan pada platform **Android** (Emulator Pixel 6 Android 14/15 dan Real Device).
- Pengujian mencakup alur autentikasi, navigasi antarmuka, transaksi CRUD jadwal obat, validasi formulir masukan, serta pemicuan panggilan darurat SOS.
- Fitur hardware seperti sensor NFC atau integrasi biometrik fingerprint berada di luar batasan pengujian tugas ini.

---

## 📋 User Acceptance Testing (UAT)

Laporan pengujian penerimaan pengguna (*User Acceptance Testing*) lengkap telah disusun sesuai format akademik dan tersedia di:  
📄 **[`docs/LAPORAN_UAT.md`](file:///d:/flutter-02/docs/LAPORAN_UAT.md)**

### Ringkasan Skenario Pengujian UAT:
- **TC-UAT-01**: Pendaftaran Pengguna Baru *(Alur Utama)* — **LULUS (PASS)**
- **TC-UAT-02**: Validasi Masukan Form Kosong & Email Tidak Valid *(Validasi Input & Kondisi Gagal)* — **LULUS (PASS)**
- **TC-UAT-03**: Login Pengguna Terdaftar *(Alur Utama)* — **LULUS (PASS)**
- **TC-UAT-04**: Navigasi Antar Tab Menu Utama *(Navigasi)* — **LULUS (PASS)**
- **TC-UAT-05**: Pembaruan Profil ID Medis *(CRUD Profil)* — **LULUS (PASS)**
- **TC-UAT-06**: Penambahan Jadwal Resep Obat Baru *(CRUD Transaksi)* — **LULUS (PASS)**
- **TC-UAT-07**: Pencatatan Konsumsi Obat & Kalkulasi Adherence Score *(Logika Bisnis)* — **LULUS (PASS)**
- **TC-UAT-08**: Pemicuan Tombol Panggilan Darurat SOS *(Fitur Kritis)* — **LULUS (PASS)**

---

## 🤖 Automate Testing Menggunakan Maestro

Direktori flow pengujian otomatis berada pada folder:  
📁 **[`maestro/`](file:///d:/flutter-02/maestro/)** (Lihat detail di [`maestro/README.md`](file:///d:/flutter-02/maestro/README.md))

### Cakupan 4 Flow Maestro Wajib:
1. **Flow 1: Pembukaan Aplikasi & Splash (`maestro/01_app_launch.yaml`)**
   - Membuka aplikasi (`launchApp`), menunggu Splash Screen (`CuraCard`), melewati Onboarding, dan memverifikasi layar Autentikasi muncul.
   - Assertions: `assertVisible: "CuraCard"`, `assertVisible: "Selamat Datang di CuraCard"`.
   - Screenshot otomatis: `screenshots/01_app_launch_splash.png`.

2. **Flow 2: Navigasi Antar Halaman (`maestro/02_navigation.yaml`)**
   - Menguji alur perpindahan antar menu navigasi: **ID Medis** ➔ **Pelacak Obat** ➔ **Kontak Darurat** ➔ **ID Medis**.
   - Assertions: `assertVisible: "Emergency Health Pass"`, `assertVisible: "Pelacak Obat"`, `assertVisible: "Kontak Darurat"`.
   - Screenshot otomatis: `screenshots/02_nav_id_medis.png`, `screenshots/02_nav_pelacak_obat.png`, `screenshots/02_nav_kontak_darurat.png`.

3. **Flow 3: Alur Transaksi / CRUD (`maestro/03_crud_medication.yaml`)**
   - Membuka tab Pelacak, menekan tombol Tambah, mengisi formulir resep (Nama: *Parasetamol 500mg*, Dosis: *1 Tablet*, Frekuensi: *1x Sehari*), menekan "Simpan Resep", dan memverifikasi item baru muncul di daftar.
   - Assertions: `assertVisible: "Tambah Resep Baru"`, `assertVisible: "Parasetamol 500mg"`.
   - Screenshot otomatis: `screenshots/03_crud_open_sheet.png`, `screenshots/03_crud_success.png`.

4. **Flow 4: Validasi Kesalahan / Error Handling (`maestro/04_error_validation.yaml`)**
   - Menguji respon aplikasi terhadap input tidak valid: submit login form kosong, input email format salah (`invalid_email`), input kata sandi kurang dari 6 karakter, dan submit form pendaftaran tanpa nama.
   - Assertions: `assertVisible: "Email tidak valid"`, `assertVisible: "Minimal 6 karakter"`, `assertVisible: "Nama lengkap wajib diisi"`.
   - Screenshot otomatis: `screenshots/04_err_email_kosong.png`, `screenshots/04_err_password_pendek.png`, `screenshots/04_err_register_nama_kosong.png`.

### Cara Menjalankan Flow Maestro:
```bash
# Jalankan seluruh suite pengujian sekaligus
maestro test maestro/

# Atau jalankan per skenario
maestro test maestro/01_app_launch.yaml
maestro test maestro/02_navigation.yaml
maestro test maestro/03_crud_medication.yaml
maestro test maestro/04_error_validation.yaml
```

---

## 🚀 Petunjuk Menjalankan Aplikasi

### Prasyarat
- Flutter SDK versi 3.24.x / 3.27.x ke atas
- Android Studio & Android SDK (API 34/35)
- Koneksi Internet untuk sinkronisasi database Supabase

### Langkah-langkah Menjalankan di Emulator / Perangkat:
1. Clone repositori ke komputer lokal Anda:
   ```bash
   git clone https://github.com/fawzal/curacard-app.git
   cd curacard
   ```
2. Pasang pustaka dan dependensi:
   ```bash
   flutter pub get
   ```
3. Pastikan emulator Android aktif:
   ```bash
   adb devices
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```
5. Untuk membuat file APK mandiri (release atau debug):
   ```bash
   flutter build apk --debug
   # File APK akan dibuat di: build/app/outputs/flutter-apk/app-debug.apk
   ```

---

## 🌿 Riwayat dan Praktik Git (Commit History)
Proyek ini dikembangkan secara berkala dengan riwayat commit yang jelas, terstruktur (*Conventional Commits*), dan dibuat bertahap sejak awal pengembangan:
- Memiliki lebih dari 30+ commit bermakna pada repositori Git.
- Menerapkan branch fitur (*Feature Branching*) untuk setiap modul baru: `feat/uts-mobile-testing-maestro`.
- Memisahkan source code, artefak pengujian otomatis Maestro, laporan UAT, dan dokumentasi panduan.
