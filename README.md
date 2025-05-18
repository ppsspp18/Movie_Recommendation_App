
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
  - **Top 10 similar movie recommendations by language** for each movie.
- Output is stored in a structured **JSON file**, containing:
  - Movie title
  - Movie overview
  - Movie genre
  - Movie language
  - Top 10 recommendations
  - Top 10 recommendations by language

### 📱 Frontend (Flutter)
- Uses the JSON output from the Python backend.
- Provides the following features:
  - 🔎 **Search** movies by **title** or **genre**
  - ❤️ **Liked Movies** list
  - ⏳ **Watch Later** list
  - 🧠 View content based recommendations per movie

---

## 📁 Project Structure

```
movie_recommender/
│
├── backend/
│   ├── top10K-TMDB-movies.csv                       # Data used by the ml model 
│   ├── Movie_recommendation_system.ipynb            # TF-IDF and cosine similarity logic and generate json file
│   └── movies.json                                  # Generated json file                     
│
├── frontend/ (Flutter App)
│   ├── lib/
│   │   ├── main.dart             # Home screen
│   │   ├── liked.dart            # Liked movies screen 
│   │   ├── search.dart           # search screen 
│   │   └── watchlist.dart        # watch later screen
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
   movies_recommendation_system.ipynb
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

## Data Reference 
- https://www.kaggle.com/datasets/ahsanaseer/top-rated-tmdb-movies-10k/code
