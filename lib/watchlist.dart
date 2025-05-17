import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_recommender_app/search.dart'; // For Movie class

class WatchlistScreen extends StatefulWidget {
  final List<Movie> allMovies;

  const WatchlistScreen({super.key, required this.allMovies});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  Set<int> watchlistIds = {};

  @override
  void initState() {
    super.initState();
    loadWatchlist();
  }

  Future<void> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('watchlist') ?? [];
    setState(() {
      watchlistIds = ids.map(int.parse).toSet();
    });
  }

  Future<void> removeFromWatchlist(int id) async {
    setState(() {
      watchlistIds.remove(id);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'watchlist',
      watchlistIds.map((id) => id.toString()).toList(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from watchlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final watchlistMovies = widget.allMovies
        .where((movie) => watchlistIds.contains(movie.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Watchlist')),
      body: watchlistMovies.isEmpty
          ? const Center(child: Text('No movies in your watchlist.'))
          : ListView.builder(
        itemCount: watchlistMovies.length,
        itemBuilder: (context, index) {
          final movie = watchlistMovies[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(movie.title),
              subtitle: Text("⭐ ${movie.voteAverage} • 🎬 ${movie.genre}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeFromWatchlist(movie.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
