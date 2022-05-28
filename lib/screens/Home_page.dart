import 'package:cheese/screens/settings.dart';
import 'package:cheese/screens/user_manual_page.dart';
import 'package:cheese/screens/welcome_screen.dart';
import 'package:cheese/ui/colour_palate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'Scanning_lost_child_page.dart';




class Home extends StatefulWidget {
  const Home( {Key? key, required this.name, required this.email}) : super(key: key);

  final String name;
  final String email;

  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {


  CollectionReference users = FirebaseFirestore.instance.collection('users');


  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }



  //Function to get the current location of use
  void getCurrentLocation() async{
    await Geolocator.requestPermission();
    var lastPosition= await Geolocator.getLastKnownPosition();
    users
        .doc(widget.email)
        .update({'Location': lastPosition.toString()})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Welcome ${widget.name}",
            style:  GoogleFonts.readexPro(fontSize: 30),
          ),
        ),
        backgroundColor: Color_palate().app_bar,
        toolbarHeight: 70.0,
      ),
      backgroundColor: Color_palate().background,

      body: SingleChildScrollView(
        child: Column(
          children:[
            //Top Image
            Image.asset('assets/images/family.jpeg'),

            //Buttons
            Row(children: <Widget>[

              //Scan Lost child button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 190.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                          color: Color_palate().app_bar,
                          width: 2
                      ),
                    ),
                      primary: Color_palate().light_background,
                      elevation: 10.0,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset('assets/images/missing_child.png'),
                          Text('Scan Lost Child',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20.0
                              )
                          ),
                          SizedBox(height: 10.0,)
                        ],
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Scan(
                              email: widget.email)
                          )
                      );
                    },
                  ),
                ),
              ),

              //How to use / user manual page
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 180.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                          color: Color_palate().app_bar,
                          width: 2
                      ),
                    ),
                      primary: Color_palate().light_background,
                      elevation: 10.0,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height:10),
                          Image.asset('assets/images/userManual.png'),
                          Text(
                              'How to use',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20.0
                              )
                          ),
                          SizedBox(height: 10.0,)
                        ],
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Use()
                          )
                      );
                    },
                  ),
                ),
              ),
            ]
            ),


            Row(
                children: <Widget>[

                  //Settings page
              Padding(
                padding: const EdgeInsets.all(8.0-0.571),
                child: Container(
                  width: 190.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                          color: Color_palate().app_bar,
                          width: 2
                      ),
                    ),
                      primary: Color_palate().light_background,
                      elevation: 10.0,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset('assets/images/settings.png'),
                          Text('Settings',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20.0
                              )
                          ),
                          SizedBox(height: 10.0,)
                        ],
                      ),
                    ),
                    onPressed: ()async{
                      DocumentSnapshot ds= await users.doc(widget.email).get();
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              settings(
                                  email:widget.email as String,
                                  password: ds.get('password'),
                                  name: widget.name)
                          )
                      );
                    }
                    ),
                ),
              ),


                  //Logout
                  Padding(
                    padding: const EdgeInsets.all(8.0-0.571),
                    child: Container(
                      width: 190.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(
                              color: Color_palate().app_bar,
                              width: 2
                          ),
                        ),
                          primary: Color_palate().light_background,
                          elevation: 10.0,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset('assets/images/logout.png'),
                              Text(
                                  'Logout',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20.0
                                  )
                              ),
                              SizedBox(height: 10.0,)
                            ],
                          ),
                        ),
                        onPressed: ()async{
                          getCurrentLocation();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  WelcomeScreen()
                              )
                          );
                        }
                        ),
                    ),
                  ),
            ]
            ),
          ]
      )
      )
    );
  }
}