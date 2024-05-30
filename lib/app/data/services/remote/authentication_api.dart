import '../../../domain/either/either.dart';
import '../../../domain/failures/sign_in/sign_in_failure.dart';
import '../../http/http.dart';

class AuthenticationAPI {
  const AuthenticationAPI(this._http);

  final Http _http;

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode!) {
        case 401:
          if (failure.data is Map &&
              (failure.data as Map)['status_code'] == 32) {
            return Either.left(SignInFailure.notVerified());
          }
          return Either.left(SignInFailure.unauthorized());
        case 404:
          return Either.left(SignInFailure.notFound());
        default:
          return Either.left(SignInFailure.unknow());
      }
    }

    if (failure.exception is NetworkException) {
      return Either.left(SignInFailure.network());
    }

    return Either.left(SignInFailure.unknow());
  }

  /// Crear token de inicio
  Future<Either<SignInFailure, String>> createdRequestToken() async {
    final result = await _http.request(
      '/authentication/token/new',
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['request_token'] as String;
      },
    );
    return result.when(
      left: _handleFailure,
      right: (requestToken) => Either.right(requestToken),
    );
  }

  /// Inicio de sesión
  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['request_token'] as String;
      },
      method: HttpMethod.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );

    return result.when(
      left: _handleFailure,
      right: (requestToken) => Either.right(requestToken),
    );
  }

  Future<Either<SignInFailure, String>> createSession(
    String requestToken,
  ) async {
    final result = await _http.request(
      '/authentication/session/new',
      method: HttpMethod.post,
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['session_id'] as String;
      },
      body: {
        'request_token': requestToken,
      },
    );

    return result.when(
      left: _handleFailure,
      right: (sessionId) => Either.right(sessionId),
    );
  }
}
