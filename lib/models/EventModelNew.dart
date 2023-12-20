import 'package:cloud_firestore/cloud_firestore.dart';

class EventModelNew {
  int? id;
  String? title;
  DateTime? starttime;
  int? duration;
  String? clothes;
  String? location;
  Map<String, dynamic>? partcipation;

  EventModelNew({this.title, this.starttime, this.duration});

  EventModelNew fromFirestore(DocumentSnapshot doc) {
    EventModelNew event = EventModelNew();
    event.title = doc["title"];
    event.starttime = DateTime.parse(doc["starttime"].toDate().toString());
    event.duration = doc["duration"];
    event.partcipation = doc["participation"];
    event.clothes = doc["clothes"];
    event.location = doc["location"];

    return event;
  }

  @override
  String toString() {
    return ("$title $location");
  }
}
