import 'dart:io';
import 'package:cheese/ui/colour_palate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';



class Scan extends StatefulWidget {
  const Scan({Key? key, required this.email}) : super(key: key);
  final String? email;
  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {

  //defining the images variables
  var image1 = new Regula.MatchFacesImage();
  var image2 = new Regula.MatchFacesImage();
  var img1 = Image.asset('assets/images/missing_child.png');


  //lost child data
  String _name='';
  String _age='';
  String _parent_contact='';
  String _registered_lost_at='';
  String _parent_email='';
  String _police_email='';

  //user's data
  String _username='';
  String _user_contact_number='';
  String _location='';

  //status indictors
  String _similarity = "Search Status";
  BuildContext? context1;
  var matched_id='';
  var color_not_found=Color_palate().c1;
  var color_found=Color_palate().c2;
  var color_final=Color_palate().background;

  //initializations
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  CollectionReference lost_child = FirebaseFirestore.instance.collection('lost_child_data');
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('lost_child_data');



  //Alert Dialog box
  showAlertDialog(BuildContext context, bool first) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Text("Select option"), actions: [

            //using gallery to get the input image

            //ignore: deprecated_member_use
            FlatButton(
                child: Text("Use gallery"),
                onPressed: () {
                  //ignore: deprecated_member_use
                  ImagePicker().getImage(source: ImageSource.gallery).then(
                          (value) => setImage(
                          first,
                          io.File(value!.path).readAsBytesSync(),
                          Regula.ImageType.PRINTED));
                  Navigator.pop(context);
                }
                ),

            //Using camera to get the input image of lost child

            // ignore: deprecated_member_use
            FlatButton(
                child: Text("Use camera"),
                onPressed: () {
                  Regula.FaceSDK.presentFaceCaptureActivity().then((result) =>
                      setImage(
                          first,
                          base64Decode(Regula.FaceCaptureResponse.fromJson(
                              json.decode(result))!
                              .image!
                              .bitmap!
                              .replaceAll("\n", "")),
                          Regula.ImageType.LIVE));
                  Navigator.pop(context);
                }
                )
          ]
          )
  );


  //setting image to appropriate format to send to the api
  setImage(bool first, List<int> imageFile, int type) {
    if (imageFile == null) return;
    setState(() => _similarity = "Search Status");
    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      setState(() {
        img1 = Image.memory(Uint8List.fromList(imageFile));
      }
      );
    }
  }


  //Widget to create an image
  Widget createImage(image, VoidCallback onPress) => Material(
      child: InkWell(
        onTap: onPress,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
                height: 500,
                width: 500,
                image: image
            ),
          ),
        ),
      )
  );

  //Function to show snackbar taking input the snackbar message
  Future<void> showSnackbar(String msg) async{
    final snackbar=SnackBar(content: Text(msg,style: TextStyle(fontSize: 20)),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context1!)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }


  //Function to get the lost child data
  Future<void> getLostChildData() async{

    DocumentSnapshot ds= await lost_child.doc(matched_id).get();

    //getting the child's data
    setState(await ()=>_name=ds.get('Name'));
    setState(await ()=>_age=ds.get('Age').toString());
    setState(await ()=>_parent_contact=ds.get("Parent's_phone_number"));
    setState(await ()=>_registered_lost_at=ds.get('Registered_lost_at_police_station'));
    setState(await ()=>_parent_email=ds.get("Parent's_email_id"));
    setState(await ()=>_police_email=ds.get("Police_station's_email_id"));

    //next getting the current user's data
    await getUserData();
  }

  //finction to get current user data
  Future<void> getUserData() async{

    DocumentSnapshot ds_user= await user.doc(widget.email).get();

    //getting user data
    setState(await ()=>_username=ds_user.get('name'));
    setState(await ()=>_user_contact_number=ds_user.get('phone number'));
    setState(await ()=>_location=ds_user.get('Location'));

    //sending email to parents
    await sendEmailToParents();

    //sending email to police
    await sendEmailToPolice();

    //showing snackbar upon successful execution of both the above functions
    await showSnackbar("Email sent to parents and police station :)");
  }


  //matching the captured image with each of the images in the database
  //this function returns the uid of lost child if found otherwise null
  Future<String?> matchFaces() async {

    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    //getting all the image urls in img_url list
    final img_url = querySnapshot.docs.map((doc) => doc['img_url']).toList();

    //getting their respective uid in uids list
    final uids= querySnapshot.docs.map((doc) => doc.id).toList();


    //flag to show if there was a match
    bool flag=false;

    //iterating over each of the images in database
    for(int i=0; i<uids.length;i++){

      //processing the image from url to a format that the api accepts
      Uri myUri = Uri.parse(img_url[i]);
      final response = await http.get(myUri);
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = File(join(documentDirectory.path, 'imagetest.png'));
      file.writeAsBytesSync(response.bodyBytes);
      List<int> imageFile1;
      imageFile1=file.readAsBytesSync();
      image2.bitmap = base64Encode(imageFile1);
      image2.imageType = Regula.ImageType.PRINTED;


      //when both the input and database images are processed, checking if there is a match using the face api
      if (image1 == null ||
          image1.bitmap == null ||
          image1.bitmap == "" ||
          image2 == null ||
          image2.bitmap == null ||
          image2.bitmap == "") return null;

      if(_similarity!='Found!'){
      setState(() => {_similarity = "Processing...",matched_id=''});}

      //matching the images
      var request = new Regula.MatchFacesRequest();
      request.images = [image1, image2];
      Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
        var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
        Regula.FaceSDK.matchFacesSimilarityThresholdSplit(jsonEncode(response?.results), 0.75)
            .then((str) {
          var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));

          if(split?.matchedFaces.length!=0){
            setState(() => _similarity = split?.matchedFaces.length!= 0 ? "Found!" : "Searching...");}

          //if found, storing the uid in matched_id variable and returning it
          if(split?.matchedFaces.length==1){
            matched_id=uids[i];
            flag=true;
            setState(()=>_similarity='Found!');
            setState(()=>color_final=color_found);
            getLostChildData();
            return matched_id;
          }

          //if not found, returning null
          if(split?.matchedFaces.length==0 && i==uids.length-1&& flag==false){
            setState(()=>_similarity='Not Found');
            setState(()=>_name='Not Found');
            setState(()=>_age='Not Found');
            setState(()=>_parent_contact='Not Found');
            setState(()=>_registered_lost_at='Not Found');
            setState(()=>color_final=color_not_found);
            return null;
          }
        });
      });

      //Setting _similarity to Searching while the search is going on
      if(i==uids.length-1){
        setState(() => _similarity = "Searching...");
        break;
      }
    }
  }

  //Function to send email to parents
  Future<void> sendEmailToParents() async{

    //defining the api initialzation parameters
    final serviceId='service_fm3ymlj';
    final templateId='template_ru9gpkp';
    final userId='SaGQJusVSIxIMGhiw';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    //connecting to mailing api
    final response=await http.post(
        url,
        headers:{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'lost_child_name': _name,
            'user_name':_username,
            'user_contact_number':_user_contact_number,
            'user_email':widget.email,
            'location':_location,
            'police_address':_registered_lost_at,
            "parent's_email":_parent_email,
          },
          'accessToken': 'x2agF9_IqfXMDOZWJpVXr'
        })
    );
  }

  //Function to send email to police
  Future<void> sendEmailToPolice() async{

    //defining the api initialzation parameters
    final serviceId='service_fm3ymlj';
    final templateId='template_trklkud';
    final userId='SaGQJusVSIxIMGhiw';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');


    //connecting to mailing api
    final response=await http.post(
        url,
        headers:{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'lost_child_name': _name,
            'user_name':_username,
            'user_contact_number':_user_contact_number,
            'police_email': _police_email,
            'user_email':widget.email,
            'location':_location,
            'police_address':_registered_lost_at,
            "parent's_email":_parent_email,
          },
          'accessToken': 'x2agF9_IqfXMDOZWJpVXr'
        })
    );
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Color_palate().background,

    body: SingleChildScrollView(

      child:Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              //displaying the lost child image
              createImage(img1.image, () => showAlertDialog(context, true)),
              Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 15)),

              //Button to search for lost child
              ElevatedButton(
                  onPressed: () async{
                    context1=context;
                    setState(()=>_name='Searching...');
                    setState(()=>_age='Searching...');
                    setState(()=>_parent_contact='Searching...');
                    setState(()=>_registered_lost_at='Searching...');

                    //matching the input image with the images in database
                    await matchFaces();
                  },
                  style: ElevatedButton.styleFrom(
                      shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                    primary: Color_palate().app_bar,
                    elevation: 10.0,
                    padding: EdgeInsets.all(10)
                  ),
                  child: Text(
                    "    Search for lost child    ",
                    style: GoogleFonts.readexPro(fontSize: 25),
                  )
              ),


              SizedBox(height: 20.0),
              Divider(thickness: 2.0),

              //displaying the lost child info if found
              Container(
                //changing the color of the search status on according to the child found or lost status
                  color: color_final,
                  height: 48.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( _similarity,
                          style: GoogleFonts.readexPro(fontSize: 25),),
                    ],
                  )
              ),

              Divider(thickness: 2.0),
              SizedBox(height: 20.0),
              Row(children: <Widget>[
                SizedBox(width: 20.0),
                Text("Name: " + _name,
                  style: GoogleFonts.readexPro(fontSize: 25),)
                ,SizedBox(width: 20.0),
              ]
              ),
              SizedBox(height: 20.0),
              Row(children: <Widget>[
                SizedBox(width: 20.0),
                Text("Age: " + _age,
                  style: GoogleFonts.readexPro(fontSize: 25),
                ),
                SizedBox(width: 20.0),
              ]
              ),
              SizedBox(height: 20.0),
              Row(children: <Widget>[
                SizedBox(width: 20.0),
                Text("Parent's phone number: \n" + _parent_contact,
                  style: GoogleFonts.readexPro(fontSize: 25),),
                SizedBox(width: 20.0),
              ]
              ),
              SizedBox(height: 20.0),
              Row(children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                    "Registered lost at police \nstation: "+
                      '\n ${_registered_lost_at}',
                    maxLines: 20,
                    style: GoogleFonts.readexPro(fontSize: 25),
                  ),
                )
              ]
              ),
            ]
        )
      ),
    )
  );
}