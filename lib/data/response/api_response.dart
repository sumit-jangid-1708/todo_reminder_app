// lib/data/response/api_response.dart

import 'package:todo_reminder/data/response/status.dart';

/// Immutable API response wrapper
sealed class ApiResponse<T> {
  const ApiResponse._();

  const factory ApiResponse.loading() = LoadingResponse<T>;
  const factory ApiResponse.completed(T data) = CompletedResponse<T>;
  const factory ApiResponse.error(String message) = ErrorResponse<T>;

  Status get status;
  T? get data => null;
  String? get message => null;

  @override
  String toString() => 'Status: $status | Message: $message | Data: $data';
}

final class LoadingResponse<T> extends ApiResponse<T> {
  const LoadingResponse() : super._();

  @override
  Status get status => Status.loading;
}

final class CompletedResponse<T> extends ApiResponse<T> {
  const CompletedResponse(this._data) : super._();

  final T _data;

  @override
  Status get status => Status.completed;

  @override
  T get data => _data;
}

final class ErrorResponse<T> extends ApiResponse<T> {
  const ErrorResponse(this._message) : super._();

  final String _message;

  @override
  Status get status => Status.error;

  @override
  String get message => _message;
}