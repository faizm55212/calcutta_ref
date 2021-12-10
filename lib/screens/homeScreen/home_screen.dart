import 'package:calcutta_ref/controllers/AuthController.dart';
import 'package:calcutta_ref/controllers/api_firebase.dart';
import 'package:calcutta_ref/screens/aboutScreen/about_screen.dart';
import 'package:calcutta_ref/screens/service_screen/service_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SliderHome extends StatefulWidget {
  const SliderHome({Key? key}) : super(key: key);

  @override
  _SliderHomeState createState() => _SliderHomeState();
}

class _SliderHomeState extends State<SliderHome> {
  AuthController _authController = Get.find<AuthController>();
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A6049),
      body: SliderMenuContainer(
        appBarHeight: 60,
        key: _key,
        appBarColor: Color(0xFF2A6049),
        title: Text(''),
        drawerIconColor: Colors.white,
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_active_outlined),
          iconSize: 26,
          color: Colors.white,
        ),
        sliderMenuOpenSize: 200,
        sliderMain: HomeScreen(),
        sliderMenu: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        FirebaseAuth.instance.currentUser!.photoURL ?? ''),
                    radius: 50,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Hello.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${FirebaseAuth.instance.currentUser!.displayName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                DrawerTile(
                  iconData: 'assets/icons/drawer_home.svg',
                  title: 'Home',
                  onPressed: () {
                    _key.currentState!.closeDrawer();
                  },
                  color: Colors.black,
                ),
                SizedBox(height: 20),
                DrawerTile(
                  iconData: 'assets/icons/drawer_profile.svg',
                  title: 'Profile',
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "Comming Soon",
                      backgroundColor: Colors.black,
                    );
                    _key.currentState!.closeDrawer();
                  },
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                DrawerTile(
                  iconData: 'assets/icons/drawer_contacts.svg',
                  title: 'About Us',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutScreen()));
                    _key.currentState!.closeDrawer();
                  },
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                DrawerTile(
                  iconData: 'assets/icons/drawer_logout.svg',
                  title: 'Logout',
                  onPressed: () {
                    _authController.signOutFromGoogle();
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String iconData;
  final String title;
  final Function onPressed;
  final Color color;
  DrawerTile({
    required this.iconData,
    required this.title,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        onPressed();
      },
      icon: SvgPicture.asset(
        iconData,
        height: 26,
      ),
      label: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

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
    return Stack(
      children: [
        Container(
          height: 210.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
          ),
        ),
        Column(
          children: [
            Container(
              height: 210.h,
              decoration: BoxDecoration(
                color: Color(0xFF2A6049),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                  Container(
                    width: 280.w,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      'Engineers\nin your area today!',
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
            Container(
              height: 440.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  FutureBuilder<List<DocumentSnapshot>>(
                    future: Api().fetchOffers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      return CarouselSlider.builder(
                        options: CarouselOptions(height: 100.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, ind, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE8F0F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${snapshot.data![ind]['name']}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: 180,
                                      child: Text(
                                        '${snapshot.data![ind]['description']}',
                                        style: GoogleFonts.ubuntu(
                                          fontSize: 12.sp,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '₹${snapshot.data![ind]['offer']}hr',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Color(0xFF345B63),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Book A Service For',
                      style: GoogleFonts.ubuntu(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
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
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: _locationIndex.value == 0
                                ? Colors.deepOrangeAccent.shade100.withAlpha(40)
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
                              SvgPicture.asset(
                                'assets/icons/location_home.svg',
                                height: 50.sp,
                              ),
                              SizedBox(height: 10),
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
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: _locationIndex.value == 1
                                ? Colors.deepOrangeAccent.shade100.withAlpha(40)
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
                              SvgPicture.asset(
                                'assets/icons/location_office.svg',
                                height: 50.sp,
                              ),
                              SizedBox(height: 10),
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
                    future: Api().fetchAppliances(
                        _locationIndex.value == 0 ? 'House' : 'Office', true),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: _serviceIndex.value == index
                                        ? Colors.deepOrangeAccent.shade100
                                            .withAlpha(40)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width:
                                          _serviceIndex.value == index ? 2 : 0,
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
                                        SvgPicture.asset(
                                          'assets/icons/${snapshot.data![index]['icon']}.svg',
                                          height: 30.sp,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                            '${snapshot.data![index]['name']}'),
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
                  SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.85, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Color(0xFF2A6049),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceScreen(
                              locationIndex: _locationIndex.value,
                              applianceIndex: _serviceIndex.value,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Book Now',
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
          ],
        ),
        Positioned(
          top: 30,
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
    );
  }
}
