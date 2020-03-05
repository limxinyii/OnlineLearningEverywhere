import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'textstyle.dart';
import 'admin.dart';
import 'user.dart';
import 'registration.dart';
import 'mainscreen.dart';
import 'forgotpassword.dart';
import 'adminscreen.dart';

String urlLogin = "http://myondb.com/oleproject/php/login.php";
String urlLoginAdmin = "http://myondb.com/oleproject/php/login_admin.php";

final TextEditingController _emcontroller = TextEditingController();
String _email = "";
final TextEditingController _passcontroller = TextEditingController();
String _password = "";
bool _isChecked = false;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _globalKey = new GlobalKey();
  bool _autoValidate = false;
  bool _isChecked = false;

  @override
  void initState() {
    loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueAccent));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView (
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/ole.png',
                      width: ScreenUtil().setWidth(480),
                      height: ScreenUtil().setHeight(400),
                    ),
                  ],
                ),
                TextFormField(
                    controller: _emcontroller,
                    autovalidate: _autoValidate,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(25.0),
                        ))),
                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                TextFormField(
                  controller: _passcontroller,
                  autovalidate: _autoValidate,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(25.0))),
                  obscureText: true,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool value) {
                        _onChange(value);
                      },
                    ),
                    Text('Remember Me', style: TextStyles.Styling)
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(' Login as:', style: TextStyles.Styling),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: ScreenUtil().setWidth(250),
                          height: ScreenUtil().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFF17ead9),
                                Color(0xFF6078ea)
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6078ea).withOpacity(.3),
                                  offset: Offset(0.0, 2.5),
                                  blurRadius: 2.5,
                                ),
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: _onLoginAdmin,
                                child: Center(
                                  child: Text('Admin',
                                      style: TextStyles.TextButton),
                                )),
                          )),
                      Container(
                          width: ScreenUtil().setWidth(250),
                          height: ScreenUtil().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFF17ead9),
                                Color(0xFF6078ea)
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6078ea).withOpacity(.3),
                                  offset: Offset(0.0, 2.5),
                                  blurRadius: 2.5,
                                ),
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: _onLogin,
                                child: Center(
                                  child: Text(
                                    'User',
                                    style: TextStyles.TextButton,
                                  ),
                                )),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(40)),
                GestureDetector(
                  onTap: _onForgot,
                  child: Text('Forgot Password?', style: TextStyles.Styling),
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 1.0,
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 13.0),
                        child: Text('OR', style: TextStyles.Styling)),
                    Expanded(
                      child: Container(height: 1.0, color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(40),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: _onRegister,
                          child: Text(
                            'Register Now',
                            style: TextStyles.Styling,
                          ),
                        ),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validateEmail(String value) {
    // The form is empty
    if (value.length == 0) {
      return "Please enter your email";
    }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  String _validatePassword(String value) {
    if (value.length == 0) {
      return "Please enter your password";
    } else if (value.length < 6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  void _onLoginAdmin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;

    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login In");
      pr.show();
      http.post(urlLoginAdmin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "Login Successful") {
          pr.dismiss();
          // print("Radius:");
          print(dres);
          Admin admin = new Admin(name: dres[1], email: dres[2]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminMainScreen(admin: admin)
                  ));
        } else {
          pr.dismiss();
        }
      }).catchError((error) {
        pr.dismiss();
        print(error);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _onLogin() {
    _email = _emcontroller.text;
    _password = _passcontroller.text;

    if (_isEmailValid(_email) && (_password.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login In");
      pr.show();
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        var string = res.body;
        List dres = string.split(",");
        print(dres);
        Toast.show(dres[0], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (dres[0] == "Login Successful") {
          pr.dismiss();
          // print("Radius:");
          print(dres);
          User user = new User(
              name: dres[1],
              email: dres[2],
              phone: dres[3],
              dob: dres[4],
              address: dres[5]);
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainScreen(user: user)
          ));
        } else {
          pr.dismiss();
        }
      }).catchError((error) {
        pr.dismiss();
        print(error);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
    context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
  }

  void _onForgot() {
    print('Forgot password');
    Navigator.push(
    context, MaterialPageRoute(builder: (context) => ForgotPassScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      savepref(value);
    });
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);
    if (_email.length > 1) {
      _emcontroller.text = _email;
      _passcontroller.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save pref
      if (_isEmailValid(_email) && (_password.length > 5)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Save pref $_email');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _passcontroller.text = '';
        _isChecked = false;
      });
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
