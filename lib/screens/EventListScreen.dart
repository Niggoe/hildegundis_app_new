import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:hildegundis_app_new/widgets/AppBar.dart';
import 'package:intl/intl.dart';

import '../controller/Database.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late final ValueNotifier<List<EventModelNew>> _selectedEvents;
  late Map<String, List<EventModelNew>> _events;
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy - HH:mm');
  DateFormat dateFormat = DateFormat("dd.MM.yyyy HH:mm");
  DateFormat endTime = DateFormat("HH:mm");

  @override
  void initState() {
    _events = {};
    _selectedEvents = ValueNotifier(_getEventsForDay(DateTime.now()));
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventModelNew> _getEventsForDay(DateTime day) {
    String formatedDate = _dateFormat.format(day);

    return _events[formatedDate] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Database().getEventsFromDatabaseAfterToday(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final events = snapshot.data!.docs.map((doc) {
            return EventModelNew().fromFirestore(doc);
          }).toList();

          return Scaffold(
            appBar: const HildegundisAppBar(
              title: Text('Event List'),
            ),
            body: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                DateTime endtime = event.starttime as DateTime;
                endtime = endtime.add(Duration(minutes: event.duration as int));
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.redAccent, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                      subtitleTextStyle: const TextStyle(color: Colors.black),
                      title: Text(
                        event.title.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                      subtitle: Text(
                        dateFormat.format(event.starttime as DateTime) +
                            " - " +
                            endTime.format(endtime) +
                            " Uhr",
                      )),
                );
              },
            ),
          );
        });
  }
}
