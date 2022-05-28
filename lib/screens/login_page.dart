import 'package:cheese/screens/security_check_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/colour_palate.dart';
import 'Home_page.dart';
import 'Report_page.dart';
import 'signup_page.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {

  //defining input variables for user login
  String email = '';
  String password = '';
  String name=' ';

  //Password reset function
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
              children: [
                SizedBox(width: 80,),
                Text('Login',
                    style: GoogleFonts.readexPro(fontSize: 30)
                ),
              ],
            ),
            ),
            backgroundColor: Color_palate().app_bar,
            toolbarHeight: 70.0,
          ),
          backgroundColor: Color_palate().background,


          body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    //Top image
                    Container(
                        height:237.0,
                        width: 450.0,
                        child: Image.asset('assets/images/login_background.jpeg')
                    ),
                    SizedBox(height:50),

                    //Fields for filling in login credentials

                    //email
                    Container(
                      width:370,
                      child: TextFormField(
                        onChanged: (val){
                          email = val;
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
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    //password
                    Container(
                      width:370,
                      child: TextFormField(
                        onChanged: (val){
                          password = val;
                        },
                        obscureText: true,
                        cursorColor: Color_palate().text,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Color_palate().text,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
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
                    SizedBox(height: 50),

                    //Login Button
                    Container(
                      height: 70,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async{
                          try {
                            //Waiting for firebase authentication
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: email,
                                password: password
                            );

                            //Getting collection ref from firestore database to get the username to pass it onto the next page
                            CollectionReference users = FirebaseFirestore.instance.collection('users');
                            DocumentSnapshot ds= await users.doc(email).get();

                            //Moving to next page if the user is authenticated
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Home(
                                            name: ds.get('name'),
                                            email: email
                                        )
                                )
                            );
                          } on
                          //Catching errors and giving snackbar notification accordingly
                          FirebaseAuthException catch (e) {

                            //user not found
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(
                                  'No user found for this email'
                              ),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.fromLTRB(35.0, 0, 35.0, 10.0),
                                backgroundColor: Colors.redAccent,));
                            }

                            //Wrong password
                            else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('Wrong password'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.fromLTRB(35.0, 0, 35.0, 10.0),
                                backgroundColor: Colors.redAccent,));
                            }
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                          primary: Color_palate().app_bar,
                          elevation: 10.0,
                        ),
                        child: Text(
                          'Login',
                          style: GoogleFonts.readexPro(fontSize: 25),

                        ),
                      ),
                    ),

                    SizedBox(height: 50.0),
                    Container(
                      height: 70.0,
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () async{
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: email,
                                password: password
                            );
                            final uid = await FirebaseAuth.instance.currentUser?.uid;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SecurityCheck(uid: uid)
                                )
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('No user found for this email'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.fromLTRB(35.0, 0, 35.0, 10.0),
                                backgroundColor: Colors.redAccent,));
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('Wrong password'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.fromLTRB(35.0, 0, 35.0, 10.0),
                                backgroundColor: Colors.redAccent,));
                              print('Wrong password provided for that user.');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                          primary: Color_palate().app_bar,
                          elevation: 10.0,
                        ),
                        child: Text(
                          'Login as Police',
                          style: GoogleFonts.readexPro(fontSize: 25),
                        ),
                      ),
                    ),


                    //Foot of the page

                    SizedBox(height: 20.0),
                    Divider(thickness: 2.0),
                    SizedBox(height: 10.0),
                    Center(
                      child: Row(
                        children: [

                          //Taking user directly to signup screen if he/she has not made an account yet

                          SizedBox(width: 110.0),
                          Text("Don't have an account?  ",
                            style: TextStyle(fontSize: 15.0),),
                          GestureDetector(onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SignUpPage( )
                                )
                            );
                          },
                              child: Text('Sign Up',
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

                    //Giving user option to reset password if forgot
                    GestureDetector(onTap: (){
                      resetPassword(email);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content:
                            Text('Password reset link is sent to your registered email id'),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.fromLTRB(35.0, 0, 35.0, 10.0),
                        backgroundColor:Color_palate().app_bar,
                      )
                      );
                    },
                        child: Text('Forgot Password?',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15.0
                            )
                        )
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              )
          )
      );
  }
}