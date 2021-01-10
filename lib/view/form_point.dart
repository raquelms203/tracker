import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/view/form_sample.dart';
import 'package:tracker/widgets/button_custom.dart';
import 'package:tracker/widgets/container_loading.dart';
import 'package:tracker/widgets/textfield_decoration.dart';

class FormPoint extends StatefulWidget {
  final LatLng location;

  FormPoint({this.location});

  @override
  _FormPointState createState() => _FormPointState();
}

class _FormPointState extends State<FormPoint> {
  final _formKey = GlobalKey<FormState>();
  final TrackerDatabase databaseHelper = TrackerDatabase();
  final TextEditingController code = TextEditingController();
  LatLng location;
  bool loading = false;

  @override
  void initState() {
    if (widget.location == null) {
      Location().getLocation().then((value) {
        location = LatLng(value.latitude, value.longitude);
      });
    } else
      location = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar ponto"),
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
                          "\nLatitude: ${location.latitude}\nLogingitude: ${location.longitude}",
                          textAlign: TextAlign.center,
                        ),
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
                            text: "Continuar")
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> submitPoint() async {
    setState(() {
      loading = true;
    });
    int dateNow = DateTime.now().millisecondsSinceEpoch;
    Point point = Point(
        code: code.text,
        createdAt: dateNow,
        updatedAt: dateNow,
        x: location.longitude,
        y: location.latitude);

    setState(() {
      loading = false;
    });
    
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FormSample(point: point)));
  }
}
