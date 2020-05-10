class APIException implements Exception {
  final String message;
  final int statusCode;

  APIException(this.message, this.statusCode);

  String toString() {
    if (message == null) return "API Exception";
    return "API Exception ($statusCode): $message";
  }
}
