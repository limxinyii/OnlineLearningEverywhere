import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ole/textstyle.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'adminscreen.dart';
import 'course.dart';
import 'admin.dart';

String urlUpload = 'http://myondb.com/oleproject/php/upload_video.php';

class UploadContent extends StatefulWidget {
  final Course course;
  final Admin admin;

  const UploadContent({
    Key key,
    this.course,
    this.admin,
  }) : super(key: key);

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
            title: Text(
              'Upload Content',
              style: TextStyles.TextButton,
            ),
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

  /*Future getVideoCamera() async {
    var imageFile = await ImagePicker.pickVideo(source: ImageSource.camera);
    setState(() {
      _video = imageFile;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          Row(children: <Widget>[
            SizedBox(width: media.width / 4.5),
            MaterialButton(
              //child: Icon(Icons.video_library),
              onPressed: getVideoGallery,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/video.png',
                    width: 200,
                  ),
                  _video == null
                      ? Text('Click to select video from gallery')
                      : Text('Video Selected',
                          style: TextStyle(color: Colors.deepOrange)),
                ],
              ),
            ),
            /* RaisedButton(
          child: Icon(Icons.videocam),
          onPressed: getVideoCamera,
        ),*/
            /*RaisedButton(
          child: Text("Upload video"),
          onPressed: () {
            uploadVideo(_video, widget.course,context);
          }, 
        ),*/
          ]),
          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            child: MaterialButton(
              child: Text(
                'Upload Video',
                style: TextStyles.TextButton,
              ),
              minWidth: 250,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () {},
              color: Colors.blue,
            ),
          )
        ]);
  }
}

Future uploadVideo(File videoFile, Course course, BuildContext context) async {
  //print(course.courseid);
  //print(videoFile.toString());
  ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false);
  pr.style(message: "Uploading...");
  pr.show();
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
    http.post(urlUpload, body: {
      "courseid": course.courseid,
      //"video_id": video.video_id,
    }).then((res) {
      if (res.body == "success") {
        print(videoFile.path);
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
