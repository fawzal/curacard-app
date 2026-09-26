# CuraCard - Aplikasi Asisten Medis Pribadi

CuraCard adalah aplikasi berbasis Flutter yang dirancang untuk menjadi asisten medis pribadi Anda. Aplikasi ini memungkinkan pengguna untuk menyimpan ID Medis (Pass ID) yang dapat diakses cepat dalam keadaan darurat, serta fitur pelacak jadwal minum obat harian.

## 🌟 Fitur Utama

- **ID Medis Darurat (Pass ID)**: Menyimpan profil medis penting seperti golongan darah, alergi, kondisi kronis, dan kontak darurat utama.
- **Tombol SOS Cepat**: Tombol *one-tap* untuk langsung menelepon kontak darurat utama atau nomor hotline darurat.
- **Pelacak Pengingat Obat (Tracker)**: Menjadwalkan, mencatat, dan melacak konsumsi obat harian beserta tingkat kepatuhan (Adherence Score).
- **Desain Modern (Material 3)**: Antarmuka yang bersih dan ramah pengguna dengan skema warna yang menenangkan (Pill-shaped inputs, rounded cards).
- **Real-time Cloud Sync**: Semua data tersimpan dengan aman secara *online* menggunakan **Supabase** (Autentikasi & Database PostgreSQL).

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod (`flutter_riverpod`)
- **Backend & Database**: Supabase (`supabase_flutter`)
- **Arsitektur**: Clean Architecture (Presentation, Data, Core/Domain layers)

## 🚀 Cara Menjalankan Project (Getting Started)

### Prasyarat
- Flutter SDK (Versi terbaru)
- Konfigurasi Supabase Project (URL & Anon Key)

### Instalasi
1. Clone repository ini.
2. Buka terminal dan jalankan perintah:
   ```bash
   flutter pub get
   ```
3. Pastikan konfigurasi Supabase Anda sudah dimasukkan ke dalam file `lib/core/network/supabase_config.dart`.
4. Jalankan aplikasi di emulator atau perangkat fisik:
   ```bash
   flutter run
   ```

## 🔐 Keamanan Database (Row Level Security)
Aplikasi ini diatur agar hanya pengguna yang sudah terautentikasi yang dapat mengakses datanya sendiri (RLS Enabled di tabel `profiles`, `medications`, `intake_logs`, `emergency_contacts`).
