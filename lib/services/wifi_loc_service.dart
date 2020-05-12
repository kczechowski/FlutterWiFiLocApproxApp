import 'package:kczwifilocation/api/models/network.dart';
import 'package:kczwifilocation/api/models/network_filter.dart';
import 'package:kczwifilocation/api/wifi_loc_api.dart';
import 'package:http/http.dart' as http;
import 'package:kczwifilocation/services/wifi_finder_service.dart';

class WifiLocService {

  WifiLocAPI wifiLocAPI;
  WifiFinderService wifiFinderService;

  WifiLocService({WifiLocAPI api, WifiFinderService wifiFinderService}) {
    if(api != null)
      this.wifiLocAPI = api;
    else {
      this.wifiLocAPI = WifiLocAPI(httpClient: http.Client());
    }
    if(wifiFinderService != null)
      this.wifiFinderService = wifiFinderService;
    else {
      this.wifiFinderService = WifiFinderService();
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