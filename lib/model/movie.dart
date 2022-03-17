// Our movie model
class Movie {
  final int id, year, numOfRatings, criticsReview, metascoreRating;
  final double rating;
  final List<String> genra;
  final String plot, title, poster, backdrop;
  final List<Map> cast;

  Movie({
    this.poster,
    this.backdrop,
    this.title,
    this.id,
    this.year,
    this.numOfRatings,
    this.criticsReview,
    this.metascoreRating,
    this.rating,
    this.genra,
    this.plot,
    this.cast,
  });
}

// our demo data movie data

