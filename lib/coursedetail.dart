import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ole/textstyle.dart';
import 'user.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'course.dart';
import 'mainscreen.dart';

class CourseDetail extends StatefulWidget {
  final Course course;
  final User user;

  const CourseDetail({Key key, this.course, this.user}) : super(key: key);

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(widget.course.coursename, style: TextStyles.TextButton),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              //padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                course: widget.course,
                user: widget.user,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Course course;
  final User user;
  DetailInterface({this.course, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                height: media.height * 0.20,
                width: media.width,
                decoration: BoxDecoration(color: Colors.blue),
              )
            ]),
            Padding(
              padding: EdgeInsets.only(top: 50, left: 35, right: 35, bottom: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'http://myondb.com/oleproject/images/${widget.course.courseimage}.png',
                  fit: BoxFit.cover,
                  //height: 150,
                ),
              ),
            ),
          ],
        ),
        Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 9),
                child: Icon(
                  Icons.star,
                  color: Colors.teal[300],
                  //size: 20,
                ),
              ),
              SizedBox(width: 5),
              Container(
                padding: EdgeInsets.only(top: 9),
                child: Text(
                  widget.course.coursename,
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 17, letterSpacing: 0.6),
                ),
              ),
            ],
          )
        ]),
        Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Course Details', style: TextStyles.boldtitle),
                  SizedBox(width: 3),
                  Column(children: <Widget>[
                    Icon(
                      Icons.book,
                      color: Colors.teal[300],
                      size: 22,
                    ),
                  ]),
                ],
              ),
              Divider(
                height: 12,
                color: Colors.teal,
                thickness: 3,
                endIndent: media.width / 1.5,
              ),
              SizedBox(height: 20),
              Text('Difficult',
                  style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      color: Colors.grey,
                      fontSize: 15)),
              SizedBox(height: 4),
              Text('Easy', style: TextStyles.btitle),
              SizedBox(height: 20),
              Text('Duration',
                  style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      color: Colors.grey,
                      fontSize: 15)),
              SizedBox(height: 4),
              Text(widget.course.courseduration, style: TextStyles.btitle),
              SizedBox(height: 20),
              Text('About', style: TextStyles.btitle),
              SizedBox(height: 5),
              Text(
                widget.course.coursedes,
                style: TextStyles.title,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        SizedBox(height: 28),
        Center(
            child: Container(
          width: 200,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            height: 50,
            child: Text(
              'Enroll Course',
              style: TextStyle(fontSize: 16),
            ),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 5,
            onPressed: _onEnroll,
          ),
        )),
        SizedBox(height: 20)
      ],
    ));
  }

  void _onEnroll() {
    if (widget.user.email == "user@noregister") {
    } else {
      _showDialog();
    }
    print("Enroll Course");
  }

  void _showDialog() {
    //flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enroll course of " + widget.course.coursename),
          content: Text("Are you sure?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                enrollCourse();
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> enrollCourse() async {
    String urlCourse = "http://myondb.com/oleproject/php/course_enroll.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Enroll Course");
    pr.show();
    http.post(urlCourse, body: {
      "courseid": widget.course.courseid,
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
        _onLogin(widget.user.email, context);
      } else {
        Toast.show("Course Enrolled", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  void _onLogin(String email, BuildContext ctx) {
    String urlgetuser = "http://myondb.com/oleproject/php/get_user.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            dob: dres[4],
            address: dres[5]);
        //Navigator.push(ctx,
        //  MaterialPageRoute(builder: (context) => CourseContent(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
