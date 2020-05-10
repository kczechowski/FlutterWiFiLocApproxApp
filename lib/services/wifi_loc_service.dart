import 'package:kczwifilocation/api/models/network.dart';
import 'package:kczwifilocation/api/wifi_loc_api.dart';
import 'package:http/http.dart' as http;

class WifiLocService {

  WifiLocAPI wifiLocAPI;

  WifiLocService({WifiLocAPI api}) {
    if(api != null)
      this.wifiLocAPI = api;
    else {
      this.wifiLocAPI = WifiLocAPI(httpClient: http.Client());
    }
  }

  Future<List<Network>> getAllNetworks() {
    return wifiLocAPI.getNetworks();
  }
}