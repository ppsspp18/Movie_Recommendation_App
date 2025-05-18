import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MovieG {
  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final String genre;
  final List<int> recommendations;
  final List<int> languageRecommendations;

  MovieG({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genre,
    required this.recommendations,
    required this.languageRecommendations,
  });

  factory MovieG.fromJson(Map<String, dynamic> json) {
    List<int> extractIds(String prefix) {
      return List<int>.generate(10, (i) {
        final key = '$prefix${i + 1}';
        return (json[key] ?? -1).toInt();
      }).where((id) => id != -1).toList();
    }

    return MovieG(
      id: (json['id'] as num).toInt(),
      title: json['title'],
      overview: json['overview'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      genre: json['genre'],
      recommendations: extractIds('r'),
      languageRecommendations: extractIds('rl'),
    );
  }
}

class SearchGenreScreen extends StatefulWidget {
  const SearchGenreScreen({super.key});

  @override
  State<SearchGenreScreen> createState() => _SearchGenreScreenState();
}

class _SearchGenreScreenState extends State<SearchGenreScreen> {
  late Future<List<MovieG>> moviesFuture;
  List<MovieG> allMovies = [];
  String searchQuery = '';
  Set<int> expandedMovieIds = {};
  Set<int> watchlist = {};
  Set<int> likedlist = {};

  @override
  void initState() {
    super.initState();
    moviesFuture = loadMovies();
    loadWatchlist();
    loadLikedlist();
  }

  Future<void> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('watchlist') ?? [];
    setState(() {
      watchlist = ids.map(int.parse).toSet();
    });
  }

  Future<void> saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'watchlist',
      watchlist.map((id) => id.toString()).toList(),
    );
  }
  Future<void> loadLikedlist() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('likedlist') ?? [];
    setState(() {
      likedlist = ids.map(int.parse).toSet();
    });
  }

  Future<void> saveLikedlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'likedlist',
      likedlist.map((id) => id.toString()).toList(),
    );
  }

  Future<List<MovieG>> loadMovies() async {
    final String response =
    await DefaultAssetBundle.of(context).loadString('assets/movies.json');
    final List<dynamic> data = json.decode(response);
    final movies = data.map((json) => MovieG.fromJson(json)).toList();
    allMovies = movies;
    return movies;
  }

  List<String> getMovieTitlesFromIds(List<int> ids) {
    return ids
        .map((id) => allMovies.firstWhere(
          (m) => m.id == id,
      orElse: () => MovieG(
        id: -1,
        title: 'Unknown',
        overview: '',
        voteAverage: 0,
        genre: '',
        recommendations: [],
        languageRecommendations: [],
      ),
    ).title)
        .toList();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Movies")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => setState(() => searchQuery = query),
              decoration: InputDecoration(
                labelText: 'Search by genre',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MovieG>>(
              future: moviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (allMovies.isEmpty && snapshot.hasData) {
                  allMovies = snapshot.data!;
                }

                final filteredMovies = searchQuery.isEmpty
                    ? allMovies
                    : allMovies
                    .where((movie) => movie.genre
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                    .toList();

                filteredMovies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));

                final displayedMovies = filteredMovies.take(50).toList();


                if (displayedMovies.isEmpty) {
                  return const Center(child: Text('No movies found.'));
                }

                return ListView.builder(
                  itemCount: displayedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = displayedMovies[index];
                    final isExpanded = expandedMovieIds.contains(movie.id);

                    final recommendedTitles =
                    getMovieTitlesFromIds(movie.recommendations);
                    final recommendedIds = movie.recommendations;

                    final languageRecommendedTitles =
                    getMovieTitlesFromIds(movie.languageRecommendations);
                    final languageRecommendedIds =
                        movie.languageRecommendations;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(movie.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("⭐ ${movie.voteAverage} • 🎬 ${movie.genre}"),
                            if (isExpanded) ...[
                              const SizedBox(height: 8),
                              Text(movie.overview),
                              const SizedBox(height: 8),
                              const Text("🔁 Movies recommended based on this movie :",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              ...List.generate(recommendedTitles.length, (i) {
                                final id = recommendedIds[i];
                                final title = recommendedTitles[i];
                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text("• $title")),
                                    IconButton(
                                      icon: const Icon(Icons.playlist_add),
                                      tooltip: 'Add to Watchlist',
                                      onPressed: () {
                                        setState(() => watchlist.add(id));
                                        saveWatchlist();
                                        showSnackBar(
                                            "Added '$title' to Watchlist");
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.thumb_up),
                                      tooltip: 'Like',
                                      onPressed: () {
                                        setState(() => likedlist.add(id));
                                        saveLikedlist();
                                        showSnackBar(
                                            "Added '$title' to Liked Movies");
                                      },
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 6),
                              const Text("🌐 Movies recommended by language based on this movie:",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              ...List.generate(languageRecommendedTitles.length,
                                      (i) {
                                    final id = languageRecommendedIds[i];
                                    final title = languageRecommendedTitles[i];
                                    return Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text("• $title")),
                                        IconButton(
                                          icon: const Icon(Icons.playlist_add),
                                          tooltip: 'Add to Watchlist',
                                          onPressed: () {
                                            setState(() => watchlist.add(id));
                                            saveWatchlist();
                                            showSnackBar(
                                                "Added '$title' to Watchlist");
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.thumb_up),
                                          tooltip: 'Like',
                                          onPressed: () {
                                            setState(() => likedlist.add(id));
                                            saveWatchlist();
                                            showSnackBar(
                                                "Added '$title' to Liked Movies");
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                            ]
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            isExpanded
                                ? expandedMovieIds.remove(movie.id)
                                : expandedMovieIds.add(movie.id);
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
