import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kczwifilocation/services/wifi_loc_service.dart';
import 'package:latlong/latlong.dart';

class MapTab extends StatefulWidget {

  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {

  WifiLocService _wifiLocService;
  List<Marker> markers = List();

  @override
  void initState() {
    super.initState();
    markers.add(new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(51.5, -0.09),
      builder: (ctx) => new Container(
        child: new FlutterLogo(),
      ),
    ));
    _wifiLocService = WifiLocService.fromDefaults();
    _wifiLocService.getAllNetworks().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FlutterMap(
          options: new MapOptions(
            center: LatLng(51.5, -0.09),
            zoom: 13.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            new MarkerLayerOptions(
              markers: markers,
            ),
          ],
        ),
      ),
    );
  }
}
