import 'package:http/http.dart' as http;

class WifiLocAPI {
  final _baseUrl = 'http://localhost:8080';
  final http.Client httpClient;
  WifiLocAPI({this.httpClient});
}