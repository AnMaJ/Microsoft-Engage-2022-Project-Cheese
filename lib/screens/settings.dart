import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/colour_palate.dart';
import 'Home_page.dart';
import 'login_page.dart';




class settings extends StatefulWidget {
  settings({Key? key,required this.email,required this.password,required this.name}) : super(key: key);
  //attributes fetched from previous page
  String email='';
  String? name='';
  String? password='';
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {

  //user data fields
  String currentPassword='';
  String newPassword='';
  String email='';
  String? name='';
  String phone_number='';

  //calling instance of firestore to update data
  CollectionReference users = FirebaseFirestore.instance.collection('users');



  Future<void> updatePhoneNumber() {
    // Call the user's CollectionReference to update phone number
    return users
        .doc(widget.email)
        .update({'phone number': phone_number})
        .then((value) => print("Phone_number Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }


  //Function to reset password
  @override
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
            title: Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Update  profile',
                  style: GoogleFonts.readexPro(fontSize: 30)
                  ),
              ],
            )
            ),
            backgroundColor: Color_palate().app_bar,
            toolbarHeight: 70.0,
          ),
          backgroundColor: Color_palate().background,
          body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    //Form to get new phone number
                    Container(
                      width:370,
                      child: TextFormField(
                        onChanged: (val){
                          name = val;
                        },
                        initialValue: phone_number,
                        cursorColor: Color_palate().text,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                              color: Colors.brown[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                          ),
                          contentPadding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                          fillColor: Color_palate().text,
                          focusedBorder:OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color_palate().text,
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 70.0,
                      width: 350,
                      child: ElevatedButton(
                        onPressed: () async{
                          resetPassword(widget.email as String);
                          updatePhoneNumber();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  Home(name:name!,email: widget.email)
                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                          primary: Color_palate().button,
                          elevation: 10.0,
                        ),
                        child: Text(
                          'Update Phone Number',
                          style: GoogleFonts.readexPro(fontSize: 25),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 70.0,
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async{
                          resetPassword(widget.email);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                content: Text('Password reset link is sent to your registered email id'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.fromLTRB(35.0, 0, 35.0, 10.0),
                                backgroundColor: Color_palate().button
                          )
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  LoginScreen( )
                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                          primary: Color_palate().button,
                          elevation: 10.0,
                        ),
                        child: Text(
                          'Change Password',
                          style: GoogleFonts.readexPro(fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          )
      );
  }
}