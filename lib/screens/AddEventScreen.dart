import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/controller/Database.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:get/get.dart';

class AddEventDialogUI extends StatefulWidget {
  const AddEventDialogUI({Key? key}) : super(key: key);

  @override
  _AddEventDialogUIState createState() => _AddEventDialogUIState();
}

class _AddEventDialogUIState extends State<AddEventDialogUI> {
  DateTime? dateTimeDate;
  TimeOfDay? dateTimeTime = TimeOfDay.now();
  String? date;
  String? timeString;

  EventModel newEvent = EventModel();

  final TextEditingController _controllerDate = TextEditingController();
  final TextEditingController _controllerTime = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final clothesController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: HildegundisAppBar(
          title: const Text('Neuer Termin'),
          widgets: <Widget>[
            TextButton(
                child: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  _submitForm();
                })
          ]),
      body: Form(
          key: _formKey,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            children: <Widget>[
              InputField(
                controller: titleController,
                hintText: ProjectConfig.AddEventTitle,
                prefixIcon: Icons.title,
                type: TextInputType.name,
                savedFunction: (String? value) {
                  newEvent.title = value;
                },
                obscure: false,
              ),
              InputField(
                controller: locationController,
                hintText: ProjectConfig.AddEventLocation,
                prefixIcon: Icons.navigation,
                type: TextInputType.name,
                savedFunction: (String? value) {
                  newEvent.location = value;
                },
                obscure: false,
              ),
              InputField(
                controller: clothesController,
                hintText: ProjectConfig.AddEventClothes,
                prefixIcon: Icons.local_laundry_service,
                type: TextInputType.name,
                savedFunction: (String? value) {
                  newEvent.clothes = value;
                },
                obscure: false,
              ),
              Row(children: <Widget>[
                Expanded(
                    child: InputField(
                  controller: _controllerDate,
                  hintText: ProjectConfig.AddEventDate,
                  prefixIcon: Icons.calendar_month_rounded,
                  type: TextInputType.datetime,
                  savedFunction: (String? value) {
                    date = value;
                  },
                  obscure: false,
                )),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Choose date',
                  onPressed: (() {
                    _chooseDate(context, _controllerDate.text);
                  }),
                )
              ]),
              Row(children: <Widget>[
                Expanded(
                    child: InputField(
                  controller: _controllerTime,
                  hintText: ProjectConfig.AddEventTime,
                  prefixIcon: Icons.access_time,
                  type: TextInputType.datetime,
                  savedFunction: (String? value) {
                    date = value;
                  },
                  obscure: false,
                )),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: (() {
                    _chooseTime(context, _controllerTime.text);
                  }),
                )
              ]),
            ],
          )),
    );
  }

  DateTime? convertToDate(String input) {
    try {
      var d = DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);
    _controllerDate.text = DateFormat.yMMMd().format(initialDate);
    dateTimeDate = initialDate;
    final DateTime? picket = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2016),
        lastDate: DateTime(2050));
    if (picket != null && picket != initialDate) {
      setState(() {
        dateTimeDate = picket;
        _controllerDate.text = DateFormat.yMMMMd().format(picket);
      });
    }
  }

  Future _chooseTime(BuildContext context, String initialDateString) async {
    var now = DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);
    _controllerTime.text = DateFormat.Hm().format(initialDate);
    dateTimeTime = TimeOfDay.fromDateTime(initialDate);
    final TimeOfDay? picket =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picket != null) {
      setState(() {
        _controllerTime.text =
            "${picket.hour}:${picket.minute}";
        dateTimeTime = picket;
      });
    }
  }

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      showMessage('Es ist nicht alles ausgefüllt - Bitte korrigieren');
    } else {
      form.save(); //This invokes each onSaved event
      newEvent.id = DateTime.now().millisecondsSinceEpoch;
      DateTime eventDate = DateTime(dateTimeDate!.year, dateTimeDate!.month,
          dateTimeDate!.day, dateTimeTime!.hour, dateTimeTime!.minute);
      newEvent.starttime = eventDate;
      newEvent.endtime = eventDate.add(const Duration(hours: 1));
      Database().addEvent(newEvent);
      Get.back();
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }
}
