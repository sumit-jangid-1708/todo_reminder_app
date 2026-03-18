// lib/data/app_exceptions.dart

/// Base exception class
sealed class AppException implements Exception {
  const AppException(this.messageKey);

  final String messageKey;

  String get cleanMessage {
    return messageKey.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  @override
  String toString() => 'AppException: $messageKey';
}

/// No internet connection
final class InternetException extends AppException {
  const InternetException() : super('internet_exception');
}

/// Request timeout
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException() : super('request_timeout');
}

/// Failed to fetch data (404, unknown errors)
final class FetchDataException extends AppException {
  const FetchDataException([String? key]) : super(key ?? 'fetch_error');
}

/// Bad request (400)
final class BadRequestException extends AppException {
  const BadRequestException([String? key]) : super(key ?? 'bad_request');
}

/// Unauthorized (401, 403)
final class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('unauthorized'); // ✅ Fixed
}

/// Server error (500+)
final class ServerException extends AppException {
  const ServerException([String? key]) : super(key ?? 'server_error');
}