import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracker/bloc/tracker_bloc.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/view/form_sample.dart';
import 'package:tracker/widgets/button_custom.dart';
import 'package:tracker/widgets/container_loading.dart';
import 'package:tracker/widgets/textfield_decoration.dart';

class FormPoint extends StatefulWidget {
  final LatLng location;
  final bool isEdit;
  final Point point;

  FormPoint({this.location, this.isEdit, this.point});

  @override
  _FormPointState createState() => _FormPointState();
}

class _FormPointState extends State<FormPoint> {
  final _formKey = GlobalKey<FormState>();
  final trackerDatabase = TrackerDatabase();
  final trackerBloc = BlocProvider.getBloc<TrackerBloc>();

  final TrackerDatabase databaseHelper = TrackerDatabase();
  final TextEditingController code = TextEditingController();
  LatLng location;
  bool loading = false;
  bool isEdit = false;
  Point point;

  @override
  void initState() {
    if (widget.location == null) {
      Location().getLocation().then((value) {
        location = LatLng(value.latitude, value.longitude);
      });
    } else
      location = widget.location;

    if (widget.isEdit != null) {
      isEdit = widget.isEdit;
      point = widget.point;
      code.text = point.code;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${isEdit ? "Editar" : "Cadastrar"} ponto"),
      ),
      body: loading
          ? containerLoading()
          : SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("Localização:"),
                        Text(
                          textCoordinates(),
                          textAlign: TextAlign.center,
                        ),
                        isEdit
                            ? Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: 220,
                                child: outlinedButton(
                                    text: "Mudar para localização atual",
                                    onPressed: () async {
                                      var loc = await Location().getLocation();
                                      setState(() {
                                        point.x = loc.longitude;
                                        point.y = loc.latitude;
                                      });
                                    }),
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: code,
                          decoration: textFieldDecoration("Código"),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Digite o código";
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await submitPoint();
                              }
                            },
                            text: "${isEdit ? "Salvar" : "Continuar"}")
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String textCoordinates() {
    if (isEdit) {
      return "\nLatitude: ${point.y}\nLogingitude: ${point.x}";
    } else {
      return "\nLatitude: ${location.latitude}\nLogingitude: ${location.longitude}";
    }
  }

  Future<void> submitPoint() async {
    Point newPoint;
    int dateNow = DateTime.now().millisecondsSinceEpoch;
    if (isEdit) {
      setState(() {
        loading = true;
      });
      newPoint = Point(
          id: point.id,
          createdAt: point.createdAt,
          code: code.text,
          updatedAt: dateNow,
          x: point.x,
          y: point.y);
      await trackerDatabase.updatePoint(newPoint);
      await trackerBloc.updateMarkers();
      setState(() {
        loading = false;
      });
      Navigator.pop(context, true);
    } else {
      newPoint = Point(
          code: code.text,
          createdAt: dateNow,
          updatedAt: dateNow,
          x: location.longitude,
          y: location.latitude);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => FormSample(point: newPoint)));
    }
  }
}
