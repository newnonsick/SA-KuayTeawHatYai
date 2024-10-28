import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    BaseOptions options = BaseOptions(
        // baseUrl: dotenv.env['APIURL']!,
        baseUrl: 'http://localhost:5000/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
        });

    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  // GET Request with Headers
  Future<dynamic> getData(String endpoint,
      {Map<String, dynamic>? headers}) async {
    try {
      Response response = await _dio.get(
        endpoint,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      print('GET request failed: ${e.message}');
      throw Exception('Failed to get data');
    }
  }

  // POST Request with Headers
  Future<dynamic> postData(String endpoint, Map<String, dynamic> data,
      {Map<String, dynamic>? headers}) async {
    try {
      Response response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      print('POST request failed: ${e.message}');
      throw Exception('Failed to post data');
    }
  }

  // PUT Request with Headers
  Future<dynamic> putData(String endpoint, Map<String, dynamic> data,
      {Map<String, dynamic>? headers}) async {
    try {
      Response response = await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      print('PUT request failed: ${e.message}');
      throw Exception('Failed to put data');
    }
  }

  // DELETE Request with Headers
  Future<dynamic> deleteData(String endpoint,
      {Map<String, dynamic>? headers, Map<String, dynamic>? data}) async {
    try {
      Response response = await _dio.delete(
        endpoint,
        data: data ?? {},
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      print('DELETE request failed: ${e.message}');
      throw Exception('Failed to delete data');
    }
  }
}
