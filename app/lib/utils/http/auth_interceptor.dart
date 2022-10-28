import 'package:app/data/data_providers/authentication_api.dart';
import 'package:app/utils/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = GetIt.instance.get<String>(instanceName: "token");

    if (token.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $token";
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

    var options = err.response!.requestOptions;

    final getIt = GetIt.instance;

    final refreshToken = getIt.get<String>(instanceName: "refreshToken");

    () async {
      final response =
          await GetIt.instance.get<AuthenticationApi>().refreshToken(refreshToken);

      if (response.isLeft) {
        super.onError(err, handler);
        return;
      }

      final newToken = response.right.data["access_token"];
      final newRefreshToken = response.right.data["refresh_token"];

      getIt.registerSingleton<String>(newToken ?? "", instanceName: "token");
      getIt.registerSingleton<String>(newRefreshToken ?? "",
          instanceName: "refreshToken");

      await getIt<ISecureStorage>().write("token", newToken);
      await getIt<ISecureStorage>().write("refreshToken", newRefreshToken);

      getIt<Dio>().fetch(options).then((r) {
        handler.resolve(r);
      }).catchError((e) {
        handler.reject(e);
      });
    }();
  }
}
