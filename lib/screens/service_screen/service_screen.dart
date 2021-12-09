import 'package:calcutta_ref/controllers/AuthController.dart';
import 'package:calcutta_ref/controllers/api_firebase.dart';
import 'package:calcutta_ref/controllers/global_constans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    RxInt _serviceIndex = 0.obs;
    RxString applianceName = ''.obs;
    RxString serviceName = ''.obs;
    DateTime scheduledTime = DateTime.now().add(Duration(hours: 2));
    RxString applianceId = 'LRx1OzAhkgcqvpjX30OW'.obs;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFFE8F0F2),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 220,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F0F2),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 250,
                              child: Text(
                                'Home Appliance Repair',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 30.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              width: 250,
                              child: Text(
                                'We offer professional repairing service on-demand',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                            Text(
                              '\$45hr',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Color(0xFF345B63),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<List<DocumentSnapshot>>(
                      future: Api().fetchAppliances(
                          widget.locationIndex == 0 ? 'House' : 'Office',
                          false),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        applianceName.value =
                            snapshot.data![_applianceIndex.value]['name'];
                        return ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: 90, maxHeight: 90),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    _applianceIndex.value = index;
                                    applianceId.value =
                                        snapshot.data![index].id;
                                    applianceName.value =
                                        snapshot.data![index]['name'];
                                    serviceName.value = '';
                                    _serviceIndex.value = 0;
                                  },
                                  child: Container(
                                    width: 110,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: _applianceIndex.value == index
                                          ? Color(0xFF345B63)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      // border: Border.all(
                                      //   width: _applianceIndex.value == index ? 2 : 0,
                                      //   color: _applianceIndex.value == index
                                      //       ? Colors.deepOrangeAccent.shade100
                                      //           .withAlpha(40)
                                      //       : Colors.grey.shade100,
                                      // ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/${snapshot.data![index]['icon']}.svg',
                                            height: 30.sp,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '${snapshot.data![index]['name']}',
                                            style: TextStyle(
                                                color: _applianceIndex.value ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
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
                    SizedBox(height: 20),
                    Obx(
                      () => FutureBuilder<DocumentSnapshot>(
                        future: Api().fetchServices(applianceId.value),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          serviceName.value =
                              snapshot.data!['services'][_serviceIndex.value];
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
                                      _serviceIndex.value = index;
                                      serviceName.value =
                                          snapshot.data!['services'][index];
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: _serviceIndex.value == index
                                            ? Colors.deepOrangeAccent.shade100
                                                .withAlpha(40)
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: _serviceIndex.value == index
                                              ? 2
                                              : 0,
                                          color: _serviceIndex.value == index
                                              ? Colors.deepOrangeAccent.shade100
                                                  .withAlpha(40)
                                              : Colors.grey.shade100,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                      onDateChanged: (time) {},
                      startTime:
                          DateTime(today.year, today.month, today.day, 6),
                      endTime: DateTime(today.year, today.month, today.day, 18),
                      timeInterval: Duration(minutes: 30),
                      onTimeChanged: (time) {
                        scheduledTime = time;
                      },
                      timeOutOfRangeError: 'Please pick a slot from next date',
                      type: DateTimePickerType.Both,
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.40, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color(0xFF345B63),
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(loggedInUser!.uid)
                              .collection('bookings')
                              .doc()
                              .set({
                            'category': applianceName.value,
                            'date_scheduled':
                                scheduledTime.millisecondsSinceEpoch,
                            'description': serviceName.value,
                            'time_stamp': DateTime.now().millisecondsSinceEpoch,
                            'warranty': false,
                          }, SetOptions(merge: true));
                          Fluttertoast.showToast(
                            msg: "Booked",
                            backgroundColor: Colors.black,
                          );
                          Navigator.pop(context);
                        },
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
              Positioned(
                top: 15,
                right: 5,
                width: 130,
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/vectors/ac_repair.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
