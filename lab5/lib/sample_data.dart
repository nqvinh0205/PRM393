class Trailer {
  final String title;
  final String duration;
  final String thumbnailUrl;

  Trailer({
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
  });
}

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    this.isFavorite = false,
  });
}

final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Midnight Legacy',
    posterUrl:
        'https://images.unsplash.com/photo-1517602302552-471fe67acf66?auto=format&fit=crop&w=900&q=80',
    overview:
        'A retired spy must return to the field when an old adversary resurfaces with a secret that could change the world.',
    genres: ['Action', 'Thriller', 'Adventure'],
    rating: 8.5,
    trailers: [
      Trailer(
        title: 'Official Trailer',
        duration: '2:18',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=280&q=80',
      ),
      Trailer(
        title: 'Behind the Scenes',
        duration: '1:34',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1516175604930-6e6d6b1e9cd7?auto=format&fit=crop&w=280&q=80',
      ),
    ],
  ),
  Movie(
    id: 2,
    title: 'Aurora Skies',
    posterUrl:
        'https://images.unsplash.com/photo-1522199710521-72d69614c702?auto=format&fit=crop&w=900&q=80',
    overview:
        'In a world where the aurora lights hold a hidden message, a young scientist teams up with a pilot to decode the skies.',
    genres: ['Drama', 'Sci-Fi', 'Mystery'],
    rating: 7.9,
    trailers: [
      Trailer(
        title: 'First Look',
        duration: '2:05',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=280&q=80',
      ),
      Trailer(
        title: 'Director Commentary',
        duration: '3:10',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=280&q=80',
      ),
    ],
  ),
  Movie(
    id: 3,
    title: 'City of Mirrors',
    posterUrl:
        'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d?auto=format&fit=crop&w=900&q=80',
    overview:
        'When a detective discovers a hidden world reflected in city windows, she must solve the greatest case of her career.',
    genres: ['Crime', 'Mystery', 'Drama'],
    rating: 8.1,
    trailers: [
      Trailer(
        title: 'Teaser',
        duration: '1:12',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=280&q=80',
      ),
      Trailer(
        title: 'Extended Preview',
        duration: '2:44',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1516175604930-6e6d6b1e9cd7?auto=format&fit=crop&w=280&q=80',
      ),
    ],
  ),
];
