<p align="center">
  <img src="docs/preview/hero.png" alt="Racing Math — ilustrasi game balapan matematika" width="100%">
</p>

<h1 align="center">Racing Math</h1>

<p align="center">
  <b>Jawab soal matematika, pacu mobilmu ke garis finis.</b><br>
  Flutter · GetX · stopwatch
</p>

<p align="center">
  <a href="https://flutter.dev"><img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white"></a>
  <a href="https://pub.dev/packages/get"><img alt="GetX" src="https://img.shields.io/badge/State-GetX-8E24AA"></a>
</p>

---

## ✨ Preview

<p align="center">
  <img src="docs/preview/hero.png" alt="Mockup gelap Racing Math" width="90%">
</p>

> **Catatan:** gambar di atas adalah *ilustrasi konsep*, bukan screenshot asli.

---

## 📖 Tentang

Game edukasi bertema balapan: setiap jawaban benar mendorong mobil lebih cepat ke finis,
sementara stopwatch mencatat waktumu. Cocok untuk latihan matematika cepat.

---

## 🌟 Fitur

- 🏁 **Menu, countdown, dan layar balapan** (`menu_screen`, `countdown_screen`, `game_screen`, `race_track`)
- 🧮 **Soal matematika** yang harus dijawab cepat
- ⏱️ **Timer** dengan `stop_watch_timer`
- 🎮 **Controller terpisah** untuk game dan balapan
- 💬 Toast feedback dengan `fluttertoast`

---

## 🛠️ Tech Stack

| Area | Pilihan |
|---|---|
| Framework | Flutter |
| State management | GetX |
| Timer | `stop_watch_timer` |
| Feedback | `fluttertoast` |

---

## 🧱 Struktur

```text
lib/
└── data/
    ├── bindings/
    ├── controllers/   # game_controller, race_controller
    ├── models/        # game_state
    ├── views/         # menu, countdown, game, race_track
    └── widgets/
```

---

## 🚀 Menjalankan

```bash
flutter pub get
flutter run
```

---

## 🧪 Testing

```bash
flutter analyze
flutter test
```
