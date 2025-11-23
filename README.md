# geo_catatan

Rasya Aprilia [362458302115]

## Geolokasi, Peta Digital, dan Geocoding
Hasil percobaan praktikum sesuai modul :
- saat aplikasi pertama kali muncul
<img width="540" height="1170" alt="image" src="https://github.com/user-attachments/assets/1e6d1622-77e6-444c-b4ee-d5dc45f48690" />

- setelah ikon atau tombol my location diklik, peta akan menampilkan dimana posisi sekarang
<img width="540" height="1170" alt="image" src="https://github.com/user-attachments/assets/a630540c-f84f-4f2a-9e95-f8283b954d5b" />

## TUGAS MANDIRI
## 1. Kustomisasi Marker: Ubah ikon marker agar berbeda-beda tergantung jenis catatan (misal: Toko, Rumah, Kantor).
## 2. Hapus Data: Tambahkan fitur untuk menghapus marker yang sudah dibuat.
## 3. Simpan Data: (Opsional) Gunakan SharedPreferences atau Hive agar data tidak hilang saat aplikasi ditutup.
## langkah-langkah : 
- modifikasi catatan_model.dart :
menambahkan atribut "type" untuk menyimpan jenis catatan (toko, rumah, kantor),
menambahkan metode untuk merubah dan menyimpan data berupa teks (JSON)

- modifikasi pubspec.yml :
menambahkan shared preferences, untuk menyimpan data dalam bentuk string

- modifikasi main.dart :
mengimport package shared preferences,
membuat fungsi untuk menyimpan dan menampilkan catatan,
menambahkan fungsi memilih ikon saat longpress dari pengguna untuk meminta input jenis catatan apa dari pengguna,
mengubah ikon dari teks menjadi gambar,
menampilkan catatan di handlelongpress,
menambahkan fungsi menghapus catatan,
membungkus marker untuk bisa di klik dan dikonfirmasi untuk penghapusan

Hasil : menggunakan emulator sehingga bukan alamat asli
- tampilan awal :
<img width="474" height="863" alt="image" src="https://github.com/user-attachments/assets/94cc2135-9da8-4412-a2be-10b7b251f522" />

- setelah klik ikon cari lokasi :
<img width="411" height="847" alt="image" src="https://github.com/user-attachments/assets/32505f9d-af73-4b73-9ffa-1bf90aa44dbe" />

- saat memilih catatan :
<img width="434" height="842" alt="image" src="https://github.com/user-attachments/assets/02a9d21c-15e5-44a0-ab11-3b6eb0cd3c28" />

- setelah menambahkan ikon/marker :
<img width="434" height="850" alt="image" src="https://github.com/user-attachments/assets/bb15a661-345b-4170-b5b6-579b6f6affe0" />

