import 'package:calcutta_ref/screens/homeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool result = false;
  String _verificationId = '';
  String authException = '';

  Future<bool> phoneAuth(String _phoneNumber, BuildContext context) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _auth.signInWithCredential(phoneAuthCredential);
            Fluttertoast.showToast(
              msg: "Logged In: ${_auth.currentUser!.uid}",
              backgroundColor: Colors.black,
            );
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          verificationFailed: (FirebaseAuthException _authException) {
            Fluttertoast.showToast(
              msg: "Logged Failed: ${_authException.code}",
              backgroundColor: Colors.black,
            );
            result = false;
          },
          codeSent: (String verificationId, forceResendingToken) async {
            _verificationId = verificationId;
            Fluttertoast.showToast(
              msg: "Enter Otp",
              backgroundColor: Colors.black,
            );
            result = true;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
            result = true;
          });
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<String> signInWithPhoneNumber(
      String smsCode, BuildContext context) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      user = (await _auth.signInWithCredential(credential)).user!;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      return user.uid;

      // showSnackbar("Successfully signed in UID: ${user.uid}");
    } catch (e) {
      return e.toString();
    }
  }
}