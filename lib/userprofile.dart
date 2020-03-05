import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ole/textstyle.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

double perpage = 1;

class UserProfile extends StatefulWidget {
  final User user;

  UserProfile({Key key, this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'TRAINEE PROFILE',
            style: TextStyles.TextButton,
          ),
        ),
        body: RefreshIndicator(
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
                      // padding: EdgeInsets.all(20),
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text('List of User Profile', style: TextStyles.boldtitle),
                    ],
                  ));
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
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Row(children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 10, right: 20),
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  //border: Border.all(color: Colors.black),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "http://myondb.com/oleproject/profile/${data[index]['email']}.jpg")))),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        color: Colors.teal[300],
                                        size: 21,
                                      ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      //padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        data[index]['name']
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          //fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                      Icon(
                                        Icons.email,
                                        color: Colors.teal[300],
                                        size: 21,
                                      ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        data[index]['email'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                      Icon(
                                        Icons.phone,
                                        color: Colors.teal[300],
                                        size: 21,
                                      ),
                                      SizedBox(width: 5),
                                    Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        data[index]['phone'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          //fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                      Icon(
                                        Icons.cake,
                                        color: Colors.teal[300],
                                        size: 21,
                                      ),
                                    SizedBox(width: 5),                                  
                                    Flexible(
                                      child: Text(
                                        data[index]['dob'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          //fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                      Row(children: <Widget>[
                                    Icon(
                                      Icons.home,
                                      color: Colors.teal[300],
                                      size: 21,
                                    ),
                                    SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      data[index]['address'].toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                      //fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                                ),
                               SizedBox(height: 10), 
                              ],
                            ),
                          )),
                        ]),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  Future<String> makeRequest() async {
    String urlUser = "http://myondb.com/oleproject/php/load_user.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    pr.show();
    http.post(urlUser, body: {
      "email": widget.user.email ?? "notavail",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["user"];
        perpage = (data.length / 10);
        print("data");
        //print(data);
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
