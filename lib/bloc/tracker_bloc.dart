import 'dart:collection';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class TrackerBloc extends BlocBase {
  final markers = BehaviorSubject<HashSet<Marker>>();
  final markerSelected = BehaviorSubject<Marker>();

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  void setMarkSelected(LatLng point) {
    String markerId = 'marker_id_${generateRandomString(5)}';

    markerSelected.sink.add(null);
    markerSelected.sink
        .add(Marker(markerId: MarkerId(markerId), position: point));
  }

  @override
  void dispose() {
    markers.close();
    markerSelected.close();
    super.dispose();
  }
}
