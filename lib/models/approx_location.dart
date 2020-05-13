import 'package:latlong/latlong.dart';

class ApproxLocation {
  double lat;
  double lon;
  double radius;

  ApproxLocation({this.lat, this.lon, this.radius});

  LatLng toLatLng() {
    return LatLng(this.lat, this.lon);
  }
}