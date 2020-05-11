import 'dart:convert';

class WifiNetworkInfo {
  String ssid;
  String bssid;
  int signalStrength;
  int frequency;
  String capabilites;

  WifiNetworkInfo({this.ssid, this.bssid, this.signalStrength, this.frequency, this.capabilites});

  Map<String, dynamic> toJson() {
    return {
      'ssid': this.ssid,
      'bssid': this.bssid,
      'signalStrength': this.signalStrength,
      'frequency': this.frequency,
      'capabilites': this.capabilites,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }


}