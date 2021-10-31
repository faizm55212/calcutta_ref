import 'package:calcutta_ref/controllers/api_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  RxInt _locationIndex = 0.obs;
  RxInt _serviceIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: Color(0xFF3442BF),
      body: Stack(
        children: [
          Container(
            height: 260.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
            ),
          ),
          Column(
            children: [
              Container(
                height: 260.h,
                decoration: BoxDecoration(
                  color: Color(0xFF3442BF),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(30)),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_active_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 280.w,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                          'Engineers in your area today!',
                          style: TextStyle(
                            fontSize: 40.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 445.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    CarouselSlider(
                      options: CarouselOptions(height: 100.0),
                      items: [
                        Container(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Repairing'),
                                  Text(
                                      'We offer professional repairing\nservice on demand'),
                                  Text('\$45hr'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Book A Service For')),
                    SizedBox(height: 20),
                    TabBar(
                      controller: tabController,
                      indicator: BoxDecoration(),
                      onTap: (index) {
                        setState(() {
                          _locationIndex.value = index;
                          _serviceIndex.value = 0;
                        });
                      },
                      tabs: [
                        Obx(
                          () => Container(
                            width: 160.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              color: _locationIndex.value == 0
                                  ? Colors.deepOrangeAccent.shade100
                                      .withAlpha(40)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: _locationIndex.value == 0 ? 2 : 0,
                                color: _locationIndex.value == 0
                                    ? Colors.deepOrangeAccent.shade100
                                        .withAlpha(40)
                                    : Colors.grey.shade100,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.house_siding_outlined,
                                  size: 60,
                                  color: Colors.black,
                                ),
                                Text(
                                  'House',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Container(
                            width: 160.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              color: _locationIndex.value == 1
                                  ? Colors.deepOrangeAccent.shade100
                                      .withAlpha(40)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: _locationIndex.value == 1 ? 2 : 0,
                                color: _locationIndex.value == 1
                                    ? Colors.deepOrangeAccent.shade100
                                        .withAlpha(40)
                                    : Colors.grey.shade100,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.house_siding_outlined,
                                  size: 60,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Office',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    FutureBuilder<List<DocumentSnapshot>>(
                        future: Api().fetchApp(
                            _locationIndex.value == 0 ? 'House' : 'Office'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 55),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      _serviceIndex.value = index;
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      width: 130.w,
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
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.house_siding_outlined,
                                            size: 30,
                                          ),
                                          Text(
                                              '${snapshot.data![index]['name']}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                    SizedBox(height: 30),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.85, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color(0xFF3442BF),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Book Now',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 80,
            right: 5,
            width: 200,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/vectors/home_electric.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
