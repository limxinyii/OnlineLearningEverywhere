import 'package:flutter/material.dart';
import 'package:ole/coursedetail.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'user.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'course.dart';

double perpage = 1;

class TabScreen2 extends StatefulWidget {
  final User user;

  TabScreen2({Key key, this.user});

  @override
  _TabScreen2State createState() => _TabScreen2State();
}

class _TabScreen2State extends State<TabScreen2> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    init();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: RefreshIndicator(
            key: refreshKey,
            color: Colors.blue,
            onRefresh: () async {
              await refreshList();
            },
            child: ListView.builder(
                itemCount: data == null ? 1 : data.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Discover',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Choose your course',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13)),
                          SizedBox(height: 40),
                          Text('Popular Courses',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }
                  if (index == data.length && perpage > 1) {
                    return Container(
                      width: 250,
                      color: Colors.white,
                      child: MaterialButton(
                        child: Text(
                          "Load More",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                      ),
                    );
                  }
                  index -= 1;
                  return Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () => _onCourseDetail(
                          data[index]['courseid'],
                          data[index]['coursename'],
                          data[index]['courseduration'],
                          data[index]['coursedes'],
                          data[index]['courseimage'],
                          data[index]['postdate'],
                          //data[index]['userenroll'],
                          //widget.user.email,
                          //widget.user.name,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //border: Border.all(color: Colors.blueGrey),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "http://myondb.com/oleproject/images/${data[index]['courseimage']}.png")))),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(data[index]['coursename'].toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Duration: " +
                                          data[index]['courseduration']),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ));
  }

  Future<String> makeRequest() async {
    String urlCourse = "http://myondb.com/oleproject/php/load_course.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    pr.show();
    http.post(urlCourse, body: {
      "email": widget.user.email,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["course"];
        perpage = (data.length / 10);
        print("data");
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onCourseDetail(
    String courseid,
    String coursename,
    String courseduration,
    String coursedes,
    String courseimage,
    String postdate,
    //String userenroll,
    // String email,
    //String name
  ) {
    Course course = new Course(
        courseid: courseid,
        coursename: coursename,
        courseduration: courseduration,
        coursedes: coursedes,
        courseimage: courseimage,
        postdate: postdate,
        //userenroll: null
        );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CourseDetail(course: course, user: widget.user)));
  }
}
