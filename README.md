# PlantoGuard

PlantoGuard adalah aplikasi mobile berbasis Flutter yang membantu petani dan penggiat tanaman dalam mendeteksi penyakit pada tanaman tomat menggunakan model Machine Learning. Aplikasi ini terintegrasi dengan backend berbasis Flask untuk proses klasifikasi citra tanaman secara real-time.

---

## ✨ Fitur Utama

* Deteksi penyakit tanaman tomat berbasis gambar
* Fitur CRUD penyakit tanaman tomat dengan label yang sudah dilatih
* Autentikasi pengguna dengan JWT (development)
* Backend RESTful API (Flask)

---

## 📂 Struktur Proyek

```bash
plantoguard/
├── backend/                   # Backend Flask
│   ├── app.py
│   ├── config.py
│   ├── models/                # Termasuk model klasifikasi (.h5)
│   ├── resources/
│   ├── schemas/
│   ├── static/
│   └── routes.py
│                              # Frontend Flutter
│   ├── assets/
│   │   └── images/
│   ├── lib/
│   │   ├── components/
│   │   ├── models/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── constants.dart
│   │   └── main.dart
│   └── pubspec.yaml
│
└── README.md
```

---

## 💾 Setup Backend (Flask API)

### 1. Clone repository

```bash
git clone https://github.com/username/plantoguard.git
cd plantoguard/backend
```

### 2. Buat dan aktifkan virtual environment

```bash
python -m venv venv
source venv/bin/activate   # Windows: venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Struktur folder backend (penjelasan singkat)

* `models/` : Berisi definisi model database dengan Flask-SQLAlchemy dan file model klasifikasi (`model.h5`)
* `schemas/` : Serialisasi menggunakan Marshmallow
* `resources/` : Endpoint API (auth, disease, user, dsb)

### 5. Jalankan Flask server

```bash
python app.py
```

API akan berjalan di `http://127.0.0.1:5000/`

---

## 📱 Setup Frontend (Flutter)

### 1. Pindah ke direktori mobile

```bash
cd plantoguard
```

### 2. Jalankan pub get

```bash
flutter pub get
```

### 3. Ganti base URL API jika perlu

Buka file `lib/services/api_services.dart`, sesuaikan URL API:

```dart
const String baseUrl = "http://127.0.0.1:5000"; //Jika menggunakan emulator dapat diganti
```

### 4. Jalankan aplikasi

```bash
flutter run
```

---

## 🔬 API Endpoint Utama

* `POST /auth/login` - Login pengguna
* `POST /auth/register` - Registrasi pengguna
* `POST /auth/reset-password` - Reset password pengguna
* `POST /predict` - Upload gambar dan dapatkan hasil klasifikasi
* `GET /disease` - Ambil semua data penyakit
* `POST /disease` - Tambah data penyakit baru
* `GET/PUT/PATCH/DELETE /disease/<label>` - Akses dan modifikasi penyakit berdasarkan label
* `GET/PUT/PATCH/DELETE /disease/id/<id>` - Akses dan modifikasi penyakit berdasarkan ID
* `GET/POST/DELETE/PUT/PATCH /users` atau `/users/<id>` - Manajemen pengguna

---

## ✍️ Catatan Penting

* Model Machine Learning (`model.h5`) harus sudah dilatih dan disimpan di folder `models/`
* Gunakan emulator Android/iOS atau perangkat nyata dengan koneksi ke IP backend
* Gunakan `ngrok` atau IP LAN agar bisa diakses dari perangkat

## 📸 Demo Aplikasi
![Tampilan Aplikasi](assets/images/Plantoguard.gif)

Untuk pertanyaan lebih lanjut atau laporan bug, silakan buka issue di GitHub repository ini atau hubungi kami melalui Linkedin yang tertera:
(https://www.linkedin.com/in/muhamad-ramadani-937976245/)