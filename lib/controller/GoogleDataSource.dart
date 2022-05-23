import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:googleapis/calendar/v3.dart';

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({List<Event>? events}) {
    this.appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final Event event = appointments?[index];
    return event.endTimeUnspecified != null && event.endTimeUnspecified!
        ? (event.start!.date ?? event.start!.dateTime!.toLocal())
        : (event.end!.date != null
            ? event.end!.date!.add(Duration(days: -1))
            : event.end!.dateTime!.toLocal());
  }

  @override
  String getLocation(int index) {
    return appointments?[index].location;
  }

  @override
  String getNotes(int index) {
    return appointments?[index].description;
  }

  @override
  String getSubject(int index) {
    final Event event = appointments![index];
    return event.summary!.isEmpty ? 'No Title' : event.summary.toString();
  }
}
