import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  int? id;
  String? title;
  DateTime? starttime;
  DateTime? endtime;
  String? clothes;
  String? location;

  EventModel({this.title, this.starttime, this.endtime});

  EventModel fromFirestore(DocumentSnapshot doc) {
    EventModel _event = EventModel();
    _event.title = doc["title"];
    _event.starttime = DateTime.parse(doc["startdate"].toDate().toString());
    _event.endtime = DateTime.parse(doc["enddate"].toDate().toString());
    _event.clothes = doc["clothes"];
    _event.location = doc["location"];

    return _event;
  }

  @override
  String toString() {
    return (title.toString() + " " + location.toString());
  }
}
