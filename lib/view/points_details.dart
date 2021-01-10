import 'package:flutter/material.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/model/sample.dart';
import 'package:tracker/util/functions.dart';
import 'package:tracker/widgets/container_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class PointsDetails extends StatefulWidget {
  final Point point;

  PointsDetails(this.point);

  @override
  _PointsDetailsState createState() => _PointsDetailsState();
}

class _PointsDetailsState extends State<PointsDetails> {
  final trackerDatabase = TrackerDatabase();
  Point point;

  @override
  void initState() {
    point = widget.point;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do ponto"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              cardId(),
              cardLocalization(),
              cardDates(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Coletas:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              listSamples()
            ],
          ),
        ),
      ),
    );
  }

  Widget cardId() {
    return Card(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              Text("ID: ${point.id}"),
              Text("Código: ${point.code}"),
            ],
          ),
        ));
  }

  Widget cardLocalization() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Coordenadas:\n"),
            Text("Latitude: ${point.y}"),
            Text("Longitude: ${point.x}"),
            InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "ver localização",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () async {
                  String googleUrl =
                      'https://www.google.com/maps/search/?api=1&query=${point.y},${point.x}';
                  if (await canLaunch(googleUrl)) await launch(googleUrl);
                })
          ],
        ),
      ),
    );
  }

  Widget cardDates() {
    String createdAt =
        dateFormatted(DateTime.fromMillisecondsSinceEpoch(point.createdAt));
    String updatedAt =
        dateFormatted(DateTime.fromMillisecondsSinceEpoch(point.updatedAt));
    return Card(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              Text("Criado em: $createdAt"),
              Text("Última modificação: $updatedAt")
            ],
          ),
        ));
  }

  Widget listSamples() {
    return FutureBuilder<List<Sample>>(
        future: trackerDatabase.getSamplesById(point.id),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Column(
                children: snapshot.data
                    .map((item) => Container(
                        height: 80,
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(children: [
                            Icon(Icons.account_tree_outlined,
                                size: 40, color: Colors.indigo[300]),
                            SizedBox(width: 20),
                            Expanded(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "ID: ${item.id}\nData: ${dateFormatted(DateTime.fromMillisecondsSinceEpoch(item.updatedAt))}"),
                                    Text(
                                      "Valor: ${item.value}\nParâmetro: ${item.parameter}",
                                      textAlign: TextAlign.right,
                                    ),
                                  ]),
                            )
                          ]),
                        ))))
                    .toList());
          else
            return containerLoading();
        });
  }
}
