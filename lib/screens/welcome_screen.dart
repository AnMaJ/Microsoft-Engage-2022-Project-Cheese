//This is the welcome screen of the application

import 'package:cheese/screens/signup_page.dart';
import 'package:cheese/ui/colour_palate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';




class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);


  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {


  @override
  void initState() {
    super.initState();
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Color_palate().background,
        body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //Title and page decoration
              SizedBox(height: 95.0),
              Text('CHEESE',
                style: GoogleFonts.josefinSans(fontSize: 40.0),
              ),
              SizedBox(height: 40.0),
              Image.asset(
                'assets/images/welcome_screen.png',
                height: 300,
                width: 300,
              ),
              SizedBox(height: 25.0),
              Text('Welcome',
                style: GoogleFonts.readexPro(fontSize: 30),
              ),
              Text(
                'Help a lost child reach its home',
                style: GoogleFonts.readexPro(fontSize: 20),
              ),
              SizedBox(height: 50.0),

              //Sign Up button
              Container(width: 200.0,
                height: 50.0,
                child: ElevatedButton(

                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                    primary: Color_palate().text,
                    elevation: 10.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,5.0),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.readexPro(fontSize: 25),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              //Login button
              Container(
                width: 200.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                    primary: Color_palate().text,
                    elevation: 10.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,5.0),
                    child: Text(
                      'Login',
                      style: GoogleFonts.readexPro(fontSize: 25)

                    ),
                  ),
                ),
              ),

              //Mentioning my name :)
              SizedBox(height:35.0),
              Divider(thickness:1.0),
              SizedBox(height:5.0),
              Text('Created by Mansi',
                style: GoogleFonts.josefinSans(
                    fontSize: 20.0,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        )
        )
    );
  }
}