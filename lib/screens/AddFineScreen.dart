import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/controller/Database.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';

class AddFineDialogUI extends StatefulWidget {
  @override
  _AddFineDialogUIState createState() => new _AddFineDialogUIState();
}

const double _kPickerSheetHeight = 216.0;

class _AddFineDialogUIState extends State<AddFineDialogUI> {
  Fine newStrafe = Fine();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _whoTextController = TextEditingController();
  final TextEditingController _reasonTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<List<String>>? _allNamesForMembers;
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

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);
    _dateTextController.text = new DateFormat.yMMMd().format(initialDate);

    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return _buildBottomPicker(CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDate,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _dateTextController.text =
                    new DateFormat.yMMMd().format(newDateTime);
              });
            },
          ));
        });
  }

  DateTime convertToDate(String input) {
    try {
      var d = DateFormat.yMMMd().parseStrict(input);
      return d;
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    String? _name = 'Peter ';

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
            InputDecorator(
              decoration: const InputDecoration(
                  icon: Icon(Icons.people), labelText: 'Wer?'),
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
            Row(children: <Widget>[
              Expanded(
                  child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        hintText: 'Wann war es?',
                        labelText: 'Datum',
                      ),
                      controller: _dateTextController,
                      validator: (val) =>
                          val!.isEmpty ? 'Ein Datum wird benötigt' : null,
                      keyboardType: TextInputType.datetime,
                      onSaved: (val) => newStrafe.date = convertToDate(val!))),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                tooltip: 'Choose date',
                onPressed: (() {
                  _chooseDate(context, _dateTextController.text);
                }),
              )
            ]),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Grund", icon: Icon(Icons.receipt)),
              validator: (val) =>
                  val!.isEmpty ? 'Ein Grund wird benötigt' : null,
              onSaved: (String? value) {
                newStrafe.reason = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Betrag", icon: Icon(Icons.receipt)),
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val!.isEmpty ? 'Ein Betrag wird benötigt' : null,
              onSaved: (String? value) {
                newStrafe.amount = double.parse(value!.replaceAll(",", "."));
              },
            )
          ].toList(),
        ),
      ),
    );
  }

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    newStrafe.payed = false;
    if (!form!.validate()) {
      showMessage('Es ist nicht alles ausgefüllt - Bitte korrigieren');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Name: ${newStrafe.name}');
      print('Datum: ${newStrafe.date}');
      print('Grund: ${newStrafe.reason}');
      print('Betrag: ${newStrafe.amount}');
      print('========================================');

      newStrafe.id = DateTime.now().millisecondsSinceEpoch;
      Navigator.of(context).pop(newStrafe);
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }
}
