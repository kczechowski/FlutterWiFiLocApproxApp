import 'package:kczwifilocation/api/models/network.dart';
import 'package:kczwifilocation/api/models/network_filter.dart';
import 'package:kczwifilocation/api/wifi_loc_api.dart';
import 'package:http/http.dart' as http;
import 'package:kczwifilocation/models/wifi_network_info.dart';
import 'package:kczwifilocation/services/wifi_finder_service.dart';
import 'package:kczwifilocation/models/approx_location.dart';
import 'package:geolocator/geolocator.dart';

class WifiLocService {

  WifiLocAPI wifiLocAPI;
  WifiFinderService wifiFinderService;
  WifiFoundListenerInterface wifiFoundListenerInterface;

  WifiLocService(WifiLocAPI api, WifiFinderService wifiFinderService) {
      this.wifiLocAPI = api;
      this.wifiFinderService = wifiFinderService;
  }

  factory WifiLocService.fromDefaults() {
    return WifiLocService(WifiLocAPI(httpClient: http.Client()), WifiFinderService());
  }

  void addOnFoundListener(WifiFoundListenerInterface wifiFoundListenerInterface) {
    this.wifiFoundListenerInterface = wifiFoundListenerInterface;
  }

  Future<List<Network>> getAllNetworks() async {
    var networks = await wifiLocAPI.getNetworks();
    networks.forEach((network) {
      if(wifiFoundListenerInterface != null)
        wifiFoundListenerInterface.initFoundEvent(network);
    });
    return networks;
  }

  Future<Network> findNetworkByMac(String mac) async  {
    NetworkFilter networkFilter = NetworkFilter(mac: mac);
    var result = await wifiLocAPI.getNetworks(networkFilter: networkFilter);
    if(result.length > 0) {
      return result.elementAt(0);
    }
    else
      return null;
  }

  Future<Network> _getMostPromisingNetwork(String mac) async {
    var networks = await wifiLocAPI.getNetworks(networkFilter: NetworkFilter(mac: mac));

    networks.forEach((element) {
      if (wifiFoundListenerInterface != null)
        wifiFoundListenerInterface.initFoundEvent(element);
    });

    if(networks.length > 0) {
      //sort -> a network from api with the strongest signal is first
      networks.sort((a, b) => b.signalStrength.compareTo(a.signalStrength));
      return networks.elementAt(0);
    }

    return null;
  }

  Future<ApproxLocation> findApproxLocation() async {

    var wifis = await wifiFinderService.getWifiList();

    List<Network> possibleNetworks = List();

    List<Network> networks = await Future.wait(wifis.map((e) => _getMostPromisingNetwork(e.bssid)));

    possibleNetworks.addAll(networks);
    print(possibleNetworks);

    if(possibleNetworks.length > 0) {

      //sort -> a network with the strongest signal is first
      possibleNetworks.sort((a, b) => b.signalStrength.compareTo(a.signalStrength));

      Network closestNetwork = possibleNetworks.elementAt(0);

      var approxLocation = ApproxLocation();
      approxLocation.lon = closestNetwork.lon;
      approxLocation.lat = closestNetwork.lat;
      approxLocation.radius = 10;
      return approxLocation;
    } else return null;

  }

  Future<Null> saveFoundNetworksNearLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var wifis = await wifiFinderService.getWifiList();
    List<Network> networks = List();
    wifis.forEach((element) {
      Network network = Network();
      network.lat = position.latitude;
      network.lon = position.longitude;
      network.mac = element.bssid;
      network.signalStrength = element.signalStrength;
      networks.add(network);
    });

    networks.forEach((network) {
      wifiLocAPI.postNetwork(network);
    });
  }



}

typedef WifiFoundListenerOnFoundClosure = Function(Network network);

class WifiFoundListenerInterface {
  void onFound(WifiFoundListenerOnFoundClosure fn) {}
  void initFoundEvent(Network network) {}
}

class WifiFoundListener implements WifiFoundListenerInterface {

  WifiFoundListenerOnFoundClosure fn;


  WifiFoundListener({this.fn});

  void onFound(WifiFoundListenerOnFoundClosure fn) {
    this.fn = fn;
  }

  void initFoundEvent(Network network) {
    this.fn(network);
  }
}