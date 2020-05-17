import 'package:kczwifilocation/models/wifi_network_info.dart';
import 'package:latlong/latlong.dart';

class ApproxLocation {
  double lat;
  double lon;
  double radius;
  WifiNetworkInfo relatedNetwork;

  ApproxLocation({this.lat, this.lon, this.radius});

  LatLng toLatLng() {
    return LatLng(this.lat, this.lon);
  }
}