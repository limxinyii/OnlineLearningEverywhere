import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ole/coursedetail.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'adminscreen.dart';
import 'course.dart';
import 'admin.dart';




class UploadVideo extends StatefulWidget {
  final Course course;
  final Admin admin;

  const UploadVideo({Key key, this.course, this.admin}) : super(key: key);

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Upload Video for ' + widget.course.coursename),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: DetailInterface(
                course: widget.course,
              ),
            ),
          )),
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

class DetailInterface extends StatefulWidget {
  final Course course;
  DetailInterface({this.course});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  File _video;
String urlUpload = 'http://myondb.com/oleproject/php/upload.php';

   Future getVideoGallery() async {
    var imageFile = await ImagePicker.pickVideo(source: ImageSource.gallery);

    setState(() {
      _video = imageFile;
    });
  }

  Future getVideoCamera() async {
    var imageFile = await ImagePicker.pickVideo(source: ImageSource.camera);
    setState(() {
      _video = imageFile;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      SizedBox(height: 10),
      _video == null ? Text("Upload a video") : Text("Video is selected"),
      Row(children: <Widget>[
        RaisedButton(
          child: Icon(Icons.video_library),
          onPressed: getVideoGallery,
        ),
        RaisedButton(
          child: Icon(Icons.videocam),
          onPressed: getVideoCamera,
        ),
        RaisedButton(
          child: Text("UPLOAD video"),
          onPressed: () {
            _uploadVideo();
          },
        ),
      ])
    ]));
  }
void _uploadVideo(){
  if (_video == null) {
    Toast.show("Please select a video", context,
    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    return;
  }
ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    pr.show();
    String base64Image = base64Encode(_video.readAsBytesSync());
    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "courseid": widget.course.courseid
    }).then((res) {
      print(res.statusCode);
      Toast.show(res.body, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _video = null;

        pr.dismiss();

      if(res.body == "success") {
         Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        pr.dismiss();

      }else{
        pr.dismiss();
        Toast.show(res.body + ". Please try again", 
        context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    }
);
}
}