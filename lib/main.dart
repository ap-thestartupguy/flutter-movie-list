import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_list/api_keys.dart';

void main() {
  runApp(const MovieApp(
  ));
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MovieListPage(),
    );
  }
}

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final String apiUrl = ApiKeys.apiUrl;
  final String apiKey = ApiKeys.apiKey;
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(
      Uri.parse('$apiUrl?s=Avengers%20Endgame&r=json&page=1'),
      headers: {
        'X-Rapidapi-Key': apiKey,
        'X-Rapidapi-Host': 'movie-database-alternative.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body)['Search'];
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return ListTile(
            leading: Image.network(
              movie['Poster'] != 'N/A'
                  ? movie['Poster']
                  : 'https://via.placeholder.com/150',
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(movie['Title']),
            subtitle: Text(movie['Year']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(imdbID: movie['imdbID']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MovieDetailPage extends StatefulWidget {
  final String imdbID;

  const MovieDetailPage({super.key, required this.imdbID});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final apiUrl = ApiKeys.apiUrl;
  final apiKey = ApiKeys.apiKey;
  Map movie = {};

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final response = await http.get(
      Uri.parse('$apiUrl?r=json&i=${widget.imdbID}'),
      headers: {
        'X-Rapidapi-Key': apiKey,
        'X-Rapidapi-Host': 'movie-database-alternative.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        movie = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: movie.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            movie['Poster'] != 'N/A'
                ? Image.network(movie['Poster'])
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['Title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Year: ${movie['Year']}'),
                  const SizedBox(height: 8),
                  Text('Rated: ${movie['Rated']}'),
                  const SizedBox(height: 8),
                  Text('Released: ${movie['Released']}'),
                  const SizedBox(height: 8),
                  Text('Runtime: ${movie['Runtime']}'),
                  const SizedBox(height: 8),
                  Text('Genre: ${movie['Genre']}'),
                  const SizedBox(height: 8),
                  Text('Director: ${movie['Director']}'),
                  const SizedBox(height: 8),
                  Text('Writer: ${movie['Writer']}'),
                  const SizedBox(height: 8),
                  Text('Actors: ${movie['Actors']}'),
                  const SizedBox(height: 8),
                  Text('Plot: ${movie['Plot']}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
