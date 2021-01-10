import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:tracker/bloc/tracker_bloc.dart';
import 'package:tracker/database/tracker_database.dart';
import 'package:tracker/model/point.dart';
import 'package:tracker/model/sample.dart';
import 'package:tracker/util/functions.dart';
import 'package:tracker/widgets/button_custom.dart';
import 'package:tracker/widgets/container_loading.dart';
import 'package:tracker/widgets/textfield_decoration.dart';

class FormSample extends StatefulWidget {
  final Point point;
  final String idPoint;
  final bool fromMaps;
  final Sample sample;

  FormSample({this.point, this.fromMaps, this.idPoint, this.sample});

  @override
  _FormSampleState createState() => _FormSampleState();
}

class _FormSampleState extends State<FormSample> {
  final _formKey = GlobalKey<FormState>();
  final trackerBloc = BlocProvider.getBloc<TrackerBloc>();
  final databaseHelper = TrackerDatabase();
  final parameter = TextEditingController();
  final value = TextEditingController();
  DateTime dateSelected = DateTime.now();
  bool loading = false;
  bool isEdit = false;
  Sample sample;

  @override
  void initState() {
    if (widget.sample != null) {
      sample = widget.sample;
      isEdit = true;
      parameter.text = sample.parameter;
      value.text = sample.value.toString();
      dateSelected = DateTime.fromMillisecondsSinceEpoch(sample.date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${isEdit ? "Editar" : "Cadastrar"} coleta"),
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

    String idPoint;
    Sample newSample;
    int dateNow = DateTime.now().millisecondsSinceEpoch;

    if (widget.idPoint == null) {
      idPoint = await databaseHelper.addPoint(widget.point);
      trackerBloc.addMark();
      await trackerBloc.updateMarkers();
    }

    if (isEdit) {
      newSample = Sample(
          createdAt: sample.createdAt,
          date: dateSelected.millisecondsSinceEpoch,
          idPoint: sample.idPoint,
          parameter: parameter.text,
          updatedAt: dateNow,
          id: sample.id,
          value: double.parse(value.text));
      await databaseHelper.updateSample(newSample);
    } else {
      newSample = Sample(
          createdAt: dateNow,
          date: dateSelected.millisecondsSinceEpoch,
          idPoint: widget.idPoint == null ? idPoint : widget.idPoint,
          parameter: parameter.text,
          updatedAt: dateNow,
          value: double.parse(value.text));
      await databaseHelper.addSample(newSample);
    }

    setState(() {
      loading = false;
    });
    if (widget.idPoint == null) {
      Navigator.pop(context);
    }
    Navigator.pop(context, true);
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
