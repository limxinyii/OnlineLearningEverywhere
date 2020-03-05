import 'package:flutter/material.dart';
import 'package:ole/textstyle.dart';
import 'forgotpassword.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'loginscreen.dart';
import 'dart:async';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';

String urlPassword = "http://myondb.com/oleproject/php/reset_pass.php";

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  ResetPasswordScreen({Key key, this.email}) : super(key: key);
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> _globalKey = new GlobalKey();
  bool _autoValidate = false;
  String email;

  String temppass = "";
  final TextEditingController _tempasscontroller = TextEditingController();

  String newpass = "";
  final TextEditingController _passcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Reset Password',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Your email: ${widget.email}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Please enter your verification code:",
                style: TextStyle(
                    //color: Colors.blueGrey,
                    //fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _tempasscontroller,
                autovalidate: _autoValidate,
                validator: validatePassword,
                decoration: InputDecoration(
                    labelText: 'Verification code',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Please enter your new password:",
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: _passcontroller,
                  autovalidate: _autoValidate,
                  validator: validatePassword,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      )),
                  obscureText: true,
                )),
            Padding(
              padding: EdgeInsets.only(top: 35),
              child: Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 220,
                  height: 50,
                  child: Text('RESET PASSWORD', style: TextStyles.TextButton),
                  color: Colors.blue,
                  onPressed: _onVerify,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must at least 6 characters";
    } else {
      return null;
    }
  }

  void _onVerify() {
    email = widget.email;
    temppass = _tempasscontroller.text;
    newpass = _passcontroller.text;
    if (newpass.length > 5) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Reset password");
      pr.show();

      http.post(urlPassword, body: {
        "email": email,
        "temppass": temppass,
        "newpass": newpass,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (res.body == "Success") {
          pr.dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
      Toast.show("Please enter a valid password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _goBack(BuildContext context) {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('You are now in reset password process'),
            content: new Text('Are you sure to leave?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
