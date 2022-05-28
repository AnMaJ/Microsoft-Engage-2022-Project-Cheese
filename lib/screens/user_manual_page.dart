import 'package:cheese/ui/colour_palate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Use extends StatefulWidget {
  const Use({Key? key}) : super(key: key);

  @override
  _UseState createState() => _UseState();
}

class _UseState extends State<Use> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("How to use",
            style: GoogleFonts.readexPro(fontSize: 30)),
          backgroundColor: Color_palate().app_bar,
          toolbarHeight: 70.0,
        ),
        backgroundColor: Color_palate().background,
        body: SingleChildScrollView(
            child: Column(
                children:[



                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 500.0,
                      child: ElevatedButton(


                        style: ElevatedButton.styleFrom(shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Color_palate().app_bar, width: 2),
                        ),
                          primary: Color.fromRGBO(237,250,246, 1),
                          elevation: 10.0,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 20.0,),
                              Text('Welcome to Cheese App!', style: TextStyle(color: Colors.black54,fontSize: 20.0)),
                              Text(' '),
                              Text('Help a lost child reach its home!', style: TextStyle(color: Colors.black54,fontSize: 20.0)),
                              Text(' '),
                              Text('How to use', style: TextStyle(color: Colors.black54,fontSize: 20.0)),
                              Text(' '),
                              Text( 'Go to Scan Lost child page, and tap on the child icon. You will be asked to select the picture of the child either using your camera or any picture from your gallery.',
                                  style: TextStyle(color: Colors.black54,fontSize: 20.0)),
                              Text(' '),
                              Text( 'Now, simply tap on the Search Lost Child button, and we will search for the lost child in our databse. Please be patient, it might take a while to check all the images in our databse.',
                                  style: TextStyle(color: Colors.black54,fontSize: 20.0)),
                              Text(' '),
                              Text("If the child is matched with any image in our database, the poilce and child's parents would be notified with the child's current(your) location and your details that you filled while registering for the app(except your password).", style: TextStyle(color: Colors.black54,fontSize: 20.0)),
                              Text(' '),
                              Text('You can also change your password and phone number(in case you have changed your phone number) via the settings page.', style: TextStyle(color: Colors.black54,fontSize: 20.0)),
                              Text(' '),
                              Text('Thank You So Much :)', style: TextStyle(color: Colors.black54,fontSize: 20.0)),
                              SizedBox(height: 10.0,)
                            ],
                          ),
                        ),
                        onPressed: (){
                        },),
                    ),
                  ),

                ]
            ))

    );
  }
}