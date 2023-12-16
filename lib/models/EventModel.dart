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
    EventModel event = EventModel();
    event.title = doc["title"];
    event.starttime = DateTime.parse(doc["startdate"].toDate().toString());
    event.endtime = DateTime.parse(doc["enddate"].toDate().toString());
    event.clothes = doc["clothes"];
    event.location = doc["location"];

    return event;
  }

  @override
  String toString() {
    return ("$title $location");
  }
}
