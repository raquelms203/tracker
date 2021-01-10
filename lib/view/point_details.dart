import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:tracker/bloc/tracker_bloc.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/model/sample.dart';
import 'package:tracker/util/functions.dart';
import 'package:tracker/view/form_point.dart';
import 'package:tracker/view/form_sample.dart';
import 'package:tracker/view/sample_details.dart';
import 'package:tracker/widgets/container_loading.dart';
import 'package:tracker/widgets/dialog_custom.dart';
import 'package:url_launcher/url_launcher.dart';

class PointsDetails extends StatefulWidget {
  final Point point;

  PointsDetails(this.point);

  @override
  _PointsDetailsState createState() => _PointsDetailsState();
}

class _PointsDetailsState extends State<PointsDetails> {
  final trackerDatabase = TrackerDatabase();
  final trackerBloc = BlocProvider.getBloc<TrackerBloc>();
  final GlobalKey<PopupMenuButtonState<int>> popupKey = GlobalKey();

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
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              popupKey.currentState.showButtonMenu();
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, true);
          return Future.value(true);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                menuPoints(),
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
      ),
    );
  }

  Widget menuPoints() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton(
          key: popupKey,
          child: Container(),
          itemBuilder: (_) => <PopupMenuEntry<int>>[
            PopupMenuItem<int>(child: Text('Adicionar coleta'), value: 1),
            PopupMenuItem<int>(child: Text('Editar'), value: 2),
            PopupMenuItem<int>(child: Text('Excluir'), value: 3),
          ],
          onSelected: (value) async {
            if (value == 1) {
              bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormSample(
                            idPoint: point.id,
                            point: point,
                          )));
              if (result != null && result) {
                await trackerDatabase.getSamplesByIdPoint(point.id);
                setState(() {});
              }
            } else if (value == 2) {
              bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormPoint(
                            point: point,
                            isEdit: true,
                          )));
              if (result != null && result) {
                var p = await trackerDatabase.getPointById(point.id);
                setState(() {
                  point = p;
                });
              }
            } else if (value == 3) {
              dialogCustom(context,
                  "Deseja apagar esse ponto e as coletas relacionadas?",
                  () async {
                await trackerDatabase.deletePoint(point.id);
                await trackerBloc.updateMarkers();
                Navigator.pop(context);
                Navigator.pop(context, true);
              });
            }
          },
        ),
      ],
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
              Text("Última modificação em: $updatedAt")
            ],
          ),
        ));
  }

  Widget cardSample(Sample item) {
    return Container(
        height: 90,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(children: [
                  Icon(Icons.account_tree_outlined,
                      size: 40, color: Colors.indigo[300]),
                  SizedBox(width: 20),
                  Text("ID: ${item.id}\n" +
                      "Data: ${dateFormatted(DateTime.fromMillisecondsSinceEpoch(item.date))}" +
                      "\nParâmetro: ${item.parameter}" +
                      "\nValor: ${item.value}", overflow: TextOverflow.ellipsis,),
                ]))));
  }

  Widget listSamples() {
    return FutureBuilder<List<Sample>>(
        future: trackerDatabase.getSamplesByIdPoint(point.id),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Column(
                children: snapshot.data
                    .map((item) => InkWell(
                        onTap: () async {
                          bool result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SampleDetails(item)));
                          if (result != null && result) {
                            await trackerDatabase.getSamplesByIdPoint(point.id);
                            setState(() {});
                          }
                        },
                        child: cardSample(item)))
                    .toList());
          else
            return containerLoading();
        });
  }
}
