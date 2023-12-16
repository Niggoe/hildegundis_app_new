import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/controller/Database.dart';
import 'package:hildegundis_app_new/models/EventModel.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _controller = CalendarController();
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late CalendarFormat _calendarFormat;
  late Map<String, List<EventModel>> _events;
  late final ValueNotifier<List<EventModel>> _selectedEvents;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    _selectedDay = DateTime(2023, 12, 14);
    _focusedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _controller = CalendarController();
    _events = {};
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    String formatedDate = _dateFormat.format(day);
    return _events[formatedDate] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Database().getEventsFromDatabase(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          _events = {};
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final events = snapshot.data!.docs;

          for (var eventDate in events) {
            EventModel event = EventModel().fromFirestore(eventDate);

            DateTime date = DateTime(event.starttime!.year,
                event.starttime!.month, event.starttime!.day);

            String formatted = _dateFormat.format(date);

            if (_events[formatted] == null) {
              _events[formatted] = [];
            }
            _events[formatted]!.add(event);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Column(
              children: [
                _buildTableCalendar(),
                const SizedBox(height: 8.0),
                Expanded(child: _buildEventList()),
              ],
            ),
          );
        });
  }

  TableCalendar _buildTableCalendar() {
    return TableCalendar<EventModel>(
      focusedDay: _focusedDay,
      firstDay: _firstDay,
      lastDay: _lastDay,
      eventLoader: _getEventsForDay,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.rectangle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.blue),
        todayTextStyle: TextStyle(color: Colors.white),
        weekendDecoration: BoxDecoration(
          color: Color.fromRGBO(255, 0, 0, 0.1),
          shape: BoxShape.rectangle,
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonDecoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15.0),
        ),
        formatButtonTextStyle: TextStyle(color: Colors.white),
        formatButtonShowsNext: true,
      ),
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: _onDaySelected,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Text(
            date.day.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        todayBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Text(
            date.day.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      locale: 'de_DE',
    );
  }

  /*Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _controller.isSelected(date)
            ? Colors.white
            : _controller.isToday(date)
                ? Colors.yellow[400]
                : Theme.of(context).primaryColor,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }*/

  _buildEventList() {
    return ValueListenableBuilder<List<EventModel>>(
        valueListenable: _selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.8),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(value[index].title!),
                    onTap: () => print('${value[index].title}'),
                  ),
                );
              });
        });
  }
}
