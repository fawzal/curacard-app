# Changelog & Update History

Semua perubahan dan pembaruan penting pada project **CuraCard** akan dicatat dalam file ini.

## [1.0.0] - 2026-09-24
**Status: Rilis Awal (Initial Release)**

### Ditambahkan (Added)
- **Sistem Autentikasi**: Implementasi Supabase Auth (Daftar, Masuk) dengan input tambahan untuk Nama Lengkap.
- **Onboarding Screen**: Pengenalan fitur aplikasi untuk pengguna baru.
- **Home Navigation**: Sistem tab dinamis (Pass ID, Tracker, Kontak Darurat).
- **Pass ID View**: Layar untuk melihat ringkasan identitas darurat (Golongan darah, Alergi, Kondisi Kronis).
- **Tracker View**: Layar pelacak obat dengan *Adherence Score* harian.
- **Form Interaktif**:
  - `AddMedicationSheet` untuk menambahkan obat.
  - `AddContactDialog` untuk menyimpan daftar kontak darurat.
  - `EditProfileScreen` untuk melengkapi data ID medis.
- **Sistem Skema Supabase (SQL)**: Tabel terstruktur dengan *Foreign Keys*, *Trigger* otomatis (saat register), dan *Row Level Security* (RLS).

### Diubah / Disempurnakan (Changed)
- **Migrasi Arsitektur (Lokal ke Cloud)**: Penghapusan total *SharedPreferences* (kecuali status onboarding). Aplikasi sekarang menggunakan metode sinkronisasi data 100% *Online-only* ke Supabase.
- **UI Dropdown & Input**: Pembaruan menyeluruh untuk komponen input teks dan *dropdown* menggunakan standar *Material 3 DropdownMenu*. Bentuk kotak input diubah menjadi kapsul (*pill shape* dengan radius 30) sesuai spesifikasi *Design System*.
- **Warna & Aksen**: Perbaikan palet warna ke warna primer hijau/slate. Tombol SOS darurat disempurnakan dengan *Maroon Red* (`#991B1B`).
- **Ambient Header**: Avatar dihapus dan diganti dengan sapaan interaktif ("Halo, [Nama Lengkap]") yang diambil langsung dari *stream database*.

### Keamanan (Security)
- RLS Policy untuk `SELECT`, `INSERT`, `UPDATE`, `DELETE` diaplikasikan secara spesifik agar pengguna hanya dapat mengakses baris data sesuai UUID miliknya masing-masing.
