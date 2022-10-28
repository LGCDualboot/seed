
import 'package:app/utils/http/server_data.dart';
import 'package:app/utils/http/server_error.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

extension DioWrapper on Dio {
  Future<Either<ServerError, ServerData>> simpleGet<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await get<T>(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

      return Right(ServerData(response.data));
    } on DioError catch (e) {
      Logger().e(
        "ERROR ON SIMPLE GET\n$path",
        e.response?.data.toString(),
      );

      if (e.response == null) {
        return Left(ServerError(statusCode: 0000, message: e.error));
      }

      return Left(ServerError(statusCode: e.response!.statusCode!,message: e.response!.statusMessage ?? "No status message"));
    }
  }

  Future<Either<ServerError, ServerData>> simplePost<T>(
      String path, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await post<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

      return Right(ServerData(response.data));
    } on DioError catch (e) {
      Logger().e("ERROR ON SIMPLE POST $path",
          "Status code:${e.response?.statusCode}\n\n${e.response?.data.toString()}\n\n$data\n\n Headers: ${e.requestOptions.headers}");

      if (e.response == null) {
        return Left(ServerError(statusCode: 0000, message: e.error));
      }

      return Left(ServerError(statusCode: e.response!.statusCode!,message: e.response!.statusMessage ?? "No status message"));    }
  }

  Future<Either<ServerError, ServerData>> simplePut<T>(
      String path, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await put<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

      return Right(ServerData(response.data));
    } on DioError catch (e) {
      Logger().e(
          "ERROR ON SIMPLE PUT $path", "${e.response?.data.toString()}\n$data");

      if (e.response == null) {
        return Left(ServerError(statusCode: 0000, message: e.error));
      }

      return Left(ServerError(statusCode: e.response!.statusCode!,message: e.response!.statusMessage ?? "No status message"));    }
  }

  Future<Either<ServerError, ServerData>> simplePatch<T>(
      String path, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await patch<T>(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);


      return Right(ServerData(response.data));
    } on DioError catch (e) {

      if (e.response == null) {
        return Left(ServerError(statusCode: 0000, message: e.error));
      }

      return Left(ServerError(statusCode: e.response!.statusCode!,message: e.response!.statusMessage ?? "No status message"));    }
  }

  Future<Either<ServerError, ServerData>> simpleDelete<T>(
      String path, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await delete<T>(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken);

      return Right(ServerData(response.data));
    } on DioError catch (e) {
      if (e.response == null) {
        return Left(ServerError(statusCode: 0000, message: e.error));
      }

      return Left(ServerError(statusCode: e.response!.statusCode!,message: e.response!.statusMessage ?? "No status message"));
    }
  }
}