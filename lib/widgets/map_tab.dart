import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kczwifilocation/services/wifi_loc_service.dart';
import 'package:latlong/latlong.dart';
import 'package:kczwifilocation/widgets/network_marker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapTab extends StatefulWidget {

  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> with AutomaticKeepAliveClientMixin<MapTab>{

  WifiLocService _wifiLocService;
  MapController mapController;
  List<Marker> markers = List();
  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    _wifiLocService = WifiLocService.fromDefaults();

    _initWifiFoundListener();

    mapController.onReady.then((value) {
      _findApproxLocation();
    });

    Timer.periodic(Duration(seconds: 20), (timer) {
      _saveFoundNetworksToAPI();
    });

  }

  void _initWifiFoundListener() {
    var listener = WifiFoundListener();
    listener.onFound((network) {
      print('Found network: $network');
      var marker = NetworkMarker(network.toLatLng());

      var markersExists = markers.where((element) =>
      element.runtimeType.toString() == 'NetworkMarker' &&
          element.point.latitude == marker.point.latitude &&
          element.point.longitude == marker.point.longitude);

      if(markersExists.length == 0)
        setState(() {
          markers.add(marker);
        });
      Fluttertoast.showToast(
        msg: 'Found network: $network',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    });
    _wifiLocService.addOnFoundListener(listener);
  }

  void _findApproxLocation() {
    if(progressDialog != null) {
      Timer(Duration(milliseconds: 500), () {
        progressDialog.show();
      });
    }
    setState(() {
      markers.clear();
    });
    _wifiLocService.findApproxLocation().then((location) {
      Timer(Duration(milliseconds: 0), () {
        progressDialog.hide();
      });

      if(location != null) {
        mapController.move(location.toLatLng(), 18);
        String locationFoundMessage = 'Found location: closest to ' +
            location.relatedNetwork.ssid + '\n' + 'lat ' +
            location.lat.toString() + '\nlon ' + location.lon.toString();
        print(locationFoundMessage);
        Fluttertoast.showToast(
          msg: locationFoundMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
        );
        var marker = Marker(width: 100.0,
            height: 100.0,
            point: location.toLatLng(),
            builder: (ctx) =>
            new Container(
                child: Icon(Icons.location_on, color: Colors.red,)
            ));
        setState(() {
          markers.add(marker);
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Location not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
        );
      }
    });
  }

  void _saveFoundNetworksToAPI() {
    SharedPreferences.getInstance().then((prefs) async {
      if(!prefs.containsKey('POST_NETWORKS')) {
        await prefs.setBool('POST_NETWORKS', false);
      }

      bool postNetworks = prefs.getBool('POST_NETWORKS');

      if(postNetworks) {
        Fluttertoast.showToast(
          msg: 'Sending networks to API',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
        _wifiLocService.saveFoundNetworksNearLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'Finding location');
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _findApproxLocation();
        },
        child: Icon(Icons.navigation),
        backgroundColor: Colors.green,),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
