import 'package:kczwifilocation/models/wifi_network_info.dart';
import 'package:wifi_hunter/wifi_hunter.dart';

class WifiFinderService {

  List<WifiNetworkInfo> networkList = new List();

  WifiFinderService();

  Future<List<WifiNetworkInfo>> getWifiList() async {
    final response = await WiFiHunter.huntRequest;

    response.ssids.asMap().forEach((index, value) {
        WifiNetworkInfo networkInfo = WifiNetworkInfo();
        networkInfo.ssid = value;
        networkInfo.bssid = response.bssids.elementAt(index);
        networkInfo.capabilites = response.capabilities.elementAt(index);
        networkInfo.frequency = response.frequenies.elementAt(index);
        networkInfo.signalStrength = response.signalStrengths.elementAt(index);
        networkList.add(networkInfo);
      });

    return networkList;
  }
}