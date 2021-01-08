import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tracker/view/maps_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    text: "Pontos",
                  ),
                  Tab(text: "Mapa"),
                ],
              ),
              title: Text('Tracker'),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  color: Colors.green,
                ),
                MapsView(
                  location: _locationData,
                )
              ],
            )));
  }

  void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }
    var loc = await location.getLocation();
    setState(() {
      _locationData = loc;
    });
  }
}
