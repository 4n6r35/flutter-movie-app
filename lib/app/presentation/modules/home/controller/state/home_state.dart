import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/enums.dart';
import '../../../../../domain/models/media/media.dart';
import '../../../../../domain/models/performer/performer.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(MoviesAndSeriesState.loading(TimeWindow.day))
        MoviesAndSeriesState moviesAndSeries,
    @Default(PerformerState.loading()) PerformerState performers,
  }) = _HomeState;
}

@freezed
class MoviesAndSeriesState with _$MoviesAndSeriesState {
  const factory MoviesAndSeriesState.loading(TimeWindow timeWindow) =
      MoviesAndSeriesStateLoading;
  const factory MoviesAndSeriesState.failed(TimeWindow timeWindow) =
      MoviesAndSeriesStateFailure;
  const factory MoviesAndSeriesState.loaded({
    required TimeWindow timeWindow,
    required List<Media> list,
  }) = MoviesAndSeriesStateLoaded;
}

@freezed
class PerformerState with _$PerformerState {
  const factory PerformerState.loading() = _PerformerStateLoading;
  const factory PerformerState.failed() = _PerformerStateFailed;
  const factory PerformerState.loaded(List<Performer> list) =
      _PerformerStateLoaded;
}
