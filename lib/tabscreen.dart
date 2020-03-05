import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user.dart';
import 'course.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

double perpage = 1;

class TabScreen extends StatefulWidget {
  final User user;
  final Course course;
  TabScreen({Key key, this.user,this.course}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
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
        //backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        /*appBar: AppBar(
          //centerTitle: true,
        // backgroundColor: Colors.white,
          title: Text(
            "OLE",
            style: TextStyle(color: Colors.white),
          ),
        ),*/
        body: SafeArea(
          child: RefreshIndicator(
            key: refreshKey,
            color: Colors.blueAccent,
            onRefresh: () async {
              await refreshList();
            },
            child: ListView.builder(
                itemCount: data == null ? 1 : data.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: EdgeInsets.only(top: 30, left:20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Hello ' + widget.user.name + ',',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Welcome to Online Learning Everywhere',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13)),
                          SizedBox(height: 40),
                          Text('My Course',
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
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              //border: Border.all(color: Colors.blue),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "http://myondb.com/oleproject/images/${data[index]['courseimage']}.png")),
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  child: Column(
                            children: <Widget>[
                              Text(data[index]['coursename'].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(
                                'Duration: ' +
                                    data[index]['courseduration'].toString(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 46.0, top: 12.0),
                                child: LinearPercentIndicator(
                                  width: 160.0,
                                  lineHeight: 15.0,
                                  percent: 0.3,
                                  center: Text("30%",
                                      style: TextStyle(fontSize: 12)),
                                  backgroundColor: Colors.lightGreenAccent,
                                  progressColor: Colors.greenAccent,
                                ),
                              ),
                              /*Padding(padding: EdgeInsets.only(left: 60),
                            child: Icon(
                              Icons.chevron_right
                            )
                            )*/
                            ],
                          )))
                        ]),
                      )),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<String> makeRequest() async {
    String urlCourse =
        "http://myondb.com/oleproject/php/load_enrolled_course1.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    pr.show();
    http.post(urlCourse, body: {
     // "courseid" : widget.course.courseid,
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
}
