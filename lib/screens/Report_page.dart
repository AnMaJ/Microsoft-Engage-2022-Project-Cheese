import 'dart:io' as io;
import 'dart:math';
import 'dart:typed_data';
import 'package:cheese/ui/colour_palate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';




class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  UploadTask? uploadTask;
  BuildContext? context1;

  //Child Info
  String? image_url;
  String name='';
  String age='';
  String parent_email='';
  String police_email='';
  String police_station='';
  String parent_phone_no='';
  String? userid=Random.secure().nextInt(100000000).toString();
  var img=Image.asset('assets/images/missing_child.png');
  var img1;

  //initializations
  CollectionReference lost_child = FirebaseFirestore.instance.collection('lost_child_data');

  //Function to set the image to be displayed
  setImage(List<int> imageFile) {
    if (imageFile == null) return;
      setState(() {
        img = Image.memory(Uint8List.fromList(imageFile));
      });
  }

  //Function to upload the child's image on firestore
  Future<void> uploadFile() async{
    final path= 'files/${userid}';
    if(img1==null){
      print('null hai bahi');
    }
    final file=io.File(img1!.path);
    final ref= FirebaseStorage.instance.ref().child(path);
    uploadTask=ref.putFile(file);

    //getting the url of image stored on firestore
    final snapshot=await uploadTask!.whenComplete(() {});
    final urlDownload=await snapshot.ref.getDownloadURL();
    image_url=urlDownload;
  }


  //Snackbar that accepts a string
  Future<void> showSnackbar(String msg) async{
    final snackbar=SnackBar(content: Text(msg,style: TextStyle(fontSize: 20)),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context1!)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }


  //Function to add child record to firestore
  Future<void> addDataToFirestore() async {
    await FirebaseFirestore.instance.collection('lost_child_data')
        .doc(userid)
        .set({
      'Name': name,
      'Age': age,
      'uid': userid,
      "Parent's_email_id": parent_email,
      "Parent's_phone_number": parent_phone_no,
      "Police_station's_email_id": police_email,
      "Registered_lost_at_police_station": police_station,
      "img_url": image_url
    }).then((value) {
      showSnackbar('Child Added to database successfully!');
    }).catchError((e) {
      print(e);
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child:
              Text(
                  'Report Lost Child',
                   style: GoogleFonts.readexPro(fontSize: 30)
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
                  //Child image
                  Image(
                      height: 500,
                      width: 500,
                      image: img.image
                  ),
                  SizedBox(height: 20.0),

                  //Button to get child's image
                  Container(width: 300.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () async{
                        //Picking image from gallery only as at the time of reporting, the child woudn't be preset to click a live picture of
                        PickedFile image = (await ImagePicker()
                            .getImage(source: ImageSource.gallery)) as PickedFile;
                        setImage(
                          io.File(image!.path).readAsBytesSync(),
                        );
                        img1=image;
                        //Uploading the image to firestore here itself(it takes time to get uploaded, so, while the police is filling other info, the images gets uploaded
                        await uploadFile();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: Color_palate().text,
                        elevation: 10.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                        child: Text(
                          "Select Image",
                          style: GoogleFonts.readexPro(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 95.0),

                  //Lost child info form
                  Container(
                    width: 370,
                    child: TextFormField(
                      onChanged: (val) {
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
                        focusedBorder: OutlineInputBorder(
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
                    width: 370,
                    child: TextFormField(
                      onChanged: (val) {
                        age = val;
                        print(age);
                      },
                      cursorColor: Color_palate().text,
                      decoration: InputDecoration(
                        labelText: "Age",
                        labelStyle: TextStyle(
                            color: Color_palate().text,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                        fillColor: Color_palate().text,
                        focusedBorder: OutlineInputBorder(
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
                    width: 370,
                    child: TextFormField(
                      onChanged: (val) {
                        parent_phone_no = val;
                        print(parent_phone_no);
                      },
                      cursorColor: Color_palate().text,
                      decoration: InputDecoration(
                        labelText: "Parent's Phone Number",
                        labelStyle: TextStyle(
                            color: Color_palate().text,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                        fillColor: Color_palate().text,
                        focusedBorder: OutlineInputBorder(
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
                    width: 370,
                    child: TextFormField(
                      onChanged: (val) {
                        parent_email = val;
                        print(parent_email);
                      },
                      cursorColor: Color_palate().text,
                      decoration: InputDecoration(
                        labelText: "Parent's email id",
                        labelStyle: TextStyle(
                            color: Color_palate().text,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                        fillColor: Color_palate().text,
                        focusedBorder: OutlineInputBorder(
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
                    width: 370,
                    child: TextFormField(
                      onChanged: (val) {
                        police_email = val;
                        print(police_email);
                      },
                      cursorColor: Color_palate().text,
                      decoration: InputDecoration(
                        labelText: "Police Station's email id",
                        labelStyle: TextStyle(
                            color: Color_palate().text,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                        fillColor: Color_palate().text,
                        focusedBorder: OutlineInputBorder(
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
                    width: 370,
                    child: TextFormField(
                      onChanged: (val) {
                        police_station = val;
                        print(police_station);
                      },
                      cursorColor: Color_palate().text,
                      decoration: InputDecoration(
                        labelText: "Name of Police Station",
                        labelStyle: TextStyle(
                            color: Color_palate().text,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                        fillColor: Color_palate().text,
                        focusedBorder: OutlineInputBorder(
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
                    width: 200.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        context1 = context;
                        addDataToFirestore();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: Color_palate().text,
                        elevation: 10.0,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                        child: Text(
                            'Upload File',
                            style: GoogleFonts.readexPro(fontSize: 25)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35.0),
                ],
              ),
            )
        )
    );
  }
}