import 'dart:convert';
import 'package:latlong/latlong.dart';

class Network {
  String id;
  String deviceId;
  double lat;
  double lon;
  String mac;
  int signalStrength;

  Network(
      {this.id,
      this.deviceId,
      this.lat,
      this.lon,
      this.mac,
      this.signalStrength});

  factory Network.fromJson(dynamic json) {
    return Network(
        id: json['_id'],
        deviceId: json['device_id'],
        lat: json['lat'],
        lon: json['lon'],
        mac: json['mac'],
        signalStrength: json['signal_strength']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': this.id,
      'device_id': this.deviceId,
      'lat': this.lat,
      'lon': this.lon,
      'mac': this.mac,
      'signal_strength': this.signalStrength,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  LatLng toLatLng() {
    return LatLng(this.lat, this.lon);
  }
}
