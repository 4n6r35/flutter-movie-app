import '../../../../domain/repositories/movies_repository.dart';
import '../../../global/state_notifier.dart';
import 'state/movie_state.dart';

class MovieController extends StateNotifier<MovieState> {
  MovieController({
    required this.movieId,
    required this.moviesRepository,
  }) : super(MovieState.loading());

  final MoviesRepository moviesRepository;

  final int movieId;

  Future<void> init() async {
    state = MovieState.loading();
    final result = await moviesRepository.getMovieById(movieId);
    state = result.when(
      left: (_) => MovieState.failed(),
      right: (movie) => MovieState.loaded(movie),
    );
  }
}
