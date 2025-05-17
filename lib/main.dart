import 'package:flutter/material.dart';
import 'package:movie_recommender_app/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie_Recommendation_App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(50, 100)
              ),
              child: Text('Search Movies', style: TextStyle(color: Colors.deepOrange)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(50, 100)
              ),
              child: Text('Watch Lists', style: TextStyle(color: Colors.deepOrange)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(50, 100)
              ),
              child: Text('Watched Movies', style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        ),
      ),
    );
  }
}
