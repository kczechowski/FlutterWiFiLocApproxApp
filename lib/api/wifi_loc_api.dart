import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kczwifilocation/api/models/network.dart';

class WifiLocAPI {
  final _baseUrl = 'http://10.0.2.2:8080';
  final http.Client httpClient;

  WifiLocAPI({this.httpClient});

  Future<List<Network>> getNetworks() async {
    List<Network> networkCollection = List();

    final response = await http.get(this._baseUrl + '/networks/');

    if (response.statusCode == 200) {
      List<dynamic> networks = json.decode(response.body);
      networks.forEach((element) {
        networkCollection.add(Network.fromJson(element));
      });
    } else {
      throw Exception('Api error');
    }

    return networkCollection;
  }
}
