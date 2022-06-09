
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:intl/intl.dart';
import 'package:vekant_filesharing_app/widgets/signup_fourm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../api/firebase_api.dart';
import '../models/firebase_file.dart';
import '../theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SendFilesPage extends StatefulWidget {
  @override
  _SendFilesPageState createState() => _SendFilesPageState();
}

class _SendFilesPageState extends State<SendFilesPage> {
  late Future<List<FirebaseFile>> futureFiles;
  bool _isObscure = true;
  TextEditingController _emailTextController = TextEditingController();
  final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  String? value;
  File? file;
  UploadTask? task;
  int slectedValue = 1;
  bool sendingToSame = true;


  Color emailtextColor = Colors.grey;
  Color sametextColor = Colors.blue;
  DateTime dateTime = DateTime.now();


  String getText() {
    if (dateTime == null) {
      return 'Select DateTime';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    }
  }

  @override
  void initState() {
    super.initState();
    // items = filesNames;
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
      return Scaffold(

        appBar: AppBar(
          title: Text('Send FIles'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () {},
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text('TheirCalling Users', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: sametextColor),),
                          onTap: () {
                            setState(() {
                              sametextColor = Colors.blue;
                              emailtextColor = Colors.grey;
                            });
                            sendingToSame = true;
                          },
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          child: Text('Send Via Email', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: emailtextColor),),
                          onTap: () {
                            setState(() {
                              sametextColor = Colors.grey;
                              emailtextColor = Colors.blue;
                            });
                            sendingToSame = false;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: buildInputForm(
                            'Email', false, _emailTextController)),
                    SizedBox(height: 15,),
                    Text('Select File', style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),),
                    SizedBox(height: 10,),

                    Column(
                     children: [
                        ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          maximumSize: const Size(200, 50),
                  ),
                        child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined),
                            SizedBox(width: 10,),
                            Text('Upload FIles')
                    ],
                  ),
                  onPressed: (){
                    selectFile();
                  },
                ),
                    SizedBox(height: 5,),
                    Text(fileName),
              ],
                    ),

                    SizedBox(height: 20,),
                    Text('Schedule Sending', style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),),

                    RadioListTile<int>(
                      value: 1,
                      groupValue: slectedValue,
                      title: Text('Now'),
                      subtitle: Text('File Will Be Sent Now!'),
                      onChanged: (value) =>setState(() {
                        slectedValue =value!;
                      }),
                    ),
                    RadioListTile<int>(
                      value: 2,
                      groupValue: slectedValue,
                      title: Text('Schedule'),
                      subtitle: Text('File Will Be Sent At ${getText().toString()}'),
                      secondary: OutlinedButton(
                        child: Text('Set'),
                        onPressed: () => pickDateTime(context),
                      ),
                      onChanged: (value) =>setState(() {
                        slectedValue = value!;

                      }),
                    ),


                    // ButtonHeaderWidget(
                    //   title: 'DateTime',
                    //   text: getText(),
                    //   onClicked: () => pickDateTime(context),
                    // ),


                    SizedBox(height: 20,),
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.indigo,
                        minimumSize: Size(200, 40),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.indigo)),
                      ),

                      onPressed: () async{
                        if (_emailTextController.text.isNotEmpty) {
                          displayToastMessage('File Sent', context);

                          if(slectedValue == 1){
                            if(sendingToSame == true){
                              print('sending to same :: $sendingToSame');
                              print('sending the file now');
                              var dateTime = DateTime.now();
                              print(dateTime);
                              uploadFile(dateTime.toString());
                            }else{
                              var dateTime = DateTime.now();
                              print(dateTime);
                              uploadFile(dateTime.toString());

                              pd.show(
                              max: 100,
                              msg: 'Preparing Files...',
                              progressBgColor: Colors.transparent,
                              );
                              for (int i = 0; i <= 100; i++) {
                              /// You don't need to update state, just pass the value.
                              /// Only value required
                              pd.update(value: i);
                              i++;

                              await Future.delayed(Duration(milliseconds: 300));
                              }

                              print('sending to same :: $sendingToSame');
                              print('Email URL DOWNLOAD :: $emailUrlDownload');
                              launchEmail(toEmail: _emailTextController.text, subject: 'You Have Recieved A File', message: emailUrlDownload);
                            }

                          }else{

                            if(sendingToSame == true){
                              print('sending to same :: $sendingToSame');
                              print('sending value of selected time');
                              var dateTime = DateTime.parse(getText().toString());
                              uploadFile(dateTime.toString());
                              print(dateTime);
                            }else{
                              print('sending to same :: $sendingToSame');
                              var dateTime = DateTime.parse(getText().toString());
                              uploadFile(dateTime.toString());
                              print(dateTime);
                              pd.show(
                                max: 100,
                                msg: 'Preparing Files...',
                                progressBgColor: Colors.transparent,
                              );
                              for (int i = 0; i <= 100; i++) {
                                /// You don't need to update state, just pass the value.
                                /// Only value required
                                pd.update(value: i);
                                i++;

                                await Future.delayed(Duration(milliseconds: 300));
                              }
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => new AlertDialog(
                                    title: new Text('Please Note!'),
                                    content: new Text('You need to set Email Scheduling in Your Email Client. Cheers!'),
                                    actions: <Widget>[
                                      new IconButton(
                                          icon: new Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),new IconButton(
                                          icon: new Icon(Icons.arrow_forward),
                                          onPressed: () {
                                            print('Email URL DOWNLOAD :: $emailUrlDownload');
                                            launchEmail(toEmail: _emailTextController.text, subject: 'You Have Recieved A File', message: emailUrlDownload);
                                          }),
                                    ],
                                  ));


                            }
                               }

                        }else{
                          print('Please Enter Your Email');
                        }



//                         emailChecker(_emailTextController.text);
//                         print('Sending Files');
//                         print(filesNames);
//                         if (value == null) {
//                           displayToastMessage('Select Files', context);
//                         }
//                         else {
//                           displayToastMessage('Please Enter Email', context);
//                         }
//                         print('selected value :: $slectedValue');
//                         var dateTime = DateTime.parse(getText().toString());
//                         print(getText().toString());
//                         print(dateTime);
//                         print('Date Is After :: ${dateTime.isAfter(DateTime.now())}');

                        // uploadFile(getText());

                      },
                      child: Text('Send Files', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),),
                    ),


                  ],
                )),

          ),
        ),
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

 DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
   value: item,
     child: Text(item,
   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),));

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return dateTime;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    return newTime;
  }

  void emailChecker(String enteredEmail){
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser!.uid);

    auth.fetchSignInMethodsForEmail(enteredEmail).then((value) {
      print(value.isNotEmpty);
    });

  }

  Future selectFile() async {

    print("User ID :: "+ FirebaseAuth.instance.currentUser!.uid);

    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile(String showDate) async {
    if (file == null) return;


    final fileName = basename(file!.path);
    final destination = 'files/${_emailTextController.text}/Receive Files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!, showDate);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    emailUrlDownload = urlDownload;

    print('Download-Link: $urlDownload');
  }

  Future launchEmail({
  required String toEmail,
  required String subject,
  required String message,
})async{
    final url = 'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull('Use Link Below to View The File \n $message')}';

    if(await canLaunch(url)){
      await launch(url);
    }
  }
  
}

