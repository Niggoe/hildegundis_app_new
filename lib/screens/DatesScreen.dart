import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/constants.dart';
import 'package:hildegundis_app_new/controller/Database.dart';
import 'package:hildegundis_app_new/models/EventModel.dart';
import 'package:hildegundis_app_new/screens/DateDetailScreen.dart';
import 'package:hildegundis_app_new/screens/screens.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../widgets/AppBar.dart';

class DateScreen extends StatefulWidget {
  @override
  _DateScreenState createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  final CalendarController _controller = CalendarController();
  EventModel? newEvent = Get.put(EventModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HildegundisAppBar(
          title: Text(ProjectConfig.TextAppBarDateOverview),
          appBar: AppBar(),
          widgets: [],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {
            Get.to(AddEventDialogUI());
          },
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Database().getEventsFromDatabase(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              return SfCalendar(
                  view: CalendarView.month,
                  allowedViews: [CalendarView.schedule, CalendarView.month],
                  firstDayOfWeek: 1,
                  controller: _controller,
                  dataSource: MeetingDataSource(_getStreamedData(snapshot)),
                  onTap: calendarTapped,
                  // by default the month appointment display mode set as Indicator, we can
                  // change the display mode as appointment using the appointment display
                  // mode property
                  scheduleViewSettings:
                      ScheduleViewSettings(hideEmptyScheduleWeek: true),
                  monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment,
                      showAgenda: true));
            }));
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    switch (calendarTapDetails.targetElement) {
      case CalendarElement.appointment:
        Appointment appointment = calendarTapDetails.appointments![0];
        Get.to(() => DateDatailScreen(), arguments: appointment);
        break;
      default:
    }
    if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
  }

  getAddDialogValue() {
    return AddEventDialogUI();
  }

  List<Appointment> _getStreamedData(AsyncSnapshot snapshot) {
    final List<Appointment> appointements = <Appointment>[];
    snapshot.data.docs.map((e) {
      appointements.add(Appointment(
          startTime: DateTime.parse(e["startdate"].toDate().toString()),
          endTime: DateTime.parse(e["enddate"].toDate().toString()),
          notes: e["clothes"],
          location: e["location"],
          subject: e["title"]));
    }).toList();

    return appointements;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  String getClothes(int index) {
    return _getMeetingData(index).clothes;
  }

  @override
  String getLocation(int index) {
    return _getMeetingData(index).location;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.clothes, this.location);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  // To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  String clothes;

  String location;
}
