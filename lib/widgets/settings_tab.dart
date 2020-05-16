import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  SharedPreferences sharedPreferences;
  bool fetchedPreferences = false;
  bool postNetworks = false;

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  void _fetchPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('POST_NETWORKS')) {
      await prefs.setBool('POST_NETWORKS', false);
    }
    setState(() {
      sharedPreferences = prefs;
      fetchedPreferences = true;
      postNetworks = prefs.getBool('POST_NETWORKS');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            // center the children
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (fetchedPreferences)
                CheckboxListTile(
                  title: Text('Send found networks to API'),
                  secondary: Icon(Icons.gps_fixed),
                  value: postNetworks,
                  onChanged: (bool value) async {
                    await sharedPreferences.setBool('POST_NETWORKS', value);
                    setState(() {
                      postNetworks = value;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
