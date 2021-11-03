import 'dart:async';
import 'package:calcutta_ref/controllers/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController _authController = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome\n to Calcutta Ref!',
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Hope you are well today',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              Center(
                child: Container(
                  width: 305.w,
                  height: 300.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/vectors/login_main.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color(0xFF2A6049),
                ),
                onPressed: () {
                  _authController.signInwithGoogle(context);
                },
                icon: SvgPicture.asset(
                  'assets/icons/google.svg',
                  height: 24,
                ),
                label: Text(
                  'Login',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PhoneAuth()));
                },
                child: Text(
                  'Continue with phone number',
                  style:
                      GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController textPin = TextEditingController();
  TextEditingController textPhone = TextEditingController();
  PhoneNumber number = PhoneNumber(phoneNumber: "0000000000", isoCode: 'IN');
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  AuthController _authController = Get.find<AuthController>();
  bool hasError = false;
  bool processing = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  int _start = 40;
  Timer? _timer;
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer!.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFD4DFDB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: GoogleFonts.ubuntu(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Phone number',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 13),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(textPhone.text);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    countries: ['IN'],
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                      setSelectorButtonAsPrefixIcon: true,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    initialValue: number,
                    textFieldController: textPhone,
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: InputBorder.none,
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Enter your phone number and we'll send you\na four-digit SMS code",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Verfication code',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.grey.shade200,
                        activeColor: Colors.grey.shade200,
                        inactiveColor: Colors.grey.shade200,
                        inactiveFillColor: Colors.grey.shade200,
                        selectedFillColor: Colors.grey.shade200,
                        selectedColor: Colors.grey.shade200,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textPin,
                      keyboardType: TextInputType.number,

                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.watch_later,
                        color: Colors.grey.shade400,
                      ),
                      Text('Code\'ll be active for another $_start seconds')
                    ],
                  ),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color(0xFF2A6049),
                ),
                onPressed: () async {
                  startTimer();
                  if (textPhone.text == "9999999999") {
                  } else {
                    if (!processing) {
                      processing = await _authController.phoneAuth(
                          "+91" + textPhone.text.trim(), context);
                    } else {
                      _authController.signInWithPhoneNumber(
                          textPin.text, context);
                    }
                  }
                },
                child: Text(
                  processing ? 'Done' : 'Next',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 35,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'I already have an account',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
