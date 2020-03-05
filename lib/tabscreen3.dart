import 'dart:convert';
import 'dart:math';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ole/splashscreen.dart';
import 'package:ole/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


String urlgetuser = "http://myondb.com/oleproject/php/get_user.php";
String urluploadImage =
    "http://myondb.com/oleproject/php/upload_imageprofile.php";
String urlupdate = "http://myondb.com/oleproject/php/update_profile.php";

File _image;
int number = 0;
String _value;

class TabScreen3 extends StatefulWidget {
  final User user;

  TabScreen3({Key key, this.user});

  @override
  _TabScreen2State createState() => _TabScreen2State();
}

class _TabScreen2State extends State<TabScreen3> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue),
    );
    Size media = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: SafeArea(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.topCenter,
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  height: media.height * 0.25,
                                  width: media.width,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 80),
                              child: Stack(children: <Widget>[
                                GestureDetector(
                                  onTap: _choose,
                                  child: Container(
                                      height: 170,
                                      width: 170,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "http://myondb.com/oleproject/profile/${widget.user.email}.jpg?dummy=${(number)}'")),
                                          border: Border.all(
                                              color: Colors.white,
                                              width: 5.0))),
                                ),
                              ]),
                            ),
                            Column(children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                  child: Text('Online Learning Everywhere',
                                      style: TextStyles.TextButton),
                                ),
                              ),
                            ])
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            widget.user.name?.toUpperCase() ?? 'not registered',
                            style: TextStyles.text,
                          ),
                        ),
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Icon(Icons.email,
                                    color: Colors.green, size: 20,),
                              ),
                              SizedBox(width: 5),
                              Container(
                                child: Text(
                                  widget.user.email,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      letterSpacing: 0.6),
                                ),
                              ),
                            ],
                          )
                        ]),
                        SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.only(left: 35),
                          child: Column(
                            children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.phone_android, color: Colors.indigo,),
                                      SizedBox(width: 5),
                                      Text(
                                        widget.user.phone ?? 'not registered',
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    Icon(Icons.cake,
                                    color: Colors.pinkAccent),
                                    SizedBox(width: 5),
                                    Text(
                                      widget.user.dob ?? 'not registered',
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Icon(Icons.home,
                                color: Colors.orange[500]),
                                SizedBox(width: 5),
                                Flexible(
                                child: Text(widget.user.address),
                                )],
                            )
                          ]),
                        ),
                        SizedBox(height: 15),
                        Divider(thickness: 0.5, color: Colors.grey),
                        Padding(padding: EdgeInsets.only(left: 25, top: 8 , bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                              Icon(Icons.settings, color: Colors.grey[700], size: 18,),
                              SizedBox(width: 5),
                              Text("SETTING:", style: TextStyle(
                                fontFamily: 'Poppins', fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1.2
                              )),
                              ])),
                          ],),
                        )
                      ],
                    )
                  );
                  }

                  if(index == 1) {
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  highlightColor: Colors.white.withAlpha(50),
                                  onTap: _changeName,
                                  child: Column(
                                    children: <Widget> [
                                      Icon(
                                        Icons.person,
                                        color: Colors.tealAccent[700],
                                      ),
                                      Text('Change Name',
                                       style: TextStyles.text2),
                                    ]
                                  ),
                                ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: _changePassword,
                                    child: Column(
                                      children: <Widget> [
                                        Icon(Icons.lock,
                                        color: Colors.amber[500]),
                                        Text('Change Password', style: TextStyles.text2),
                                      ]
                                    ),
                                  )),
                            ]
                          ),
                          SizedBox(height: 30),
                           Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  highlightColor: Colors.white.withAlpha(50),
                                  onTap: _changePhone,
                                  child: Column(
                                    children: <Widget> [
                                      Icon(
                                        Icons.phone_android,
                                        color: Colors.indigo,
                                      ),
                                      Text('Change No.phone',
                                       style: TextStyles.text2),
                                    ]
                                  ),
                                ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: _changeDob,
                                    child: Column(
                                      children: <Widget> [
                                        Icon(Icons.calendar_today,
                                        color: Colors.pinkAccent),
                                        Text('Change Date of Birth', style: TextStyles.text2),
                                      ]
                                    ),
                                  )),
                            ]
                          ),
                           SizedBox(height: 30),
                           Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  highlightColor: Colors.white.withAlpha(50),
                                  onTap: _changeAddress,
                                  child: Column(
                                    children: <Widget> [
                                      Icon(
                                        Icons.home,
                                        color: Colors.orange[500],
                                      ),
                                      Text('Change Address',
                                       style: TextStyles.text2),
                                    ]
                                  ),
                                ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: _gotologout,
                                    child: Column(
                                      children: <Widget> [
                                        Icon(Icons.exit_to_app,
                                        color: Colors.purpleAccent[700]),
                                        Text('Logout', style: TextStyles.text2),
                                      ]
                                    ),
                                  )),
                            ]
                          ),
                        SizedBox(height: 20),
                        ],
                      ),
                      );
                  }
                }),
          ),
        ));
  }

  void _choose() async {
    showModalBottomSheet(
        elevation: 1,
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.black,
                    ),
                    title: Text('View Profile Picture'),
                    onTap: () async {
                      Navigator.pop(context);
                      Hero(
                        tag: 'Profile Picture',
                        child: Image.network(
                            "http://myondb.com/myapp/profile/${widget.user.email}.jpg?dummy=${(number)}'"),
                      );

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(user: widget.user)));
                      setState(() {});
                    }),
                Divider(
                  color: Colors.grey[400],
                  indent: 0,
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.black),
                  title: Text('Camera'),
                  onTap: () async {
                    /*if (widget.user.name == "not register") {
                      Toast.show("Not allowed", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                    }*/
                    String base64Image;
                    try {
                      Navigator.of(context).pop();
                      _image = await ImagePicker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 80,
                          maxWidth: double.infinity,
                          maxHeight: 450);

                      base64Image = base64Encode(_image.readAsBytesSync());
                    } catch (e) {
                      print(e);
                    }
                    http.post(urluploadImage, body: {
                      "encoded_string": base64Image,
                      "email": widget.user.email,
                    }).then((res) {
                      print(res.body);
                      if (res.body == "success") {
                        setState(() {
                          number = new Random().nextInt(100);
                          print(number);
                        });
                      } else {}
                    }).catchError((err) {
                      print(err);
                    });
                  },
                ),
                Divider(
                  color: Colors.grey[400],
                  indent: 0,
                ),
                ListTile(
                  leading: Icon(Icons.photo_album, color: Colors.black),
                  title: Text('Gallery'),
                  onTap: () async {
                    /*if (widget.user.name == "not register") {
                      Toast.show("Not allowed", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                    }*/
                    String base64Image;
                    try {
                      Navigator.of(context).pop();
                      _image = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                          maxWidth: double.infinity,
                          maxHeight: 450);

                      base64Image = base64Encode(_image.readAsBytesSync());
                    } catch (e) {
                      print(e);
                    }
                    http.post(urluploadImage, body: {
                      "encoded_string": base64Image,
                      "email": widget.user.email,
                    }).then((res) {
                      print(res.body);
                      if (res.body == "success") {
                        setState(() {
                          number = new Random().nextInt(100);
                          print(number);
                        });
                      } else {}
                    }).catchError((err) {
                      print(err);
                    });
                  },
                )
              ],
            ),
          );
        });
  }

  void _takePicture() async {
    /*if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }*/
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //return object of type dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change name for " + widget.user.name),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                 border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent)),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.user.name = dres[1];
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
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

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Password for " + widget.user.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
               border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent)),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change phone for " + widget.user.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                 border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent)),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
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
   void _changeDob() {
    TextEditingController dobController = TextEditingController();
    final format = DateFormat("yyyy-MM-dd");
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Dob for " + widget.user.name),
          content:
          DateTimeField(
              controller: dobController,
              format: format,
              decoration: InputDecoration(
                  labelText: 'Date of birth',
                   border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent))),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)));
              }), 
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (dobController.text.length < 5) {
                  Toast.show("Please enter correct date", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "dob": dobController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.dob = dres[4];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
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

  void _changeAddress() {
    TextEditingController addressController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change address for " + widget.user.name),
          content: new TextField(
              keyboardType: TextInputType.text,
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                 border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent))
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (addressController.text.length == 0) {
                  Toast.show("Please enter correct address", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "address": addressController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.address = dres[5];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
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


void _gotologout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Log out?"),
          content: new Text("Are your sure want to logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                 SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                 print("LOGOUT");
                Navigator.pop(
                context, MaterialPageRoute(builder: (context) => SplashScreen()));
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

    void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }
}


 


class DetailScreen extends StatefulWidget {
  final User user;
  const DetailScreen({Key key, this.user}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Profile Picture'),
      ),
      body: Container(
        child: Center(
          child: Hero(
            tag: 'Profile Picture',
            child: Image.network(
                "http://myondb.com/oleproject/profile/${widget.user.email}.jpg?dummy=${(number)}'"),
          ),
        ),
      ),
    );
  }
}
