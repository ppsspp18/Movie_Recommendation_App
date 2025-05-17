import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_recommender_app/search.dart'; // For Movie class

class LikedScreen extends StatefulWidget {
  final List<Movie> allMovies;

  const LikedScreen({super.key, required this.allMovies});

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  Set<int> likedlistIds = {};

  @override
  void initState() {
    super.initState();
    loadLikedlist();
  }

  Future<void> loadLikedlist() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('likedlist') ?? [];
    setState(() {
      likedlistIds = ids.map(int.parse).toSet();
    });
  }

  Future<void> removeFromLikedlist(int id) async {
    setState(() {
      likedlistIds.remove(id);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'likedlist',
      likedlistIds.map((id) => id.toString()).toList(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from liked movies')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final likedMovies = widget.allMovies
        .where((movie) => likedlistIds.contains(movie.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Liked Movies')),
      body: likedMovies.isEmpty
          ? const Center(child: Text('No movies in your liked list.'))
          : ListView.builder(
        itemCount: likedMovies.length,
        itemBuilder: (context, index) {
          final movie = likedMovies[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(movie.title),
              subtitle: Text("⭐ ${movie.voteAverage} • 🎬 ${movie.genre}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeFromLikedlist(movie.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
