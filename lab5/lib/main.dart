import 'package:flutter/material.dart';
import 'sample_data.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  List<Movie> get _filteredMovies {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) {
      return sampleMovies;
    }
    return sampleMovies.where((movie) {
      return movie.title.toLowerCase().contains(query) ||
          movie.genres.any((genre) => genre.toLowerCase().contains(query));
    }).toList();
  }

  void _openMovieDetail(Movie movie) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Explorer'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search movies or genres',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredMovies.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final movie = _filteredMovies[index];
          return MovieCard(movie: movie, onTap: () => _openMovieDetail(movie));
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: SizedBox(
          height: 160,
          child: Row(
            children: [
              Hero(
                tag: 'poster-${movie.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Image.network(
                    movie.posterUrl,
                    width: 120,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: double.infinity,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.grey, size: 36),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: movie.isFavorite ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Rating: ${movie.rating.toStringAsFixed(1)} / 10',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: movie.genres
                              .map(
                                (genre) => Chip(
                                  label: Text(genre),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.movie.isFavorite = _isFavorite;
    });
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showActionMessage('Share link copied!'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'poster-${movie.id}',
                  child: Image.network(
                    movie.posterUrl,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 320,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.grey, size: 64),
                    ),
                  ),
                ),
                Container(
                  height: 320,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromRGBO(0, 0, 0, 0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${movie.rating.toStringAsFixed(1)} / 10',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 6),
                            Text('Top pick', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: movie.genres
                    .map(
                      (genre) => Chip(
                        label: Text(genre),
                        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(38),
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Text(
                'Overview',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                movie.overview,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _DetailActionButton(
                    icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                    label: _isFavorite ? 'Favorited' : 'Favorite',
                    color: _isFavorite ? Colors.red : null,
                    onPressed: _toggleFavorite,
                  ),
                  const SizedBox(width: 12),
                  _DetailActionButton(
                    icon: Icons.star,
                    label: 'Rate',
                    onPressed: () => _showActionMessage('Thanks for rating!'),
                  ),
                  const SizedBox(width: 12),
                  _DetailActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onPressed: () => _showActionMessage('Share link copied!'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Trailers',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              itemCount: movie.trailers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final trailer = movie.trailers[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        trailer.thumbnailUrl,
                        width: 100,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 100,
                          height: 70,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, color: Colors.grey, size: 28),
                        ),
                      ),
                    ),
                    title: Text(trailer.title),
                    subtitle: Text(trailer.duration),
                    trailing: const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
                    onTap: () => _showActionMessage('Playing trailer: ${trailer.title}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DetailActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const _DetailActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
