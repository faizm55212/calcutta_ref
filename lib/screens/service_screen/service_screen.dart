import 'package:flutter/material.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Date & Time'),
          // DateTimePicker(
          //   initialSelectedDate: today,
          //   startDate: today,
          //   type: DateTimePickerType.Both,
          // ),
        ],
      ),
    );
  }
}
