import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kczwifilocation/api/wifi_loc_api.dart';
import 'package:http/http.dart' as http;

class AppWidget extends StatefulWidget {
  AppWidget({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  WifiLocAPI _wifiLocAPI;

  @override
  void initState() {
    super.initState();
    _wifiLocAPI = WifiLocAPI(httpClient: http.Client());
    _wifiLocAPI.getNetworks().then((networks) {
      print(networks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
