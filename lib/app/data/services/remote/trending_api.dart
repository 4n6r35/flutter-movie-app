import '../../../domain/either/either.dart';
import '../../../domain/enums.dart';
import '../../../domain/failures/http_request/http_request_failure.dart';
import '../../../domain/models/media/media.dart';
import '../../../domain/models/performer/performer.dart';
import '../../../domain/typedefs.dart';
import '../../http/http.dart';
import '../local/languaje_service.dart';
import '../utils/handle_failure.dart';

class TrendingAPI {
  final Http _http;
  final LanguageService _languageService;

  TrendingAPI(
    this._http,
    this._languageService,
  );

  Future<Either<HttpRequestFailure, List<Media>>> getMoviesAndSeries(
      TimeWindow timewindow) async {
    final result = await _http.request(
      '/trending/all/${timewindow.name}',
      queryParameters: {
        'language': _languageService.languageCode,
      },
      onSuccess: (json) {
        final list = List<Json>.from(json['results']);
        return getMediaList(list);
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (list) => Either.right(list),
    );
  }

  Future<Either<HttpRequestFailure, List<Performer>>> getPerformers(
      TimeWindow timewindow) async {
    final result = await _http.request(
      '/trending/person/${timewindow.name}',
      queryParameters: {
        'language': _languageService.languageCode,
      },
      onSuccess: (json) {
        final list = List<Json>.from(json['results']);
        return list
            .where(
              (e) =>
                  e['known_for_department'] == 'Acting' &&
                  e['profile_path'] != null,
            )
            .map(
              (e) => Performer.fromJson(e),
            )
            .toList();
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (list) => Either.right(list),
    );
  }
}
