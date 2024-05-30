import 'package:freezed_annotation/freezed_annotation.dart';

import '../../typedefs.dart';

part 'media.freezed.dart';
part 'media.g.dart';

enum Mediatype {
  @JsonValue('movie')
  movie,
  @JsonValue('tv')
  tv,
}

@freezed
class Media with _$Media {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Media({
    required int id,
    required String overview,
    @JsonKey(readValue: readTitleValue) required String title,
    @JsonKey(readValue: readOriginalTitleValue) required String originalTitle,
    required String posterPath,
    String? backdropPath,
    required double voteAverage,
    @JsonKey(name: 'media_type') required Mediatype type,
  }) = _Media;

  factory Media.fromJson(Json json) => _$MediaFromJson(json);
}

Object? readTitleValue(Map map, String _) => map['title'] ?? map['name'];

Object? readOriginalTitleValue(Map map, String _) =>
    map['original_title'] ?? map['original_name'];

List<Media> getMediaList(List list) {
  return list
      .where(
        (e) =>
            e['media_type'] != 'person' &&
            e['poster_path'] != null &&
            e['backdrop_path'] != null,
      )
      .map((e) => Media.fromJson(e))
      .toList();
}
