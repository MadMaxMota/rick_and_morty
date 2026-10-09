import 'package:dio/dio.dart';
import 'package:rick_and_morty/data/data_sources/remote/clients/http_exception_handler.dart';

class HttpClient with HttpExceptionHandler {
  final Dio _dio;

  HttpClient({required Dio dio}) : _dio = dio;

  Future<Response<T>> get<T>(String path, {dynamic queryParameters}) {
    try {
      return _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> post<T>(String path, {dynamic queryParameters}) {
    try {
      return _dio.post<T>(path, data: queryParameters);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> put<T>(String path, {dynamic queryParameters}) {
    try {
      return _dio.put<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> delete<T>(String path, {dynamic queryParameters}) {
    try {
      return _dio.delete<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
