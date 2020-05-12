import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kczwifilocation/services/wifi_loc_service.dart';
import 'package:kczwifilocation/widgets/map_tab.dart';
import 'package:kczwifilocation/widgets/settings_tab.dart';

class AppWidget extends StatefulWidget {
  AppWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with SingleTickerProviderStateMixin {
  WifiLocService _wifiLocService;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    _wifiLocService = WifiLocService.fromDefaults();
    _wifiLocService.getAllNetworks().then((value) {
      print(value);
    });
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: TabBarView(
          // Add tabs as widgets
          children: <Widget>[MapTab(), SettingsTab()],
          // set the controller
          controller: tabController,
        ),
        bottomNavigationBar: Material(
          color: Colors.blue,
          child: TabBar(
            tabs: <Tab>[
              Tab(
                // set icon to the tab
                icon: Icon(Icons.map),
              ),
              Tab(
                icon: Icon(Icons.settings),
              ),
            ],
            controller: tabController,
          ),
        ));
  }
}
