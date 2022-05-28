import 'package:cheese/ui/colour_palate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home_page.dart';
import 'login_page.dart';




class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}



class _SignUpPageState extends State<SignUpPage> {

  //defining the signup credentials
  String email = '';
  String password = '';
  String phone_no='';
  String name= '';
  String location= 'x';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child:
              Text(
                  'Sign Up',
                  style: GoogleFonts.readexPro(fontSize: 30)
              ),
          ),
          backgroundColor: Color_palate().app_bar,
          toolbarHeight: 70.0,
        ),

        backgroundColor: Color_palate().background,

        body:SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                //Top image
                Image.asset('assets/images/signin_page.jpeg'),

                //Form fields

                //email
                Container(
                  width:370,
                  child: TextFormField(
                    onChanged: (val){
                      email = val;
                      print(email);
                    },
                    cursorColor: Color_palate().text,
                    decoration: InputDecoration(
                      labelText: "Email ID",
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

                //password
                Container(
                  width:370,
                  child: TextFormField(
                    onChanged: (val){
                      password = val;
                      print(password);
                    },
                    obscureText: true,
                    cursorColor: Color_palate().text,
                    decoration: InputDecoration(
                      labelText: "Password",
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

                //user name
                Container(
                  width:370,
                  child: TextFormField(
                    onChanged: (val){
                      name = val;
                      print(name);
                    },
                    cursorColor: Color_palate().text,
                    decoration: InputDecoration(
                      labelText: "Name",
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

                //user phone number
                Container(
                  width:370,
                  child: TextFormField(
                    onChanged: (val){
                      phone_no = val;
                      print(phone_no);
                    },
                    cursorColor: Color_palate().text,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
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
                SizedBox(height: 40.0),

                //Sign Up Button
                Container(
                  height: 70.0,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async{
                      try {
                        //User authentication
                        final uid = await FirebaseAuth.instance.currentUser?.uid;
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email,
                            password: password
                        );

                        //Adding data to database
                        await FirebaseFirestore.instance.collection('users')
                            .doc(email)
                            .set({
                          'name' : name,
                          'email': email,
                          'uid' : uid,
                          'Location': location,
                          'password': password,
                          'phone number': phone_no
                        }).then((value) {
                          //if all done well, taking the user to home page
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home(
                                  name: name,
                                  email: email)
                              )
                          );
                        }
                        ).catchError((err) {
                          print(err);
                        });

                      }
                      //Checking for exceptions
                      on FirebaseAuthException catch (e) {

                        //weak password
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(
                              'Please provide a password at least 6 characters long'
                          ),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.fromLTRB(35.0, 0, 35.0, 10.0),
                            backgroundColor: Color_palate().app_bar,));
                        }

                        //pre existing account
                        else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(
                              'An account already exists for this email'
                          ),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.fromLTRB(35.0, 0, 35.0, 10.0),
                            backgroundColor: Color_palate().app_bar,));
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                      primary: Color_palate().app_bar,
                      elevation: 10.0,
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.readexPro(fontSize: 25),
                    ),
                  ),
                ),

                //Bottom of the page
                SizedBox(height: 20.0),
                Divider(thickness: 2.0),
                SizedBox(height: 5.0),
                Center(
                  child: Row(
                    children: [

                      //taking the user directly to login page if he/she is already registered
                      SizedBox(width: 110.0),
                      Text("Already have an account?",
                        style: TextStyle(fontSize: 15.0),
                      ),

                      GestureDetector(onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginScreen( )));
                      },
                          child: Text('Login',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15.0
                              )
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        )
    );
  }
}