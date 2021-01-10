import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:tracker/bloc/tracker_bloc.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/sample.dart';
import 'package:tracker/util/functions.dart';
import 'package:tracker/view/form_sample.dart';
import 'package:tracker/widgets/dialog_custom.dart';

class SampleDetails extends StatefulWidget {
  final Sample sample;

  SampleDetails(this.sample);

  @override
  _SampleDetailsState createState() => _SampleDetailsState();
}

class _SampleDetailsState extends State<SampleDetails> {
  final trackerDatabase = TrackerDatabase();
  final trackerBloc = BlocProvider.getBloc<TrackerBloc>();
  final GlobalKey<PopupMenuButtonState<int>> popupKey = GlobalKey();

  Sample sample;

  @override
  void initState() {
    sample = widget.sample;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da coleta"),
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
                menuSample(),
                SizedBox(
                  height: 10,
                ),
                cardId(),
                cardValue(),
                cardDates(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuSample() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton(
          key: popupKey,
          child: Container(),
          itemBuilder: (_) => <PopupMenuEntry<int>>[
            PopupMenuItem<int>(child: Text('Editar'), value: 1),
            PopupMenuItem<int>(child: Text('Excluir'), value: 2),
          ],
          onSelected: (value) async {
            if (value == 1) {
              bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FormSample(idPoint: sample.idPoint, sample: sample)));
              if (result != null && result) {
                var s = await trackerDatabase.getSamplesById(sample.id);
                setState(() {
                  sample = s;
                });
              }
            } else if (value == 2) {
              int count =
                  await trackerDatabase.getSamplesCountById(sample.idPoint);
              if (count == 1)
                dialogCustom(context,
                    "Ao apagar essa coleta o ponto também será apagado. Deseja apagar?",
                    () async {
                  await trackerDatabase.deleteSample(sample.id);
                  await trackerDatabase.deletePoint(sample.idPoint);
                  await trackerBloc.updateMarkers();
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                });
              else
                dialogCustom(context, "Deseja apagar essa coleta?", () async {
                  await trackerDatabase.deleteSample(sample.id);
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
              Text("ID: ${sample.id}"),
              Text(
                  "Data: ${dateFormatted(DateTime.fromMillisecondsSinceEpoch(sample.date))}"),
            ],
          ),
        ));
  }

  Widget cardValue() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Parâmetro: ${sample.parameter}"),
            Text("Valor: ${sample.value}")
          ],
        ),
      ),
    );
  }

  Widget cardDates() {
    String createdAt =
        dateFormatted(DateTime.fromMillisecondsSinceEpoch(sample.createdAt));
    String updatedAt =
        dateFormatted(DateTime.fromMillisecondsSinceEpoch(sample.updatedAt));
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
}
