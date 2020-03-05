import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ole/adminscreen.dart';
import 'package:ole/textstyle.dart';
import 'package:toast/toast.dart';
import 'admin.dart';
import 'course.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:video_player/video_player.dart';
import 'video.dart';


File _image;
//File _video;
//VideoPlayerController _videoPlayerController;
String pathAsset = 'assets/images/photo.png';
String urlUpload = 'http://myondb.com/oleproject/php/upload_course.php';

final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _durationcontroller = TextEditingController();
final TextEditingController _descontroller = TextEditingController();

class AddCourse extends StatefulWidget {
  final Admin admin;

  AddCourse({Key key, this.admin}) : super(key: key);

  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Add Course', style: TextStyles.TextButton),
        ),
        body: SingleChildScrollView(
          //reverse: true,
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: bottom),
            child: AddNewCourse(widget.admin),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => AdminMainScreen(
            admin: widget.admin,
          ),
        ));
    return Future.value(false);
  }
}

class AddNewCourse extends StatefulWidget {
  final Admin admin;
  AddNewCourse(this.admin);
  

  @override
  _AddNewCourseState createState() => _AddNewCourseState();
}


class _AddNewCourseState extends State<AddNewCourse> {

  /*_pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
     _video = video; 
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 35, left: 34),
              child: Container(
                height: 200,
                width: 280,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              right: 30.0,
              bottom: 0,
              child: new FloatingActionButton(
                child: Icon(Icons.add_a_photo),
                onPressed: _choose,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(''),
            _image == null
                ? Text('(*Required)', style: TextStyle(color: Colors.red))
                : Text(''),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _namecontroller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Course Name',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          validator: (value) {
            if (value.length == 0) {
              return 'Name Required';
            } else {
              return null;
            }
          },
          style: TextStyle(fontFamily: "Poppins", fontSize: 15),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _durationcontroller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Course Duration',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          validator: (value) {
            if (value.length == 0) {
              return 'Duration Required';
            } else {
              return null;
            }
          },
          style: TextStyle(fontFamily: "Poppins", fontSize: 15),
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _descontroller,
          keyboardType: TextInputType.text,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Course Description',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          validator: (value) {
            if (value.length == 0) {
              return 'Description Required';
            } else {
              return null;
            }
          },
          style: TextStyle(fontFamily: "Poppins", fontSize: 15),
        ),
        SizedBox(
          height: 20,
        ),
        
     /*Container(
    child: Column(
        children: <Widget>[
            if(_video != null) 
                    _videoPlayerController.value.initialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                )
                : Container()
            else
                Text("Click to select video", style: TextStyle(fontSize: 15.0),),
            RaisedButton(
                onPressed: () {
                    _pickVideo();
                },
                child: Text("Pick Video From Gallery"),
            ),
        ],
    ),
),*/

       
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: MaterialButton(
            child: Text(
              'Add Course',
              style: TextStyles.TextButton,
            ),
            minWidth: 350,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: _onAddCourse,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }


  void _choose() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(40),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 80,
                        maxWidth: double.infinity,
                        maxHeight: 450);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Gallery'),
                  onTap: () async {
                    _image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                        maxWidth: double.infinity,
                        maxHeight: 450);
                    setState(() {});
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

void _onAddCourse(){
  if (_image == null) {
    Toast.show("Please upload course image", context,
    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    return;
  }
  if(_namecontroller.text.isEmpty) {
    Toast.show("Please enter course name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
  }
   if(_durationcontroller.text.isEmpty) {
    Toast.show("Please enter course duration", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
  }
   if(_descontroller.text.isEmpty) {
    Toast.show("Please enter course description", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
  }
  ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "coursename": _namecontroller.text,
      "courseduration": _durationcontroller.text,
      "coursedes": _descontroller.text,
    }).then((res) {
      print(urlUpload);
      Toast.show(res.body, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM
      );
      if(res.body.contains("success")) {
        _image = null;
        //_video = null;
        _namecontroller.text = "";
        _durationcontroller.text = "";
        _descontroller.text = "";
    
    pr.dismiss();
    //Navigator.pushReplacement(
        //context, MaterialPageRoute(builder: (context) => UploadContent()));
    print(widget.admin.email);
    } else {
      pr.dismiss();
      Toast.show(res.body + ". Please try again", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } 
  }).catchError((err) {
    print(err);
    pr.dismiss();
  });
}
}