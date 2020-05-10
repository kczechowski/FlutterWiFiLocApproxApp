import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kczwifilocation/api/exceptions/api_exception.dart';
import 'package:kczwifilocation/api/exceptions/bad_request_api_exception.dart';
import 'package:kczwifilocation/api/exceptions/internal_server_error_api_exception.dart';
import 'package:kczwifilocation/api/models/network.dart';
import 'package:kczwifilocation/api/models/network_filter.dart';

class WifiLocAPI {
  final _baseUrl = 'http://10.0.2.2:8080';
  final http.Client httpClient;

  WifiLocAPI({this.httpClient});

  _handleExceptions(http.Response response) {
    String message = response.body;
    if (response.statusCode == 400)
      throw new BadRequestAPIException(message);
    else if (response.statusCode == 500)
      throw new InternalServerErrorAPIException(message);
    else
      throw new APIException(message, response.statusCode);
  }

  Future<List<Network>> getNetworks({NetworkFilter networkFilter}) async {
    List<Network> networkCollection = List();

    var url = this._baseUrl + '/networks/';
    if(networkFilter != null) url += '?filter=$networkFilter';

    final response = await http.get(url);

    if (response.statusCode != 200) _handleExceptions(response);

    List<dynamic> networks = json.decode(response.body);
    networks.forEach((element) {
      networkCollection.add(Network.fromJson(element));
    });

    return networkCollection;
  }
}
