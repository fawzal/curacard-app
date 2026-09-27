# Panduan Kontribusi & Pengembangan (Development Guidelines)

Dokumen ini berisi aturan dan standar penulisan kode serta pengelolaan repositori (Git) untuk memastikan kualitas dan konsistensi kode di dalam proyek **CuraCard**.

## 🌿 Git Branching Strategy

Untuk menjaga agar *master branch* tetap stabil dan setiap perubahan dapat ditrack dengan baik, setiap *development* atau perbaikan fitur **wajib** dilakukan di *branch* baru.

### Penamaan Branch (Branch Naming Convention)
Gunakan format berikut untuk penamaan *branch*:
`<tipe>/<deskripsi-singkat>` (contoh: `feat/medication-header`)

Berikut adalah kategori `<tipe>` yang harus digunakan:
- **`feat/`** : Untuk penambahan fitur atau fungsionalitas baru (contoh: `feat/sos-button`, `feat/medication-reminder`).
- **`fix/` atau `bugfix/`** : Untuk perbaikan bug atau error pada fitur yang sudah ada (contoh: `fix/login-crash`).
- **`hotfix/`** : Untuk perbaikan darurat (*urgent*) yang harus segera diselesaikan dan langsung di-*merge* ke production/master (contoh: `hotfix/database-connection`).
- **`chore/`** : Untuk pekerjaan pemeliharaan yang tidak mengubah fungsionalitas aplikasi, seperti update *library*, konfigurasi *environment*, atau modifikasi `.gitignore` (contoh: `chore/update-dependencies`).
- **`refactor/`** : Untuk merapikan atau menstrukturisasi ulang kode tanpa mengubah perilaku fungsinya (contoh: `refactor/clean-architecture`).
- **`docs/`** : Untuk penambahan atau perbaikan dokumentasi, seperti README atau komentar pada kode (contoh: `docs/update-readme`).

### Alur Kerja (Workflow)
1. Selalu buat *branch* baru dari `master` (contoh: `git checkout -b feat/nama-fitur`).
2. Lakukan perubahan pada *branch* tersebut.
3. *Commit* perubahan dengan pesan yang deskriptif (menggunakan *Conventional Commits*).
4. *Push* branch Anda dan buat Pull Request (PR) ke `master`.

---

## 📝 Commit Message Convention

Pesan *commit* juga harus mengikuti konvensi yang jelas, dengan format:
`<tipe>: <pesan singkat deskriptif>`

**Contoh:**
- `feat: menambahkan fitur reminder obat`
- `fix: memperbaiki error saat menekan tombol SOS`
- `chore: menambahkan file uat ke gitignore`
- `docs: menambahkan guideline development`

Ini memudahkan seluruh tim untuk membaca riwayat perubahan proyek.
