import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/controller/Database.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';

class AddFineDialogUI extends StatefulWidget {
  const AddFineDialogUI({Key? key}) : super(key: key);

  @override
  _AddFineDialogUIState createState() => _AddFineDialogUIState();
}

class _AddFineDialogUIState extends State<AddFineDialogUI> {
  Fine newStrafe = Fine();
  DateTime? dateTimeDate;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _reasonTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<List<String>>? _allNamesForMembers;
  String? _name = 'Choose...';

  // final List<String> _names = <String>[
  //   '',
  //   'Daniel Taubert',
  //   'Fabian',
  //   'Jonas',
  //   'Kai',
  //   'Konstantin',
  //   'Martin',
  //   'Maximilian',
  //   'Michael',
  //   'Nicolas',
  //   'Nikolas',
  //   'Patrick Wegner',
  //   'Patrick Wirtz',
  //   'Roman',
  //   'Sven',
  //   'Thomas Hilser',
  //   'Thomas Wallert',
  // ];

  @override
  void initState() {
    super.initState();
    _allNamesForMembers = getAllNamesFromDB();
  }

  Future<List<String>> getAllNamesFromDB() async {
    return Database().getAllNamesFromFirebase();
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);
    _dateTextController.text = DateFormat.yMMMd().format(initialDate);
    dateTimeDate = initialDate;
    final DateTime? picket = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2016),
        lastDate: DateTime(2050));
    if (picket != null && picket != initialDate) {
      setState(() {
        dateTimeDate = picket;
        _dateTextController.text = DateFormat.yMMMMd().format(picket);
      });
    }
  }

  DateTime? convertToDate(String input) {
    try {
      var d = DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text('Neue Strafe'),
          backgroundColor: Colors.indigo,
          actions: <Widget>[
            TextButton(
                child: const Text('Speichern',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white)),
                onPressed: () {
                  _submitForm();
                })
          ]),
      body: Form(
        key: _formKey,
        // autovalidate: true,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 17.0, top: 10),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontSize: 16.0),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  prefixIcon: Icon(
                    Icons.people,
                    color: Colors.indigo[400],
                  ),
                  hintText: 'Wann',
                ),
                isEmpty: _name == '',
                child: DropdownButtonHideUnderline(
                  child: FutureBuilder<List<String>>(
                    future: _allNamesForMembers,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DropdownMenuItem<String>> allOptions =
                            snapshot.data!.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList();
                        allOptions.add(const DropdownMenuItem<String>(
                            value: 'Choose...', child: Text('Choose...')));

                        return DropdownButton<String?>(
                            value: _name,
                            isDense: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                _name = newValue;
                                newStrafe.name = newValue;
                              });
                            },
                            items: allOptions);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                child: InputField(
                  obscure: false,
                  controller: _dateTextController,
                  prefixIcon: Icons.calendar_today,
                  label: 'Datum',
                  hintText: 'Wann war es',
                  savedFunction: (String? value) {
                    newStrafe.date = dateTimeDate;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                tooltip: 'Choose date',
                onPressed: (() {
                  _chooseDate(context, _dateTextController.text);
                }),
              )
            ]),
            InputField(
              obscure: false,
              controller: _reasonTextController,
              prefixIcon: Icons.receipt,
              label: 'Grund',
              hintText: 'Warum',
              savedFunction: (String? value) {
                newStrafe.reason = value;
              },
            ),
            InputField(
              obscure: false,
              controller: _amountTextController,
              prefixIcon: Icons.money,
              label: 'Betrag',
              hintText: 'Wieviel',
              savedFunction: (String? value) {
                newStrafe.amount = double.parse(value!.replaceAll(",", "."));
              },
            ),
          ].toList(),
        ),
      ),
    );
  }

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    newStrafe.payed = false;
    if (form!.validate()) {
      showMessage('Es ist nicht alles ausgefüllt - Bitte korrigieren');
    } else {
      form.save(); //This invokes each onSaved event

      newStrafe.id = DateTime.now().millisecondsSinceEpoch;
      Navigator.of(context).pop(newStrafe);
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }
}
