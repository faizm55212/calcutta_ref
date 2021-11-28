import 'package:calcutta_ref/controllers/api_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceScreen extends StatefulWidget {
  int locationIndex = 0;
  int applianceIndex = 0;
  ServiceScreen(
      {required this.locationIndex, required this.applianceIndex, Key? key})
      : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    RxInt _applianceIndex = widget.applianceIndex.obs;
    RxString applianceId = 'LRx1OzAhkgcqvpjX30OW'.obs;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Text('Home Appliance Repair'),
                  Text('We offer professional repairing service on demand'),
                  Text('\$45hr'),
                ],
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<DocumentSnapshot>>(
              future: Api().fetchAppliances(
                  widget.locationIndex == 0 ? 'House' : 'Office', false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 90, maxHeight: 90),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => GestureDetector(
                          onTap: () {
                            _applianceIndex.value = index;
                            applianceId.value = snapshot.data![index].id;
                          },
                          child: Container(
                            width: 110,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: _applianceIndex.value == index
                                  ? Colors.deepOrangeAccent.shade100
                                      .withAlpha(40)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: _applianceIndex.value == index ? 2 : 0,
                                color: _applianceIndex.value == index
                                    ? Colors.deepOrangeAccent.shade100
                                        .withAlpha(40)
                                    : Colors.grey.shade100,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/${snapshot.data![index]['icon']}.svg',
                                    height: 30.sp,
                                  ),
                                  SizedBox(height: 10),
                                  Text('${snapshot.data![index]['name']}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Obx(
              () => FutureBuilder<DocumentSnapshot>(
                future: Api().fetchServices(applianceId.value),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 55),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!['services'].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => GestureDetector(
                            onTap: () {
                              _applianceIndex.value = index;
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: _applianceIndex.value == index
                                    ? Colors.deepOrangeAccent.shade100
                                        .withAlpha(40)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: _applianceIndex.value == index ? 2 : 0,
                                  color: _applianceIndex.value == index
                                      ? Colors.deepOrangeAccent.shade100
                                          .withAlpha(40)
                                      : Colors.grey.shade100,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        '${snapshot.data!['services'][index]}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text('Date & Time'),
            DateTimePicker(
              initialSelectedDate: today,
              startDate: today.subtract(Duration(hours: 2)),
              endDate: today.add(Duration(days: 60)),
              startTime: DateTime(today.year, today.month, today.day, 6),
              endTime: DateTime(today.year, today.month, today.day, 18),
              timeInterval: Duration(minutes: 30),
              onDateChanged: (time) {},
              onTimeChanged: (time) {},
              type: DateTimePickerType.Both,
            ),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.40, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color(0xFF2A6049),
                ),
                onPressed: () {},
                child: Text(
                  'Confirm',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
