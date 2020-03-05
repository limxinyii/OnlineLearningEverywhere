import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ole/coursedetail.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'adminscreen.dart';
import 'course.dart';
import 'admin.dart';

String urlUpload = 'http://myondb.com/oleproject/php/upload_video.php';

class UploadContent extends StatefulWidget {
  final Course course;
  final Admin admin;
  const UploadContent({Key key, this.course, this.admin}) : super(key: key);

  @override
  _UploadContentState createState() => _UploadContentState();
}

class _UploadContentState extends State<UploadContent> {
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
            uploadVideo(_video, widget.course,context);
          },
        ),
      ])
    ]));
  }
}

Future uploadVideo(File videoFile, Course course,BuildContext context) async {
  print(course.courseid);
  print(videoFile.toString());
  var uri = Uri.parse("http://myondb.com/oleproject/php/upload.php");
  var request = new MultipartRequest("POST", uri);
  var multipartFile = await MultipartFile.fromPath("video", videoFile.path);
  request.files.add(multipartFile);
  StreamedResponse response = await request.send();
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
  
  if (response.statusCode == 200) {
    print("Video uploaded");
    ProgressDialog pr = new ProgressDialog(context,
    type: ProgressDialogType.Normal, isDismissible: false);
  //pr.style(message: "Enroll Course");
  //pr.show();
    http.post(urlUpload, body: {
      "courseid": course.courseid,
      "video": videoFile.toString(),
    }).then((res) {
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      } else {
        print("Video upload failed");
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }
}
