import 'package:cheese/screens/Report_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/colour_palate.dart';



class SecurityCheck extends StatefulWidget {
  SecurityCheck({Key? key,required this.uid}) : super(key: key);
  String? uid;

  @override
  State<SecurityCheck> createState() => _SecurityCheckState();
}

class _SecurityCheckState extends State<SecurityCheck> {

  //user data fields
  String? code;

  //calling instance of firestore
  CollectionReference police = FirebaseFirestore.instance.collection('users');


  //function to verify that it is police or not
  Future<bool> verify() async {
    DocumentSnapshot ds= await police.doc(widget.uid).get().catchError((e){
      print(e);
    });
    var security_code= ds.get('security_code');
    if(security_code==code){
      return true;
    }else{
      return false;
    }
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
                    'Verification page',
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
                          code = val;
                        },
                        initialValue: code,
                        cursorColor: Color_palate().text,
                        decoration: InputDecoration(
                          labelText: "Please enter the security code",
                          labelStyle: TextStyle(
                              color: Color_palate().text,
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
                          if(await verify()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    Report()
                                )
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                          primary: Color_palate().button,
                          elevation: 10.0,
                        ),
                        child: Text(
                          'Login',
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