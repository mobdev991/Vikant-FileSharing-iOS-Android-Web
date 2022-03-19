import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:vekant_filesharing_app/my_home_page.dart';
import 'package:vekant_filesharing_app/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vekant_filesharing_app/widgets/signup_fourm.dart';

import '../api/firebase_api.dart';
import '../models/firebase_file.dart';
import '../theme.dart';
import 'image_page.dart';

class SendFilesPage extends StatefulWidget {
  @override
  _SendFilesPageState createState() => _SendFilesPageState();
}

class _SendFilesPageState extends State<SendFilesPage> {
  late Future<List<FirebaseFile>> futureFiles;
  bool _isObscure = true;
  TextEditingController _emailTextController = TextEditingController();
  final items = ['Item 1' , 'Item 2', 'Item 3' , 'Item 4', 'Item 5'];
  String? value;

  Color emailtextColor = Colors.grey;
  Color sametextColor = Colors.blue;
  bool sendingToSame = true;

  @override
  void initState() {
    super.initState();
    // items = filesNames;
  }

  @override
  Widget build(BuildContext context) => Scaffold(

    appBar: AppBar(
      title: Text('Send FIles'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.file_upload),
          onPressed: () {
          },
        ),

        const SizedBox(width: 12),
      ],
    ),
    body: SingleChildScrollView(
      child: Container(

        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          child: Text('TheirCalling Users',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: sametextColor),),
                        onTap: (){
                            setState(() {
                              sametextColor = Colors.blue;
                              emailtextColor = Colors.grey;
                              sendingToSame = true;
                            });
                        },
                      ),
                      SizedBox(width: 20,),
                      GestureDetector(onTap: (){
                        setState(() {
                          sametextColor = Colors.grey;
                          emailtextColor = Colors.blue;
                          sendingToSame = false;
                        });
                      },
                          child: Text('Send Via Email',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: emailtextColor))),
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                    child: buildInputForm('Email', false, _emailTextController)),
                SizedBox(height: 20,),
                Text('Select File',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),

                Container(
                  margin: EdgeInsets.all(16),
                  width: 300,
                  decoration: BoxDecoration(
                    border:  Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      iconSize: 40,
                      items: filesNames.map(buildMenuItem).toList(),
                      onChanged: (value) => setState(()
                        => this.value = value
                      ),
                    ),
                  ),
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
                    print('Sending Files');
                    print(filesNames);
                    print('sendingToSame Value :: ' + sendingToSame.toString());
                    if(_emailTextController.text.isNotEmpty){
                      displayToastMessage('File Sent', context);

                    }else if(value == null){
                      displayToastMessage('Select Files', context);
                    }
                    else{
                      displayToastMessage('Please Enter Email', context);
                    }
                  },
                  child: Text('Send Files',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                ),





              ],
            )),
        
      ),
    ),
  );

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

 DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
   value: item,
     child: Text(item,
   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),));


}

