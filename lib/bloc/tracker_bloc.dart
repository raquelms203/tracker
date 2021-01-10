import 'dart:collection';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/util/functions.dart' as functions;

class TrackerBloc extends BlocBase {
  final trackerDatabase = TrackerDatabase();
  final markers = BehaviorSubject<HashSet<Marker>>();
  final markerSelected = BehaviorSubject<Marker>();

  Future<HashSet<Marker>> fetchMarkers() async {
    var list = markers.value;
    if (list == null) {
      list = HashSet<Marker>();
      List databaseMarkers = await trackerDatabase.getPoints();
      for (Point item in databaseMarkers) {
        String markerId = functions.generateRandomString(5);
        list.add(Marker(
            markerId: MarkerId(markerId), position: LatLng(item.y, item.x)));
      }
      markers.sink.add(list);
    }
    return list;
  }

  Future updateMarkers() async {
    markers.sink.add(null);
    HashSet<Marker> list = HashSet<Marker>();
    List databaseMarkers = await trackerDatabase.getPoints();
    for (Point item in databaseMarkers) {
      String markerId = functions.generateRandomString(5);
      list.add(Marker(
          markerId: MarkerId(markerId), position: LatLng(item.y, item.x)));
    }
    markers.sink.add(list);
  }

  void setMarkSelected(LatLng point) {
    String markerId = functions.generateRandomString(5);

    markerSelected.sink.add(null);

    markerSelected.sink
        .add(Marker(markerId: MarkerId(markerId), position: point));
  }

  void addMark() {
    var list = markers.value;
    Marker marker = markerSelected.value;
    print(marker);
    list.add(marker);
    markers.sink.add(null);
    markers.sink.add(list);
  }

  @override
  void dispose() {
    markers.close();
    markerSelected.close();
    super.dispose();
  }
}
