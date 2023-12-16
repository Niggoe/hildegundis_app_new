import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/models/EventModel.dart';
import 'package:hildegundis_app_new/widgets/widgets.dart';
import 'package:intl/intl.dart';

class CalendarDetailScreen extends StatelessWidget {
  EventModel? appointment;

  CalendarDetailScreen({Key? key}) : super(key: key);

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
            text: appointment?.title,
            readonly: true,
          ),
          TextDisplayField(
            prefixIcon: Icons.navigation,
            text: appointment?.location,
            readonly: true,
          ),
          TextDisplayField(
            prefixIcon: Icons.wash_outlined,
            text: appointment?.clothes,
            readonly: true,
          ),
          TextDisplayField(
            prefixIcon: Icons.calendar_month,
            readonly: true,
            text: (DateFormat('dd.MM.yyyy')
                .format(
                  appointment?.starttime as DateTime,
                )
                .toString()),
          ),
          TextDisplayField(
            prefixIcon: Icons.punch_clock,
            readonly: true,
            text: DateFormat('HH:mm')
                .format(
                  appointment?.starttime as DateTime,
                )
                .toString(),
          ),
        ],
      ),
    );
  }
}
