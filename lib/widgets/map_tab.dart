import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kczwifilocation/services/wifi_loc_service.dart';
import 'package:latlong/latlong.dart';
import 'package:kczwifilocation/widgets/network_marker.dart';

class MapTab extends StatefulWidget {

  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {

  WifiLocService _wifiLocService;
  MapController mapController;
  List<Marker> markers = List();

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    _wifiLocService = WifiLocService.fromDefaults();
//    _wifiLocService.getAllNetworks().then((value) {
////      value.forEach((network) {
////        var marker = NetworkMarker(network.toLatLng());
////        markers.add(marker);
////      });
////    });

    var listener = WifiFoundListener();
    listener.onFound((network) {
      print('Found network: $network');
      var marker = NetworkMarker(network.toLatLng());
      markers.add(marker);
      Fluttertoast.showToast(
          msg: 'Found network: $network',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
      );
    });
    _wifiLocService.addOnFoundListener(listener);

    _wifiLocService.saveFoundNetworksNearLocation();
    mapController.onReady.then((value) {
      _wifiLocService.findApproxLocation().then((location) {
        if(location != null) {
          mapController.move(location.toLatLng(), 18);
          print('Found location: $location');
          Fluttertoast.showToast(
            msg: 'Found location: $location',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          var marker = Marker(width: 100.0,
              height: 100.0,
              point: location.toLatLng(),
              builder: (ctx) =>
              new Container(
                  child: Icon(Icons.location_on, color: Colors.red,)
              ));
          markers.add(marker);
        } else {
          //TODO: location not found
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FlutterMap(
          mapController: mapController,
          options: new MapOptions(
            center: LatLng(50.259224, 19.022285),
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
