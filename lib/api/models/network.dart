class Network {
  final String id;
  final String deviceId;
  final double lat;
  final double lon;
  final String mac;

  Network({this.id, this.deviceId, this.lat, this.lon, this.mac});

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      id: json['_id'],
      deviceId: json['device_id'],
      lat: json['lat'],
      lon: json['lon'],
      mac: json['mac']
    );
  }

}