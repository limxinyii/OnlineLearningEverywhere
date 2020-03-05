import 'package:flutter/material.dart';
import 'package:ole/textstyle.dart';
import 'dart:async';
import 'loginscreen.dart';
import 'resetpass.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

String urlPassword="http://myondb.com/oleproject/php/forgot.php";


class ForgotPassScreen extends StatefulWidget {
  final String email;
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
  const ForgotPassScreen({Key key, this.email}) : super(key: key);
}

class _ForgotPasswordScreenState extends State<ForgotPassScreen> {
   @override
  void initState() {
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor:  Colors.blue,
          title: Text('Forgot Password'),
        ), 
        body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: PasswordWidget(),
          ),
        ),
      ),
     ));
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
    return Future.value(false);
  }
}

class PasswordWidget extends StatefulWidget {
  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
   final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
         SizedBox(
          height: 10,
        ),

        Text("Find your account",
                  style: TextStyle(
                    
                    fontWeight: FontWeight.bold, 
                    fontSize: 24)),

         SizedBox(
            height: 25,
                ),

                  Text("Please enter your registered email:",
                  style: TextStyle(
                     
                    fontSize: 15)),

        SizedBox(
          height: 15,
        ),

        TextField(
            controller: _emcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
            ))),
            SizedBox(
                  height: 25,
                ),

                  MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 130,
                  height: 50,
                  child: Text('SUBMIT', 
                  style: TextStyles.TextButton),
                  color: Colors.blue,
                  onPressed: _onPressed,
                ),

      ],
    );
  }

 void _onPressed() {
    _email = _emcontroller.text;
    if (_isEmailValid(_email)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Verifying your email");
      pr.show();

      http.post(urlPassword, body: {
        "email": _email,
      }).then((res){
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
           if (res.body == "Code send! Please check your mailbox") {
          pr.dismiss();
          Navigator.push(
            context, MaterialPageRoute(builder: (BuildContext context)=> ResetPasswordScreen(email: _email))); 
            }else{
         pr.dismiss();
        
        }

      }).catchError((err){
          pr.dismiss();
          print(err);
    });
  } else{
    Toast.show("Please enter a valid email", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}

   
  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  } 

}