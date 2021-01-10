import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracker/bloc/tracker_bloc.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/util/functions.dart';
import 'package:tracker/view/form_point.dart';
import 'package:tracker/view/point_details.dart';
import 'package:tracker/widgets/container_loading.dart';

class PointsView extends StatefulWidget {
  final LocationData location;

  PointsView(this.location);

  @override
  _PointsViewState createState() => _PointsViewState();
}

class _PointsViewState extends State<PointsView> {
  final trackerDatabase = TrackerDatabase();
  final trackerBloc = BlocProvider.getBloc<TrackerBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text(
          "+",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
        ),
        onPressed: () async {
          trackerBloc.setMarkSelected(
              LatLng(widget.location.latitude, widget.location.latitude));
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormPoint(
                        location: LatLng(widget.location.latitude,
                            widget.location.longitude),
                      )));
          if (result != null && result) {
            await trackerDatabase.getPoints();
            setState(() {});
          }
        },
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Point>>(
          future: trackerDatabase.getPoints(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty)
                return Column(
                  children:
                      snapshot.data.map((item) => cardPoint(item)).toList(),
                );
              else
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text("Não há pontos registrados.",
                      textAlign: TextAlign.center),
                );
            } else
              return containerLoading();
          },
        ),
      ),
    );
  }

  Widget cardPoint(Point item) {
    String updatedDate =
        dateFormatted(DateTime.fromMillisecondsSinceEpoch(item.updatedAt));

    return FutureBuilder<int>(
        future: trackerDatabase.getSamplesCountById(item.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              child: Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: Card(
                    child: ListTile(
                      title: Text("ID: ${item.id} | Código: ${item.code}"),
                      subtitle: Text(
                          "${snapshot.data} ${snapshot.data == 1 ? "coleta" : "coletas"}"),
                      trailing: Text(updatedDate),
                      leading: Icon(
                        Icons.location_on,
                        size: 35,
                        color: Colors.red[300],
                      ),
                    ),
                  )),
              onTap: () async {
                bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PointsDetails(item)));
                if (result != null && result) {
                  await trackerDatabase.getPoints();
                  setState(() {});
                }
              },
            );
          } else
            return Container();
        });
  }
}
