import 'dart:convert';
import 'package:ole/userprofile.dart';
import 'package:ole/video.dart';
import 'package:toast/toast.dart';
import 'addcourse.dart';
import 'user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ole/textstyle.dart';
import 'admin.dart';
import 'course.dart';
import 'coursedetail.dart';
import 'loginscreen.dart';
import 'uploadVideo.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

double perpage = 1;

class AdminMainScreen extends StatefulWidget {
  final Admin admin;
  final User user;

  const AdminMainScreen({Key key, this.admin, this.user}) : super(key: key);

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  List data;
  GlobalKey<RefreshIndicatorState> refreshKey;

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
      drawer: _createDrawer(),
      appBar: AppBar(
        title: Text(
          'HOME PAGE',
          style: TextStyles.TextButton,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        elevation: 2.0,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCourse()));
        },
        tooltip: 'Add course',
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Courses', style: TextStyles.boldtitle),
                        ],
                      ));
                }
                if (index == data.length && perpage > 1) {
                  return Container(
                    width: 250,
                    color: Colors.white,
                    child: MaterialButton(
                      child: Text("Load More",
                          style: TextStyle(color: Colors.black)),
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
                        onTap: (){},
                        /*=> _onCourseDetail(
                              data[index]['courseid'],
                              data[index]['coursename'],
                              data[index]['courseduration'],
                              data[index]['coursedes'],
                              data[index]['courseimage'],
                              data[index]['postdate'],
                              data[index]['userenroll'],
                              //widget.user.email,
                              //widget.user.name,
                            ),*/
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 5),
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
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        letterSpacing: 0.6)),
                                SizedBox(height: 5),
                                Text(
                                  'Duration: ' +
                                      data[index]['courseduration'].toString(),
                                ),
                              ],
                            ))),
                            InkWell(
                            child: Icon(Icons.edit),
                            onTap: () => _onCourseDetail(
                              data[index]['courseid'],
                              data[index]['coursename'],
                              data[index]['courseduration'],
                              data[index]['coursedes'],
                              data[index]['courseimage'],
                              data[index]['postdate'],
                              data[index]['userenroll'],
                              //widget.user.email,
                              //widget.user.name,
                            ),
                          ),
                          SizedBox(width: 5),
                           InkWell(
                            child: Icon(Icons.delete),
                            onTap:() => _onDelete(
                              data[index]['courseid'].toString(),
                              data[index]['coursename'].toString()
                            ),
                          ),
                          ]),
                        )),
                  ),
                );
              })),
    );
  }

  Widget _createDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createUserAccountHeader(),
          /*ListTile(
            leading: Icon(Icons.import_contacts),
            title: Text('Manage Course'),
            onTap: () {
              print("cliked");
              //Navigator.push(context, MaterialPageRoute(builder: (context) => ManageCourse()));
            },
          ),*/
          /*ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Manage Quiz'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              //Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen()));
            },
          ),*/
          ListTile(
            leading: Icon(Icons.person, color: Colors.tealAccent[700]),
            title: Text('Trainee Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.purpleAccent[700]),
            title: Text('Log out'),
            onTap: _gotologout,
          ),
        ],
      ),
    );
  }

  Widget _createUserAccountHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(widget.admin.name, style: TextStyles.text3),
      accountEmail: Text(widget.admin.email, style: TextStyles.text3),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/images/admin.png'),
      ),
      decoration: BoxDecoration(
        color: Colors.blueAccent[200],
      ),
    );
  }

  void _gotologout() async {
    // flutter defined function
    print(widget.admin.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Log out?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                print("LOGOUT");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> makeRequest() async {
    String urlLoad = "http://myondb.com/oleproject/php/load_course.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Courses");
    pr.show();
    http.post(urlLoad, body: {
      // "email": widget.user.email,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["course"];
        perpage = (data.length / 10);
        print("data");
        print(data);
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
    String userenroll,
    // String email,
    //String name
  ) {
    Course course = new Course(
        courseid: courseid,
        coursename: coursename,
        courseduration: courseduration,
        coursedes: coursedes,
        courseimage: courseimage,
        postdate: postdate);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                UploadContent(course: course)));
  }

  void _onDelete(String courseid, coursename) {
    print("Delete" + courseid);
    _showDialog(courseid, coursename);
  }

  void _showDialog(String courseid, String coursename){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Delete " + coursename),
          content: Text("Are you sure?"),
          actions: <Widget>[
            new FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteRequest(courseid);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: (){
                Navigator.of(context).pop();
              }),
            ],
          );
      } 
    );
  }

  Future<String> deleteRequest(String courseid) async {
    String urldelete = "http://myondb.com/oleproject/php/delete_course.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting Course");
    pr.show();
    http.post(urldelete, body: {
      "courseid": courseid,
    }).then((res) {
      print(res.body);
      if (res.body == "success"){
        Toast.show("Success", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      init();
      }else{
        Toast.show("Failed", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      return null;
    }
  }

