import 'package:flutter/material.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/util/functions.dart';
import 'package:tracker/view/points_details.dart';
import 'package:tracker/widgets/container_loading.dart';

class PointsView extends StatefulWidget {
  @override
  _PointsViewState createState() => _PointsViewState();
}

class _PointsViewState extends State<PointsView> {
  final trackerDatabase = TrackerDatabase();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Point>>(
        future: trackerDatabase.getPoints(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty)
              return Column(
                children: snapshot.data.map((item) => cardPoint(item)).toList(),
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
    );
  }

  Widget cardPoint(Point item) {
    String updatedDate =
        dateFormatted(DateTime.fromMillisecondsSinceEpoch(item.updatedAt));

    return FutureBuilder<String>(
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
                          "${snapshot.data} ${snapshot.data.length == 1 ? "coleta" : "coletas"}"),
                      trailing: Text(updatedDate),
                      leading: Icon(
                        Icons.location_on,
                        size: 35,
                        color: Colors.red[300],
                      ),
                    ),
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PointsDetails(item)));
              },
            );
          } else
            return Container();
        });
  }
}
