// lib/data/network/base_api_service.dart
import 'dart:io';

abstract class BaseApiService {
  /// Generic GET request
  Future<T> getApi<T>(
      String url, {
        Map<String, String>? headers,
      });

  /// Generic POST request
  Future<T> postApi<T>(
      String url,
      Object data, {
        Map<String, String>? headers,
      });

  /// Generic PUT request (for updates)
  Future<T> putApi<T>(
      String url,
      Object data, {
        Map<String, String>? headers,
      });

  /// Generic DELETE request
  Future<T> deleteApi<T>(
      String url, {
        Map<String, String>? headers,
      });

  /// Multipart request with file upload
  Future<T> multipartApi<T>(
      String url,
      Map<String, String> fields, {
        File? file,
        String fileField = 'file',
      });
}