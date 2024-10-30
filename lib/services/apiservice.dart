import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ApiService {
  late Dio _dio;
  String secretKey = "[r,7?~XPYRZ>~t:weYk}=OY=lY+%q?GL";

  ApiService() {
    BaseOptions options = BaseOptions(
        // baseUrl: dotenv.env['APIURL']!,
        baseUrl: 'https://kuayteawhatyai-backend.onrender.com/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': generateToken(),
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

  /// Generates a token using timestamp + secret key
  String generateToken({int? timePrevious}) {
    int timestamp =
        timePrevious ?? DateTime.now().millisecondsSinceEpoch ~/ 2000;
    String rawToken = '$timestamp$secretKey';

    // Generate the SHA-256 hash of the token
    var bytes = utf8.encode(rawToken);
    var tokenHash = sha256.convert(bytes).toString();

    return tokenHash;
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
