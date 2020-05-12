import 'package:kczwifilocation/api/models/network.dart';
import 'package:kczwifilocation/api/models/network_filter.dart';
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

  Future<Network> findNetworkByMac(String mac) async  {
    NetworkFilter networkFilter = NetworkFilter(mac: mac);
    var result = await wifiLocAPI.getNetworks(networkFilter: networkFilter);
    if(result.length > 0)
      return result.elementAt(0);
    else
      return null;
  }

}