class ApiException implements Exception {
  final String message;
  final int statuscode;

  ApiException({required this.message, required this.statuscode});
}

class CacheException implements Exception {
  final String? message;

  CacheException([this.message]);
}

class UnknownException implements Exception {
  final String? message;

  UnknownException([this.message]);
}
