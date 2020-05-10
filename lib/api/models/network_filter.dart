import 'dart:convert';

class NetworkFilter {
  String id;
  String deviceId;
  double lat;
  double lon;
  String mac;

  NetworkFilter({this.id, this.deviceId, this.lat, this.lon, this.mac});

  factory NetworkFilter.fromJson(dynamic json) {
    return NetworkFilter(
        id: json['_id'],
        deviceId: json['device_id'],
        lat: json['lat'],
        lon: json['lon'],
        mac: json['mac']);
  }

  Map<String, dynamic> toJson() {
    return {
      if (this.id != null) '_id': this.id,
      if (this.deviceId != null) 'device_id': this.deviceId,
      if (this.lat != null) 'lat': this.lat,
      if (this.lon != null) 'lon': this.lon,
      if (this.mac != null) 'mac': this.mac,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
