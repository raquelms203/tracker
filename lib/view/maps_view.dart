import 'dart:collection';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracker/bloc/tracker_bloc.dart';
import 'package:tracker/view/form_point.dart';
import 'package:tracker/widgets/container_loading.dart';

class MapsView extends StatefulWidget {
  final LocationData location;

  MapsView(this.location);

  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final trackerBloc = BlocProvider.getBloc<TrackerBloc>();

  @override
  void initState() {
    trackerBloc.fetchMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.location != null
        ? StreamBuilder<HashSet<Marker>>(
            stream: trackerBloc.markers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(widget.location.latitude,
                            widget.location.longitude),
                        zoom: 16),
                    mapType: MapType.hybrid,
                    myLocationEnabled: true,
                    markers: snapshot.data,
                    myLocationButtonEnabled: true,
                    onTap: (point) {
                      _setMarkers(point);
                    });
              } else
                return containerLoading();
            })
        : containerLoading();
  }

  void _setMarkers(LatLng point) {
    trackerBloc.setMarkSelected(point);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormPoint(
                  location: point,
                )));
  }
}
