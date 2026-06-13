# 🚀 LaperBang Monorepo Application

Repository ini berisi source code untuk project aplikasi mobile LaperBang. Proyek ini menggunakan arsitektur monorepo yang memisahkan sisi Customer App (Aplikasi Pembeli) dan Seller App (Aplikasi Penjual) ke dalam dua direktori yang berbeda.

📂 Struktur Proyek
```md
LaperBang/
├── LaperBang-01bd6112676ba635e14c1aa750c02a4b7cd37d78/       # Customer App (Aplikasi Pembeli)
│   ├── android/          # File konfigurasi dan build Android pembeli
│   ├── ios/              # File konfigurasi dan build iOS pembeli
│   ├── assets/           # Aset gambar promo dan tampilan aplikasi
│   ├── lib/              # Kode sumber utama Dart
│   │   ├── Helper/       # Database lokal (database.dart)
│   │   ├── Models/       # Model data autentikasi
│   │   ├── Pages/        # Halaman UI (Home, Jajan, Detail, Favorit, dll.)
│   │   ├── Services/     # State Management (Auth & Jajan Provider)
│   │   └── Widgets/      # Komponen UI reusable (Promo Slider, Search Bar, dll.)
│   └── pubspec.yaml      # Dependensi aplikasi pembeli
│
├── LaperBang-47ae905394b8c9dad0dfe86d1a3dde437a7ecaf2/       # Seller App (Aplikasi Penjual)
│   ├── android/          # File konfigurasi dan build Android penjual
│   ├── ios/              # File konfigurasi dan build iOS penjual
│   ├── lib/              # Kode sumber utama Dart
│   │   ├── Models/       # Model data bisnis & penjual
│   │   ├── Pages/        # Halaman UI (Home, Live Chat, Map, Login, dll.)
│   │   ├── Services/     # State Management (Auth, Chat, & Seller Provider)
│   │   └── Widget/       # Komponen UI reusable khusus seller
│   └── pubspec.yaml      # Dependensi aplikasi penjual
│
├── .gitignore            # Aturan pengabaian file Git
└── README.md             # Dokumentasi proyek
```
🛠️ Prasyarat (Prerequisites)

Sebelum menjalankan proyek ini di komputermu, pastikan kamu sudah menginstal:

* Flutter SDK (Versi kompatibel dengan Dart SDK ^3.8.1)
* Dart SDK
* Android Studio / Xcode (untuk menjalankan Emulator/Simulator)
* VS Code atau IntelliJ IDEA yang sudah terpasang ekstensi Flutter & Dart

💻 Panduan Instalasi & Menjalankan Proyek

Karena Customer App dan Seller App berada di folder yang terpisah, kamu bisa membuka terminal terpisah (split terminal) jika ingin menjalankan keduanya secara bersamaan.

Langkah 1: Clone Repository
git clone [https://github.com/mumtazalwan/laperbang.git](https://github.com/mumtazalwan/laperbang.git)
cd laperbang

Langkah 2: Setup & Jalankan Customer App (Pembeli) 🍔
Aplikasi ini digunakan oleh pelanggan untuk menjelajahi jajanan, melihat promo, dan mengelola daftar favorit.

1. Masuk ke folder Customer App:
cd LaperBang-01bd6112676ba635e14c1aa750c02a4b7cd37d78
2. Unduh semua dependencies:
flutter pub get
3. Jalankan aplikasi (pastikan device/emulator sudah aktif):
flutter run

Langkah 3: Setup & Jalankan Seller App (Penjual) 🏪
Aplikasi ini digunakan oleh penjual untuk mengelola operasional toko, membagikan koordinat toko di peta, dan membalas pesan obrolan pelanggan secara real-time.

1. Buka terminal baru dan masuk ke folder Seller App:
cd LaperBang-47ae905394b8c9dad0dfe86d1a3dde437a7ecaf2
2. Unduh semua dependencies:
flutter pub get
3. Jalankan aplikasi:
flutter run

✨ Fitur & Teknologi

📱 Customer App

* State Management: Provider (provider) untuk manajemen autentikasi dan produk jajanan.
* Local Storage: Implementasi berkas database.dart di dalam folder Helper untuk manajemen persistensi data lokal.
* Custom UI: Komponen interaktif seperti PromoSlider, FloatingSearchBar, dan PedagangPopup.

🏪 Seller App

* Core Framework & Language: Flutter, Dart SDK (^3.8.1).
* State Management: Provider (provider) untuk alur autentikasi, manajemen toko, dan data obrolan.
* Maps & Geolocation: Integrasi peta interaktif menggunakan flutter_map beserta latlong2, serta pelacakan koordinat GPS penjual secara real-time menggunakan paket geolocator.
* Responsive UI & Storage: Menggunakan flutter_screenutil untuk adaptasi ukuran layar yang konsisten serta shared_preferences untuk penyimpanan sesi lokal ringan.
