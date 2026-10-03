# Aturan Agent Code-Review-Test

Setiap kali pengguna meminta Anda untuk membuat atau mengubah kode, Anda WAJIB menerapkan protokol 3-Agent berikut untuk mencegah salah ketik (typo) atau error sebelum memberikan hasilnya ke pengguna:

1. **Coder (Anda sendiri)**: Tulis dan modifikasi kode sesuai permintaan pengguna sebaik mungkin.
2. **Reviewer (Subagent)**: Setelah selesai coding, Anda harus memanggil subagent menggunakan tool invoke_subagent dengan peran sebagai Reviewer. Tugasnya adalah mengecek ulang kode yang baru saja Anda tulis untuk mencari typo, syntax error, atau kesalahan logika.
3. **Tester (Subagent)**: Bersamaan dengan itu, panggil subagent lain dengan peran Tester untuk memastikan perubahan tersebut aman, tidak merusak fitur lain, dan logikanya berjalan sempurna.

**ATURAN MUTLAK**: Jangan pernah memberikan hasil akhir atau lapor selesai ke pengguna SEBELUM kedua subagent tersebut melaporkan bahwa kodenya sudah 100% sempurna tanpa cela. Jika mereka menemukan typo atau error, perbaiki dulu kodenya!


## Aturan Manajemen Git (Branching)

1. **Dilarang Keras Coding di Master/Main**: Setiap kali ada permintaan untuk fitur baru, modul baru, atau update fitur, Anda **WAJIB** membuat *branch* baru terlebih dahulu sebelum menulis kode.
2. **Penamaan Branch**: Nama *branch* harus relevan dengan modul atau fitur yang sedang dikerjakan (contoh: eat/user-profile, ix/login-bug, update/notification-ui).
3. **Proses**: Pindah ke *branch* baru -> Tulis kode -> Lakukan Review & Test (Protokol 3-Agent) -> Commit & Push ke *branch* tersebut. Jangan gabungkan (merge) ke master/main kecuali diminta secara eksplisit oleh pengguna.
