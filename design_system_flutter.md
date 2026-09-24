# Flutter Design System - Color Palette & Usage

Dokumen ini berisi panduan sistem desain warna untuk aplikasi Flutter, mencakup skala warna lengkap dari 50 hingga 900 beserta definisi kegunaannya untuk UI.

## 1. Panduan Skala Warna (Color Scale Guide)

Secara umum, sistem skala warna 50-900 memiliki aturan penggunaan sebagai berikut:
*   **50 - 100**: Digunakan untuk latar belakang (backgrounds) dan permukaan (surfaces).
*   **200 - 300**: Digunakan untuk *state* (hover/pressed pada background), garis pemisah (dividers), dan border halus.
*   **400 - 500**: Digunakan untuk warna utama komponen, ikon, dan border yang tegas. Nilai **500** biasanya adalah warna *Base* (warna utama brand).
*   **600 - 700**: Digunakan untuk teks sekunder, ikon aktif, dan *state* interaktif (hover/active pada tombol).
*   **800 - 900**: Digunakan untuk teks utama (high emphasis), judul (headings), dan elemen dengan kontras tinggi.

---

## 2. Color Variables (0 - 900)

### A. Primary / Brand Colors (Green)
Berbasis pada warna brand utama `#2D9C65` (Base 500). Digunakan untuk identitas utama, aksi primer, dan state sukses.

| Scale | Hex Code | Flutter Value | Usage Definition |
| :--- | :--- | :--- | :--- |
| **50** | `#EAF5F0` | `Color(0xFFEAF5F0)` | Latar belakang sangat terang (contoh: bg notifikasi sukses, bg chip). |
| **100** | `#CDE8DA` | `Color(0xFFCDE8DA)` | Latar belakang elemen aktif sekunder, highlight tabel. |
| **200** | `#A1D4BD` | `Color(0xFFA1D4BD)` | Border elemen aktif, *disabled state* untuk tombol primer. |
| **300** | `#6DBE98` | `Color(0xFF6DBE98)` | Ikon sekunder, indikator progres halus. |
| **400** | `#43AA7A` | `Color(0xFF43AA7A)` | Hover state untuk ikon utama atau tombol sekunder. |
| **500** | `#2D9C65` | `Color(0xFF2D9C65)` | **BASE COLOR.** Tombol utama (Primary Button), Checkbox, App Bar. |
| **600** | `#227D51` | `Color(0xFF227D51)` | Hover/Pressed state untuk tombol utama. |
| **700** | `#1B6441` | `Color(0xFF1B6441)` | Ikon aktif dengan kontras tinggi, teks tautan (link). |
| **800** | `#154D32` | `Color(0xFF154D32)` | Teks pada latar belakang terang yang butuh aksen hijau. |
| **900** | `#0F3A26` | `Color(0xFF0F3A26)` | Judul atau elemen teks brand dengan kontras maksimal. |

### B. Neutral Colors
Digunakan untuk struktur dasar UI, teks, dan latar belakang umum. Skala monokromatik (putih ke hitam/abu-abu gelap).

| Scale | Hex Code | Flutter Value | Usage Definition |
| :--- | :--- | :--- | :--- |
| **0** (White)| `#FFFFFF` | `Color(0xFFFFFFFF)` | Background utama aplikasi, background Card/Dialog. |
| **50** | `#FAFAFA` | `Color(0xFFFAFAFA)` | Background alternatif, area konten sekunder. |
| **100** | `#F5F5F5` | `Color(0xFFF5F5F5)` | Background input field (disabled), baris tabel zebra. |
| **200** | `#E5E5E5` | `Color(0xFFE5E5E5)` | Garis pemisah (Dividers), border halus. |
| **300** | `#D4D4D4` | `Color(0xFFD4D4D4)` | Border input field normal, border Card. |
| **400** | `#A3A3A3` | `Color(0xFFA3A3A3)` | Placeholder text (hint), ikon *disabled*. |
| **500** | `#737373` | `Color(0xFF737373)` | Teks sekunder (keterangan tambahan, label minor). |
| **600** | `#525252` | `Color(0xFF525252)` | Teks body utama, ikon navigasi unselected. |
| **700** | `#404040` | `Color(0xFF404040)` | Teks penekanan sedang, judul sub-seksi. |
| **800** | `#262626` | `Color(0xFF262626)` | Judul utama (Headings), teks penekanan tinggi (High Emphasis). |
| **900** | `#171717` | `Color(0xFF171717)` | Teks paling gelap (hampir hitam), judul halaman utama. |

### C. Slate / Blue Colors
Warna abu-abu kebiruan. Digunakan untuk elemen sekunder yang butuh nuansa lebih dingin/elegan, serta *secondary text/background*.

