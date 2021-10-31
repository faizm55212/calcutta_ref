import 'package:calcutta_ref/controllers/AuthController.dart';
import 'package:calcutta_ref/screens/homeScreen/home_screen.dart';
import 'package:calcutta_ref/screens/loginScreen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return ScreenUtilInit(
      designSize: Size(360, 705),
      builder: () => GetMaterialApp(
        title: 'Calcutta Ref',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
