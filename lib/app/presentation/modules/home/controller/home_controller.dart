import '../../../../domain/enums.dart';
import '../../../../domain/repositories/trending_repository.dart';
import '../../../global/state_notifier.dart';
import 'state/home_state.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController({
    required this.trendingRepository,
  }) : super(HomeState());
  final TrendingRepository trendingRepository;
  Future<void> init() async {
    await loadMoviesAndSeries();
    await loadPerformers();
  }

  Future<void> loadMoviesAndSeries({
    MoviesAndSeriesState? moviesAndSeries,
  }) async {
    if (moviesAndSeries != null) {
      state = state.copyWith(
        moviesAndSeries: moviesAndSeries,
      );
    }

    final result = await trendingRepository.getMoviesAndSeries(
      state.moviesAndSeries.timeWindow,
    );
    state = result.when(
      left: (_) => state.copyWith(
        moviesAndSeries:
            MoviesAndSeriesState.failed(state.moviesAndSeries.timeWindow),
      ),
      right: (list) => state.copyWith(
        moviesAndSeries: MoviesAndSeriesState.loaded(
          timeWindow: state.moviesAndSeries.timeWindow,
          list: list,
        ),
      ),
    );
  }

  Future<void> loadPerformers({PerformerState? performers}) async {
    if (performers != null) {
      state = state.copyWith(performers: performers);
    }
    final performersResult = await trendingRepository.getPerformers();
    state = performersResult.when(
      left: (_) => state.copyWith(
        performers: const PerformerState.failed(),
      ),
      right: (list) => state.copyWith(
        performers: PerformerState.loaded(list),
      ),
    );
  }

  void onTimeWindowsChanged(TimeWindow timeWindow) {
    if (state.moviesAndSeries.timeWindow != timeWindow) {
      state = state.copyWith(
        moviesAndSeries: MoviesAndSeriesState.loading(timeWindow),
      );
      loadMoviesAndSeries();
    }
  }
}