| Scale | Hex Code | Flutter Value | Usage Definition |
| :--- | :--- | :--- | :--- |
| **50** | `#F8FAFC` | `Color(0xFFF8FAFC)` | Latar belakang input form, panel samping (sidebar). |
| **100** | `#F1F5F9` | `Color(0xFFF1F5F9)` | Latar belakang tombol sekunder (terang), area *skeleton loading*. |
| **200** | `#E2E8F0` | `Color(0xFFE2E8F0)` | Border sekunder, pemisah antar komponen Slate. |
| **300** | `#CBD5E1` | `Color(0xFFCBD5E1)` | Ikon atau elemen grafis pendukung (low emphasis). |
| **400** | `#94A3B8` | `Color(0xFF94A3B8)` | Teks placeholder untuk input field Slate. |
| **500** | `#64748B` | `Color(0xFF64748B)` | **BASE SLATE.** Teks sekunder (subtitle, deskripsi), ikon unselected. |
| **600** | `#475569` | `Color(0xFF475569)` | Teks interaktif sekunder (hover text). |
| **700** | `#334155` | `Color(0xFF334155)` | Teks informasi tebal (bold secondary text). |
| **800** | `#1E293B` | `Color(0xFF1E293B)` | Judul komponen sekunder, latar belakang Slate gelap (Tooltip). |
| **900** | `#0F172A` | `Color(0xFF0F172A)` | Latar belakang komponen *dark mode* atau elemen invert. |

### D. Semantic Colors (Alert Error / Red)
Untuk status kesalahan, peringatan bahaya, dan aksi destruktif (misal: tombol hapus).

| Scale | Hex Code | Flutter Value | Usage Definition |
| :--- | :--- | :--- | :--- |
| **50** | `#FEF2F2` | `Color(0xFFFEF2F2)` | Latar belakang banner error / *toast message* error. |
| **100** | `#FEE2E2` | `Color(0xFFFEE2E2)` | Latar belakang alert box merah. |
| **500** | `#EF4444` | `Color(0xFFEF4444)` | **BASE ERROR.** Teks pesan error, ikon error, tombol Destructive. |
| **700** | `#B91C1C` | `Color(0xFFB91C1C)` | State pressed pada tombol Destructive, teks error kontras tinggi. |

### E. Semantic Colors (Warning / Amber)
Untuk peringatan atau status tertunda (pending).

| Scale | Hex Code | Flutter Value | Usage Definition |
| :--- | :--- | :--- | :--- |
| **50** | `#FFFBEB` | `Color(0xFFFFFBEB)` | Latar belakang banner peringatan / *toast* warning. |
| **100** | `#FEF3C7` | `Color(0xFFFEF3C7)` | Latar belakang alert box kuning. |
| **500** | `#F59E0B` | `Color(0xFFF59E0B)` | **BASE WARNING.** Ikon peringatan, status "Pending". |
| **700** | `#B45309` | `Color(0xFFB45309)` | Teks peringatan yang membutuhkan kontras baca tinggi. |

*(Catatan: Untuk status "Success", gunakan skala Primary/Brand Green).*

---

## 3. Implementasi Flutter (Class & MaterialColor)

Dalam Flutter, praktik terbaik untuk mengelola skala warna adalah menggunakan `Map<int, Color>` atau `MaterialColor`.

```dart
import 'package:flutter/material.dart';

class AppColors {
  // --- PRIMARY (BRAND) ---
  static const MaterialColor primary = MaterialColor(
    0xFF2D9C65, // Base 500
    <int, Color>{
      50: Color(0xFFEAF5F0),
      100: Color(0xFFCDE8DA),
      200: Color(0xFFA1D4BD),
      300: Color(0xFF6DBE98),
      400: Color(0xFF43AA7A),
      500: Color(0xFF2D9C65), // Base
      600: Color(0xFF227D51),
      700: Color(0xFF1B6441),
      800: Color(0xFF154D32),
      900: Color(0xFF0F3A26),
    },
  );

  // --- NEUTRAL ---
  static const Color white = Color(0xFFFFFFFF);
  static const MaterialColor neutral = MaterialColor(
    0xFF737373, // Base 500
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFE5E5E5),
      300: Color(0xFFD4D4D4),
      400: Color(0xFFA3A3A3),
      500: Color(0xFF737373), // Base
      600: Color(0xFF525252),
      700: Color(0xFF404040),
      800: Color(0xFF262626),
      900: Color(0xFF171717),
    },
  );

  // --- SLATE ---
  static const MaterialColor slate = MaterialColor(
    0xFF64748B, // Base 500
    <int, Color>{
      50: Color(0xFFF8FAFC),
      100: Color(0xFFF1F5F9),
      200: Color(0xFFE2E8F0),
      300: Color(0xFFCBD5E1),
      400: Color(0xFF94A3B8),
      500: Color(0xFF64748B), // Base
      600: Color(0xFF475569),
      700: Color(0xFF334155),
      800: Color(0xFF1E293B),
      900: Color(0xFF0F172A),
    },
  );

  // --- SEMANTIC ---
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color errorBase = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFB91C1C);

  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color warningBase = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFB45309);
}
```