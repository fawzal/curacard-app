# Project Timeline & Roadmap

Berikut adalah garis waktu (timeline) pengembangan dan perencanaan fitur aplikasi **CuraCard**.

## 🔴 Fase 1: Konsep & Desain UI Dasar (Selesai)
- [x] Mendefinisikan *Design System* (Palet warna, Tipografi, Ikonografi).
- [x] Pembuatan komponen dasar UI (Button, Card, Form Field).
- [x] Desain *Onboarding Screen*.
- [x] Kerangka navigasi utama (Bottom bar / Indexed Stack).

## 🟡 Fase 2: Integrasi Backend & State Management (Selesai)
- [x] Konfigurasi *Project* Supabase.
- [x] Desain skema *Database* PostgreSQL (Tabel Profiles, Contacts, Medications, Logs).
- [x] Implementasi Riverpod untuk *State Management*.
- [x] Pembuatan fungsi *Repository* (Profile, Medication).
- [x] Integrasi fungsi baca/tulis data ke UI.

## 🟢 Fase 3: Transisi Cloud & Poles UI Akhir (Selesai)
- [x] Mengubah aplikasi dari *Offline/Local* (SharedPreferences) menjadi *Full Online / Cloud First*.
- [x] Penerapan *Row Level Security* (RLS) di Database.
- [x] Penyempurnaan UX *Auth* (Pendaftaran menggunakan nama lengkap & Penanganan pesan *Error*).
- [x] Optimalisasi *Material 3 DropdownMenu* agar lebih presisi menyesuaikan layar.
- [x] *Styling* khusus fitur Darurat (Tombol SOS Maroon).

## 🔵 Fase 4: Perluasan Fitur Medis (Mendatang)
- [ ] **Push Notifications**: Pengingat alarm lokal saat jadwal minum obat tiba.
- [ ] **History & Analytics**: Grafik riwayat kepatuhan (Adherence score) per minggu/bulan.
- [ ] **Lock Screen Widget**: Akses *Pass ID* secara *read-only* dari *lock screen* perangkat (Native Android/iOS).

## 🟣 Fase 5: Ekosistem & Ekspor (Mendatang)
- [ ] **Export to PDF**: Mencetak laporan ID Medis & log obat ke format PDF untuk diberikan ke dokter.
- [ ] **Family Link**: Memungkinkan pengguna menautkan profil ke anggota keluarga.
- [ ] **Mode Luring Terjadwal (Offline Sync)**: Menambahkan sinkronisasi *cache* saat tidak ada internet sementara, yang dikirim begitu sinyal kembali.
