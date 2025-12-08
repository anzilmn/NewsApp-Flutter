// lib/core/error/exceptions.dart

// Base custom exception class
class CustomException implements Exception {
  final String message;
  const CustomException({this.message = 'An unknown error occurred.'});

  @override
  String toString() => 'CustomException: $message';
}

// Specific exception for API or HTTP errors
class ServerException extends CustomException {
  const ServerException({super.message = 'Failed to communicate with the server.'});
}

// Specific exception for local data/cache errors
class CacheException extends CustomException {
  const CacheException({super.message = 'Failed to read or write to local storage.'});
}