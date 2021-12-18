import 'package:calcutta_ref/controllers/api_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateAddress extends StatelessWidget {
  const UpdateAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = '';
    int mobile = 0;
    String email = '';
    String street = '';
    String landMark = '';
    String city = '';
    int pinCode = 0;

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: FutureBuilder<DocumentSnapshot>(
              future: Api().fetchProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                name = snapshot.data!['name'];
                mobile = snapshot.data!['mobile'];
                email = snapshot.data!['email'];
                street = snapshot.data!['street'];
                landMark = snapshot.data!['landMark'];
                city = snapshot.data!['city'];
                pinCode = snapshot.data!['pincode'];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Center(
                        child: Text(
                          'Complete Your Profile',
                          style: GoogleFonts.ubuntu(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 550.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50.w,
                                child: Text(
                                  'Name:',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                height: 50.h,
                                width: 260.w,
                                child: TextFormField(
                                  initialValue: snapshot.data!['name'],
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (input) {
                                    name = input;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "First Name",
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 50.w,
                                child: Text(
                                  'Mobile:',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                height: 50.h,
                                width: 260.w,
                                child: TextFormField(
                                  initialValue: snapshot.data!['mobile'] != 0
                                      ? snapshot.data!['mobile'].toString()
                                      : null,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (input) {
                                    mobile = int.parse(input);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Contact Mobile",
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 50.w,
                                child: Text(
                                  'Email:',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                height: 50.h,
                                width: 260.w,
                                child: TextFormField(
                                  initialValue: snapshot.data!['email'],
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (input) {
                                    email = input;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Address:',
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: 40.h,
                            width: 300.w,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              initialValue: snapshot.data!['street'],
                              onChanged: (input) {
                                street = input;
                              },
                              decoration: InputDecoration(
                                hintText: "Street",
                                fillColor: Colors.white,
                                focusColor: Colors.green,
                                hoverColor: Colors.green,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 40.h,
                            width: 300.w,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              initialValue: snapshot.data!['landMark'],
                              onChanged: (input) {
                                landMark = input;
                              },
                              decoration: InputDecoration(
                                hintText: "LandMark",
                                fillColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40.h,
                                width: 140.w,
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  initialValue: snapshot.data!['city'],
                                  onChanged: (input) {
                                    city = input;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "City",
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40.h,
                                width: 140.w,
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  initialValue: snapshot.data!['pincode'] != 0
                                      ? snapshot.data!['pincode'].toString()
                                      : null,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (input) {
                                    pinCode = int.parse(input);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Pin Code",
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.85, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color(0xFF2A6049),
                        ),
                        onPressed: () {
                          Api().updateProfile(
                              name: name,
                              email: email,
                              mobile: mobile,
                              street: street,
                              landMark: landMark,
                              city: city,
                              pincode: pinCode);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Submit',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    ));
  }
}
