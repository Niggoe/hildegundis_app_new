import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hildegundis_app_new/models/models.dart';
import 'package:intl/intl.dart';

import '../controller/Database.dart';

class CalendarDetailScreen extends StatefulWidget {
  const CalendarDetailScreen({Key? key}) : super(key: key);

  @override
  State<CalendarDetailScreen> createState() => _CalendarDetailScreenState();
}

class _CalendarDetailScreenState extends State<CalendarDetailScreen> {
  EventModelNew? appointment;

  DateFormat dateFormat = DateFormat("dd.MM.yyyy HH:mm");

  DateFormat endTime = DateFormat("HH:mm");

  @override
  Widget build(BuildContext context) {
    appointment = Get.arguments;
    DateTime enddate = appointment?.starttime as DateTime;
    enddate = enddate.add(Duration(minutes: appointment?.duration as int));

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: RichText(
              text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: appointment?.title.toString(),
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            ],
          ))),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              readOnly: true,
              style: const TextStyle(fontSize: 22.0),
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 16.0),
                fillColor: Colors.white,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.title,
                  color: Colors.indigo[400],
                ),
                hintText: appointment?.title,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              readOnly: true,
              style: const TextStyle(fontSize: 22.0),
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 16.0),
                border: InputBorder.none,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Colors.indigo[400],
                ),
                hintText:
                    "${dateFormat.format(appointment?.starttime as DateTime)} - ${endTime.format(enddate)} Uhr",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              readOnly: true,
              style: const TextStyle(fontSize: 22.0),
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 16.0),
                border: InputBorder.none,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.location_city,
                  color: Colors.indigo[400],
                ),
                hintText: appointment?.location,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              readOnly: true,
              style: const TextStyle(fontSize: 22.0),
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 16.0),
                border: InputBorder.none,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.wash_outlined,
                  color: Colors.indigo[400],
                ),
                hintText: appointment?.clothes,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Zusagen",
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: appointment?.partcipation?.length,
                  itemBuilder: (context, index) {
                    List<Widget> participants = [];
                    String key = appointment?.partcipation?.keys
                        .elementAt(index) as String;
                    List<dynamic> users =
                        appointment?.partcipation?[key] as List<dynamic>;
                    for (String s in users) {
                      participants.add(getUserNameFromDatabase(s));
                    }
                    return ListTile(
                      title: Text(
                        appointment?.partcipation?.keys.elementAt(index) ?? "",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                      subtitle: getRowOfParticipants(participants),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getRowOfParticipants(List<Widget> allNames) {
    return Row(
      children: allNames,
    );
  }

  Widget getUserNameFromDatabase(String uid) {
    return FutureBuilder(
        future: Database().getUserFromNewStorage(uid),
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Text(snapshot.data?.name ?? "");
        });
  }
}
