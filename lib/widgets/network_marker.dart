import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class NetworkMarker extends Marker {
  NetworkMarker(LatLng point)
      : super(
            width: 80.0,
            height: 80.0,
            point: point,
            builder: (ctx) => new Container(
                  child: new FlutterLogo(),
                ));
}
