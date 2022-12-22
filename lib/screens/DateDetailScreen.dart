import 'package:flutter/material.dart';
import 'package:hildegundis_app_new/app.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:get/get.dart';

import '../constants.dart';

class DateDatailScreen extends StatelessWidget {
  Appointment? appointment;
  @override
  Widget build(BuildContext context) {
    appointment = Get.arguments;
    return Scaffold(
      appBar: const HildegundisAppBar(
        title: Text("Details"),
      ),
      body: Column(
        children: [
          const Divider(
            color: Colors.white,
          ),
          TextDisplayField(
            prefixIcon: Icons.title,
            text: appointment!.subject,
            readonly: true,
          ),
          TextDisplayField(
            prefixIcon: Icons.navigation,
            text: appointment!.location,
            readonly: true,
          ),
          TextDisplayField(
            prefixIcon: Icons.wash_outlined,
            text: appointment!.notes,
            readonly: true,
          ),
          TextDisplayField(
            prefixIcon: Icons.calendar_month,
            readonly: true,
            text: (DateFormat('dd.MM.yyyy')
                .format(
                  appointment!.startTime,
                )
                .toString()),
          ),
          TextDisplayField(
            prefixIcon: Icons.punch_clock,
            readonly: true,
            text: DateFormat('HH:mm')
                .format(
                  appointment!.startTime,
                )
                .toString(),
          ),
        ],
      ),
    );
  }
}
