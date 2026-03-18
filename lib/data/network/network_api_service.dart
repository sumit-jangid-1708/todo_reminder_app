// lib/data/network/network_api_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../app_exceptions.dart';
import '../storage/token_storage.dart';
import 'base_api_service.dart';

class NetworkApiService implements BaseApiService {
  final TokenStorage _tokenStorage = TokenStorage();

  static const Duration _timeout = Duration(seconds: 20);

  /// Build headers with auth token
  Future<Map<String, String>> _buildHeaders({
    Map<String, String>? extra,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (extra != null) {
      headers.addAll(extra);
    }

    return headers;
  }

  @override
  Future<T> getApi<T>(
      String url, {
        Map<String, String>? headers,
      }) async {
    if (kDebugMode) {
      debugPrint('🌐 GET Request URL: $url');
    }

    try {
      final mergedHeaders = await _buildHeaders(extra: headers);

      final response = await http
          .get(Uri.parse(url), headers: mergedHeaders)
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } on SocketException {
      throw const InternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } catch (e) {
      debugPrint('❌ GET Request Error: $e');
      rethrow;
    }
  }

  @override
  Future<T> postApi<T>(
      String url,
      Object data, {
        Map<String, String>? headers,
      }) async {
    if (kDebugMode) {
      debugPrint('🌐 POST Request URL: $url');
      debugPrint('🌐 POST Request Body: $data');
    }

    try {
      final mergedHeaders = await _buildHeaders(extra: headers);

      final response = await http
          .post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: mergedHeaders,
      )
          .timeout(_timeout);

      if (kDebugMode) {
        debugPrint('🌐 API Response Status Code: ${response.statusCode}');
      }

      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/pdf')) {
        return response.bodyBytes as T;
      }

      return _handleResponse<T>(response);
    } on SocketException {
      throw const InternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } catch (e) {
      debugPrint('❌ POST Request Error: $e');
      rethrow;
    }
  }

  @override
  Future<T> putApi<T>(
      String url,
      Object data, {
        Map<String, String>? headers,
      }) async {
    if (kDebugMode) {
      debugPrint('🌐 PUT Request URL: $url');
      debugPrint('🌐 PUT Request Body: $data');
    }

    try {
      final mergedHeaders = await _buildHeaders(extra: headers);

      final response = await http
          .put(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: mergedHeaders,
      )
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } on SocketException {
      throw const InternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } catch (e) {
      debugPrint('❌ PUT Request Error: $e');
      rethrow;
    }
  }

  @override
  Future<T> deleteApi<T>(
      String url, {
        Map<String, String>? headers,
      }) async {
    if (kDebugMode) {
      debugPrint('🌐 DELETE Request URL: $url');
    }

    try {
      final mergedHeaders = await _buildHeaders(extra: headers);

      final response = await http
          .delete(Uri.parse(url), headers: mergedHeaders)
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } on SocketException {
      throw const InternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } catch (e) {
      debugPrint('❌ DELETE Request Error: $e');
      rethrow;
    }
  }

  @override
  Future<T> multipartApi<T>(
      String url,
      Map<String, String> fields, {
        File? file,
        String fileField = 'file',
      }) async {
    if (kDebugMode) {
      debugPrint('🌐 MULTIPART POST: $url');
      debugPrint('🌐 Fields: $fields');
      debugPrint('🌐 File: ${file?.path}');
    }

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      final token = await _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(fields);

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fileField,
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse<T>(response);
    } on SocketException {
      throw const InternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } catch (e) {
      debugPrint('❌ Multipart Request Error: $e');
      rethrow;
    }
  }

  T _handleResponse<T>(http.Response response) {
    if (kDebugMode) {
      debugPrint('🌐 Status: ${response.statusCode}');
      debugPrint('🌐 Body: ${response.body}');
    }

    final Map<String, dynamic> decoded = _tryDecodeJson(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return decoded as T;

      case 400:
        final message = decoded['message'] as String? ?? 'bad_request';
        throw BadRequestException(message);

      case 401:
      case 403:
        throw UnauthorizedException();

      case 404:
        final message = decoded['message'] as String? ?? 'not_found';
        throw FetchDataException(message);

      case 500:
      case 502:
      case 503:
        final message = decoded['message'] as String? ?? 'server_error';
        throw ServerException(message);

      default:
        final message = decoded['message'] as String? ?? 'unknown_error';
        throw FetchDataException(message);
    }
  }

  Map<String, dynamic> _tryDecodeJson(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}