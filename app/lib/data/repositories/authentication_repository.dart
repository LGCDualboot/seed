import 'dart:async';

import 'package:app/data/data_providers/authentication_api.dart';
import 'package:app/data/models/user.dart';
import 'package:app/utils/http/server_data.dart';
import 'package:app/utils/http/server_error.dart';
import 'package:app/utils/secure_storage.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

class AuthenticationRepository {
  final AuthenticationApi _authenticationApi;

  const AuthenticationRepository(this._authenticationApi);

  Future<Either<ServerError, ServerData>> logout() async {
    return await _authenticationApi.logout();
  }

  Future<Either<ServerError, User>> login(
      String userName, String password) async {
    final data = await _authenticationApi.login(userName, password);

    if (data.isLeft) {
      return Left(data.left);
    }

    final response = data.right;

    final token = response.data['access_token'];
    final refreshToken = response.data['refresh_token'];
    final tokenTime = response.data['expires_in'];

    final user = User.fromJson(response.data);

    final getIt = GetIt.instance;

    await getIt.get<ISecureStorage>().write("tokenTime",tokenTime.toString());
    await getIt.get<ISecureStorage>().write("lastSessionToken", DateTime.now().toIso8601String());

    await getIt.get<ISecureStorage>().write("token", token);
    getIt.registerSingleton<String>(token, instanceName: "token");
    await getIt.get<ISecureStorage>().write("refreshToken", refreshToken);
    getIt.registerSingleton<String>(refreshToken, instanceName: "refreshToken");

    return Right(user);
  }

  Future<Either<ServerError, User?>> checkForLoggedInUser() async {
    final tokenData = await _authenticationApi.checkForLoggedInUser();

    if (tokenData.isLeft) {
      return Left(tokenData.left);
    }

    final getIt = GetIt.instance;

    final token = tokenData.right;

    //If token is expired return null
    final int tokenTime =
        int.parse(await getIt.get<ISecureStorage>().read("tokenTime") ?? "0"); //Sec

    final currentTime = DateTime.now();
    final DateTime lastSessionTime = DateTime.parse(
        await getIt.get<ISecureStorage>().read("lastSessionTime") ??
            DateTime.now().toIso8601String());

    final bool isExpired = currentTime.difference(lastSessionTime).inSeconds > tokenTime;

    if(isExpired){
      return const Right(null);
    }

    if (token) {
      // If token is true, we have to make a request to the backend to get the data of the user
      final response = await _authenticationApi.getAuthUserInfo();

      if (response.isLeft) {
        return const Right(null);
      }

      final data = response.right.data;

      final userData = User.fromJson(data);

      return Right(userData);
    }

    return const Right(null);
  }

  Future<Either<ServerError, ServerData>> getProfileData() {
    return _authenticationApi.getAuthUserInfo();
  }
}
