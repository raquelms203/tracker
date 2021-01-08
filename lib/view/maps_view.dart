import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsView extends StatefulWidget {
  final LocationData location;

  MapsView({this.location});

  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  Set<Marker> _markers = HashSet<Marker>();
  int _counter = 1;

  @override
  Widget build(BuildContext context) {
    print(widget.location);
    return widget.location != null
        ? GoogleMap(
            initialCameraPosition: CameraPosition(
                target:
                    LatLng(widget.location.latitude, widget.location.longitude),
                zoom: 16),
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            markers: _markers,
            myLocationButtonEnabled: true,
            onTap: (point) {
              setState(() {
                _setMarkers(point);
              });
            })
        : Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  void _setMarkers(LatLng point) {
    final String markerId = 'marker_id_$_counter';
    _counter++;
    setState(() {
      print("Lat: ${point.latitude} | Lng: ${point.longitude}");
      _markers.add(Marker(markerId: MarkerId(markerId), position: point));
    });
  }
}
