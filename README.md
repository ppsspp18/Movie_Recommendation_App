
# 🎬 Movie Recommendation System App

This project is a **Movie Recommendation System** built using **Python** for backend processing and **Flutter (Dart)** for the frontend mobile application. It provides personalized movie recommendations and an interactive app interface for users to manage their favorite and watchlist movies.

---

## 💡 Features

### 🔍 Backend (Python)
- Built a **movie recommendation system** using:
  - **TF-IDF Vectorization** for text-based feature extraction.
  - **Cosine Similarity** for similarity computation between movies.
- Generates:
  - **Top 10 similar movie recommendations** for each movie.
  - **Top 10 recommendations by language**.
- Output is stored in a structured **JSON file**, containing:
  - Movie title
  - Top recommendations

### 📱 Frontend (Flutter)
- Uses the JSON output from the Python backend.
- Provides the following features:
  - 🔎 **Search** movies by **title** or **genre**
  - ❤️ **Liked Movies** list
  - ⏳ **Watch Later** list
  - 🧠 View personalized recommendations per movie

---

## 📁 Project Structure

```
movie_recommender/
│
├── backend/
│   ├── recommend.py            # TF-IDF and cosine similarity logic
│   ├── generate_json.py        # Generates the final JSON with recommendations
│   └── data/                   # Dataset files (CSV/JSON)
│
├── frontend/ (Flutter App)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/            # UI screens
│   │   ├── models/             # Movie and recommendation models
│   │   └── services/           # Data fetching and logic
│   └── assets/
│       └── movies.json         # JSON file with recommendations
│
└── README.md
```

---

## 🚀 Getting Started

### Backend (Python)
1. Install dependencies:
   ```bash
   pip install pandas scikit-learn
   ```
2. Run the recommendation script:
   ```bash
   python generate_json.py
   ```
   This creates `movies.json` with recommendations.

### Frontend (Flutter)
1. Navigate to the `frontend/` directory.
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

---

## 🔧 Tech Stack

- **Python** (Pandas, scikit-learn)
- **Flutter** (Dart)
- **JSON** for data transfer between backend and frontend

---

## 📦 Future Improvements

- Add real-time API instead of static JSON
- Implement user authentication and personalized profiles
- Store liked/watchlist movies persistently (using Firebase or local DB)

---

## 📄 License

This project is open-source and available under the MIT License.
