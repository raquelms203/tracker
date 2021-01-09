import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/model/sample.dart';
import 'package:tracker/util/functions.dart';
import 'package:tracker/widgets/button_custom.dart';
import 'package:tracker/widgets/container_loading.dart';
import 'package:tracker/widgets/textfield_decoration.dart';

class FormSample extends StatefulWidget {
  final Point point;

  FormSample({this.point});

  @override
  _FormSampleState createState() => _FormSampleState();
}

class _FormSampleState extends State<FormSample> {
  final _formKey = GlobalKey<FormState>();
  final TrackerDatabase databaseHelper = TrackerDatabase();
  final TextEditingController parameter = TextEditingController();
  final TextEditingController value = TextEditingController();
  DateTime dateSelected = DateTime.now();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar coleta"),
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
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: value,
                          decoration: textFieldDecoration("Valor"),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Digite o valor";
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: parameter,
                          decoration: textFieldDecoration("Parâmetro"),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Digite o parâmetro";
                            else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        calendarField(),
                        SizedBox(
                          height: 30,
                        ),
                        defaultButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await submitSample();
                              }
                            },
                            text: "Salvar")
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> submitSample() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      loading = true;
    });
    int dateNow = DateTime.now().millisecondsSinceEpoch;

    String idPoint = await databaseHelper.addPoint(widget.point);

    Sample sample = Sample(
        createdAt: dateNow,
        date: dateSelected.millisecondsSinceEpoch,
        idPoint: idPoint,
        parameter: parameter.text,
        updatedAt: dateNow,
        value: double.parse(value.text));

    await databaseHelper.addSample(sample);
    
  }

  Widget calendarField() {
    return SizedBox(
        height: 40.0,
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                size: 23.0,
              ),
              Text("  Data: "),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(dateFormatted(dateSelected)),
              ),
            ],
          ),
          onPressed: () {
            openDatePicker();
          },
          shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ));
  }

  Future<Null> openDatePicker() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2024),
        builder: (BuildContext context, Widget child) {
          return Center(
            child: SingleChildScrollView(
                child: Theme(
                    child: child,
                    data: ThemeData.light().copyWith(
                      primaryColor: Colors.grey[800],
                      colorScheme: ColorScheme.light(primary: Colors.grey[800]),
                      buttonTheme:
                          ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      accentColor: Color(0xffF5891F),
                    ))),
          );
        });
    if (date != null) {
      setState(() {
        dateSelected = date;
      });
    }
  }
}
