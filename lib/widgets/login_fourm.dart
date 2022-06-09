import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vekant_filesharing_app/my_home_page.dart';
import 'package:vekant_filesharing_app/pages/list_files.dart';
import 'package:vekant_filesharing_app/pages/main_screen.dart';
import 'package:vekant_filesharing_app/pages/reset_password.dart';

import '../theme.dart';


class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  bool signinError = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isObscure = true;
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          signinError == false ? "" : 'Invalid Email or Password!',
          style: TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        buildInputForm('Email', false, _emailTextController),
        buildInputForm('Password', true, _passwordTextController),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen()));
              },
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),

        ElevatedButton(

          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.indigo,
            minimumSize: Size(200, 40),
            padding: EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.indigo)),
          ),

          onPressed: () {
            if (_passwordTextController.text.length >= 6 || _passwordTextController.text.isNotEmpty) {
              print('inside check');
              FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                  email: _emailTextController.text,
                  password: _passwordTextController.text)
                  .then((value) {

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
              }).onError((error, stackTrace) {
                setState(() {
                  print('login error' + error.toString());
                  signinError = true;
                });
              });
            } else {
              setState(() {
                signinError = true;
              });
              print("something went wronge--------------------------");
            }
          },
          child: Text('Log In',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        ),

      ],
    );
  }

  Padding buildInputForm(
      String label, bool pass, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: kTextFieldColor,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            suffixIcon: pass
                ? IconButton(
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              icon: _isObscure
                  ? Icon(
                Icons.visibility_off,
                color: kTextFieldColor,
              )
                  : Icon(
                Icons.visibility,
                color: kPrimaryColor,
              ),
            )
                : null),
      ),
    );
  }
}
