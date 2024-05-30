import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/app/data/http/http.dart';
import 'package:tv/app/data/repositories_implementation/account_repository_impl.dart';
import 'package:tv/app/data/services/local/languaje_service.dart';
import 'package:tv/app/data/services/local/session_service.dart';
import 'package:tv/app/data/services/remote/account_api.dart';
import 'package:tv/app/domain/failures/http_request/http_request_failure.dart';
import 'package:tv/app/domain/models/media/media.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockClient client;
  late MockFlutterSecureStorage secureStorage;
  late AccountRepositoryimpl repository;

  setUp(
    () {
      client = MockClient();
      secureStorage = MockFlutterSecureStorage();
      final sessionService = SessionService(
        secureStorage,
      );
      when(
        secureStorage.read(
          key: anyNamed('key'),
        ),
      ).thenAnswer(
        (_) async => 'lalala',
      );
      final accountAPI = AccountAPI(
        Http(
          client: client,
          baseUrl: 'https://api.themoviedb.org/3',
          apiKey: '541a236fbc4bb835c29b84fecee88218',
        ),
        sessionService,
        LanguageService('en'),
      );

      repository = AccountRepositoryimpl(
        accountAPI,
        sessionService,
      );
    },
  );

  void mockGet({
    required int statusCode,
    required Map<String, dynamic> json,
  }) {
    when(
      client.get(
        any,
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => Response(
        jsonEncode(json),
        statusCode,
      ),
    );
  }

  test(
    'AccountRepositoryImpl > getUserData',
    () async {
      when(
        secureStorage.read(key: sessionIdKey),
      ).thenAnswer(
        (_) => Future.value('sessionId'),
      );

      mockGet(
        json: {
          'id': 123,
          'username': 'sm',
          'avatar': {},
        },
        statusCode: 200,
      );

      final user = await repository.getUserData();
      expect(user, isNotNull);
    },
  );

  test(
    'AccountRepositoryImpl > getFavorites > fail',
    () async {
      mockGet(
        statusCode: 401,
        json: {
          'status_code': 3,
          'status_message': '',
        },
      );

      final result = await repository.getFavorites(
        Mediatype.movie,
      );
      // expect(result.value is HttpRequestFailure, true);
      expect(result.value, isA<HttpRequestFailure>());
    },
  );

  test(
    'AccountRepositoryImpl > getFavorites > success',
    () async {
      mockGet(
        statusCode: 200,
        json: {
          'page': 1,
          'results': [
            {
              'adult': false,
              'backdrop_path': '/2OMB0ynKlyIenMJWI2Dy9IWT4c.jpg',
              'genre_ids': [10765, 18, 10759],
              'id': 1399,
              'origin_country': ['US'],
              'original_language': 'en',
              'original_name': 'Game of Thrones',
              'overview': '',
              'popularity': 316.756,
              'poster_path': '/7WUHnWGx5OO145IRxPDUkQSh4C7.jpg',
              'first_air_date': '2011-04-17',
              'name': 'Game of Thrones',
              'vote_average': 8.436,
              'vote_count': 21000
            }
          ],
          'total_pages': 4,
          'total_results': 68
        },
      );

      final result = await repository.getFavorites(
        Mediatype.movie,
      );
      // expect(result.value is HttpRequestFailure, true);
      expect(
        result.value,
        isA<Map<int, Media>>(),
      );
    },
  );

  test(
    'AccountRepositoryImpl > maskAsFavorite > success',
    () async {
      when(
        client.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => Response(
          jsonEncode(
            {
              'status_code': 1,
              'status_message': '',
            },
          ),
          200,
        ),
      );
      final result = await repository.markAsFavorite(
        mediaId: 123,
        type: Mediatype.movie,
        favorite: true,
      );

      expect(
        result.value is! HttpRequestFailure,
        true,
      );
    },
  );

  test(
    'AccountRepositoryImpl > maskAsFavorite > fail',
    () async {
      when(
        client.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => Response(
          jsonEncode(
            {
              'status_code': 34,
              'status_message': '',
            },
          ),
          404,
        ),
      );
      final result = await repository.markAsFavorite(
        mediaId: 123,
        type: Mediatype.movie,
        favorite: true,
      );

      // print(result.value);

      expect(
        result.value is HttpRequestFailure,
        true,
      );
    },
  );
}
