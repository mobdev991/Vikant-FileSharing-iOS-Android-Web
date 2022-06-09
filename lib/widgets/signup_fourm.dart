import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vekant_filesharing_app/pages/list_files.dart';
import 'package:vekant_filesharing_app/pages/main_screen.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../main.dart';
import '../my_home_page.dart';


import '../theme.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static const String screenId = "login";
  bool _isObscure = true;

  bool errorSignUp = false;
  bool checkedValue = false;

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _nameTextController,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          ],
          decoration: InputDecoration(
            hintText: 'Name',
            hintStyle: TextStyle(color: kTextFieldColor),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),

          ),
        ),
        // buildInputForm('Last Name', false),
        buildInputForm('Email', false, _emailTextController),
        buildInputForm('Password', true, _passwordTextController),

        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CheckboxListTile(
              title: GestureDetector(
                  onTap: (){
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AppPrivacy()));

                  },
                  child: Text('Agree to terms and conditions.',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold))),
              value: checkedValue,
              onChanged: (newValue) {
                setState(() {
                  checkedValue = newValue!;
                  print(newValue);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            )

        ),
        // buildInputForm('Confirm Password', true),
        Text(
          errorSignUp == false ? "" : 'Invalid Formate : Too Short',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
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

          onPressed: () async{
            if (_passwordTextController.text.length < 6) {
              displayToastMessage("Password Too Short", context);
            } else if (_nameTextController.text.length < 3) {
              setState(() {
                errorSignUp = true;
              });
            } else if (!_emailTextController.text.contains("@") &&
                !_emailTextController.text.contains(".")) {
              displayToastMessage("Invalid Email", context);
            } else {
              if(checkedValue== true){


                registerNewUser(context);


              }else{
                displayToastMessage('Agree to TOS', context);
              }

              //verifyPhoneNumber();
            }
          },
          child: Text('Create Account',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        ),

      ],
    );
  }

  Padding buildInputForm(
      String hint, bool pass, TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          controller: controller,
          obscureText: pass ? _isObscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: kTextFieldColor),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
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
                ))
                : null,
          ),
        ));
  }



  FirebaseAuth auth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    final User? firebaseUser = (await auth
        .createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text)
        .catchError((errMsg) {
      displayToastMessage(errMsg + "Error Creating New User", context);
    }))
        .user;
    if (firebaseUser != null) //user created
        {
      // save his info

      userRef.child(firebaseUser.uid);

      Map userDataMap = {
        "name": _nameTextController.text.trim(),
        "email": _emailTextController.text.trim(),
        "phone": _phoneTextController.text.trim(),
      };

      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Account Created", context);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => MainScreen()), (route) => false);
    } else {
      displayToastMessage("UserNotCreated", context);
    }
  } //signUpwithwmailapass

}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
