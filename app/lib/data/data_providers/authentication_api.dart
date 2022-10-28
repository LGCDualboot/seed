import 'package:app/utils/extensions.dart';
import 'package:app/utils/http/server_data.dart';
import 'package:app/utils/http/server_error.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';


abstract class IAuthenticationApi {
  Future<Either<ServerError, ServerData>> login(
      String userName, String password);
  Future<Either<ServerError, bool>> checkForLoggedInUser();
  Future<Either<ServerError, ServerData>> getAuthUserInfo();
  Future<Either<ServerError, ServerData>> logout();
  Future<Either<ServerError, ServerData>> refreshToken(String refreshToken);
}

class AuthenticationApi implements IAuthenticationApi {
  final Dio _dio;

  const AuthenticationApi(this._dio);

  @override
  Future<Either<ServerError, ServerData>> login(
      String userName, String password) async {
    return await _dio.simplePost(
      '/connect/token',
      data: {
        'userName': userName,
        'password': password
      },
    );
  }


  @override
  Future<Either<ServerError, ServerData>> getAuthUserInfo() {
    return _dio.simpleGet("/api/account/my-profile");
  }

  @override
  Future<Either<ServerError, bool>> checkForLoggedInUser() async {
    try {
      final token = GetIt.I.get<String>(instanceName: "token");
      return token.isEmpty ? const Right(false) : const Right(true);
    } catch (e) {
      return const Left(
          ServerError(statusCode: 0000, message: "Internal error - token"));
    }
  }

  @override
  Future<Either<ServerError, ServerData>> logout() {
    return _dio.simpleGet(
      '/api/account/logout',
    );
  }

  @override
  Future<Either<ServerError, ServerData>> refreshToken(String refreshToken) async {
    return await _dio.simplePost(
      '/connect/token',
      data: {
        'refresh_token':refreshToken
      });
  }
}
