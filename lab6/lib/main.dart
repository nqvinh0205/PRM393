import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find a Movie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const GenreScreen(),
    );
  }
}

// Backwards-compatible alias for tests expecting `MyApp`.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveMovieApp();
  }
}

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

const List<Movie> allMovies = [
  Movie(
    title: 'The Adventurer',
    year: 2020,
    genres: ['Action', 'Adventure'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=The+Adventurer',
    rating: 4.2,
  ),
  Movie(
    title: 'Love & Drama',
    year: 2018,
    genres: ['Drama', 'Romance'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Love+%26+Drama',
    rating: 3.8,
  ),
  Movie(
    title: 'Laugh Riot',
    year: 2021,
    genres: ['Comedy'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Laugh+Riot',
    rating: 4.5,
  ),
  Movie(
    title: 'Sci-Fi Epic',
    year: 2019,
    genres: ['Sci-Fi', 'Action'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Sci-Fi+Epic',
    rating: 4.7,
  ),
  Movie(
    title: 'Mystery Manor',
    year: 2017,
    genres: ['Mystery', 'Thriller'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Mystery+Manor',
    rating: 4.0,
  ),
  Movie(
    title: 'Family Ties',
    year: 2022,
    genres: ['Family', 'Drama'],
    posterUrl: 'https://via.placeholder.com/300x450.png?text=Family+Ties',
    rating: 3.9,
  ),
];

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final List<String> genres = [
    'Action',
    'Adventure',
    'Drama',
    'Comedy',
    'Romance',
    'Sci-Fi',
    'Mystery',
    'Thriller',
    'Family',
  ];

  final TextEditingController _searchController = TextEditingController();
  final Set<String> selectedGenres = {};
  String selectedSort = 'A-Z';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void clearFilters() {
    setState(() {
      selectedGenres.clear();
      selectedSort = 'A-Z';
      _searchController.clear();
    });
  }

  List<Movie> getVisibleMovies() {
    final query = _searchController.text.trim().toLowerCase();
    List<Movie> visible = allMovies.where((m) {
      final matchesQuery = query.isEmpty ||
          m.title.toLowerCase().contains(query) ||
          m.genres.any((g) => g.toLowerCase().contains(query)) ||
          m.year.toString().contains(query);
      final matchesGenre = selectedGenres.isEmpty || m.genres.any((g) => selectedGenres.contains(g));
      return matchesQuery && matchesGenre;
    }).toList();

    switch (selectedSort) {
      case 'A-Z':
        visible.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        visible.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        visible.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Rating':
        visible.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return visible;
  }

  @override
  Widget build(BuildContext context) {
    final visible = getVisibleMovies();

    return Scaffold(
      appBar: AppBar(title: const Text('Find a Movie')),
      body: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('Find a Movie', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search movies...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Genre chips with badge and clear
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: genres.map((g) {
                          final selected = selectedGenres.contains(g);
                          return FilterChip(
                            label: Text(g),
                            selected: selected,
                            onSelected: (_) => setState(() {
                              if (selected) {
                                selectedGenres.remove(g);
                              } else {
                                selectedGenres.add(g);
                              }
                            }),
                          );
                        }).toList(),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(width: 8),
                if (selectedGenres.isNotEmpty)
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.indigo,
                    child: Text('${selectedGenres.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                const SizedBox(width: 8),
                TextButton(onPressed: clearFilters, child: const Text('Clear filters')),
              ],
            ),

            const SizedBox(height: 8),

            // Sort bar
            Row(
              children: [
                const Text('Sort: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedSort,
                  items: const [
                    DropdownMenuItem(value: 'A-Z', child: Text('A–Z')),
                    DropdownMenuItem(value: 'Z-A', child: Text('Z–A')),
                    DropdownMenuItem(value: 'Year', child: Text('Year')),
                    DropdownMenuItem(value: 'Rating', child: Text('Rating')),
                  ],
                  onChanged: (v) => setState(() {
                    if (v != null) selectedSort = v;
                  }),
                ),
                const Spacer(),
                Text('Results: ${visible.length}'),
              ],
            ),

            const SizedBox(height: 12),

            // Movie list
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 800;
                final movies = visible;

                if (movies.isEmpty) {
                  return const Center(child: Text('No movies match your filters'));
                }

                if (isWide) {
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 1.1,
                    children: movies.map((m) => MovieCard(movie: m, isGrid: true)).toList(),
                  );
                }

                return ListView.separated(
                  itemCount: movies.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return MovieCard(movie: movies[index], isGrid: false);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isGrid;

  const MovieCard({super.key, required this.movie, required this.isGrid});

  Widget _buildRating(double rating) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber.shade700, size: 16),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              final posterWidth = isGrid ? 90.0 : 80.0;
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  movie.posterUrl,
                  width: posterWidth,
                  height: posterWidth * 1.5,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: posterWidth,
                      height: posterWidth * 1.5,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: posterWidth,
                      height: posterWidth * 1.5,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(movie.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('${movie.year} • ${movie.genres.join(', ')}', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  _buildRating(movie.rating),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
