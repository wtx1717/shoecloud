/// 封装 Dio，并为各仓储统一请求行为。
import 'package:dio/dio.dart';
import 'package:shoecloud/core/constants/app_constants.dart';
import 'package:shoecloud/core/storage/session_storage.dart';

class ApiClient {
  ApiClient(this._sessionStorage) {
    _dio.options
      ..baseUrl = AppConstants.baseUrl
      ..connectTimeout = const Duration(seconds: AppConstants.timeoutSeconds)
      ..sendTimeout = const Duration(seconds: AppConstants.timeoutSeconds)
      ..receiveTimeout = const Duration(seconds: AppConstants.timeoutSeconds);
    _dio.interceptors.add(_buildInterceptors());
  }

  final SessionStorage _sessionStorage;
  final Dio _dio = Dio();

  InterceptorsWrapper _buildInterceptors() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_sessionStorage.token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${_sessionStorage.token}';
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? params}) {
    return _handle(_dio.get(path, queryParameters: params));
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? params}) {
    return _handle(_dio.post(path, data: params));
  }

  Future<dynamic> _handle(Future<Response<dynamic>> request) async {
    try {
      final response = await request;
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return data;
      }

      if (data['code'] == AppConstants.successCode) {
        return data['result'];
      }

      throw Exception(data['msg'] ?? 'Request failed');
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
