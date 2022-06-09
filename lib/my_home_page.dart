import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:vekant_filesharing_app/pages/list_files.dart';
import 'package:vekant_filesharing_app/widgets/button_widget.dart';

import 'package:permission_handler/permission_handler.dart';
import '../api/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UploadTask? task;
  File? file;
  bool appPermissioncheck = true;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: Text('FileSharing'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Select File',
                icon: Icons.attach_file,
                onClicked: selectFile,
              ),
              SizedBox(height: 8),
              Text(
                fileName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 40),
              ButtonWidget(
                text: 'Upload File',
                icon: Icons.cloud_upload_outlined,
                onClicked: uploadFile,
              ),
              SizedBox(height: 20),
              task != null ? buildUploadStatus(task!) : Container(),
              SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(29, 194, 95, 1),
                    minimumSize: Size.fromHeight(50),),
                  onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ListPage()));
              }, child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list, size: 28),
                  SizedBox(width: 16),
                  Text(
                    'All Files',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),



                ],
              )),

              SizedBox(height: 20,),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  'Total Storage                 :: 100 MBs',
                  style: TextStyle(fontSize: 15, color: Colors.green,fontWeight: FontWeight.bold),
                ),Text(
                  'Storage Used                 :: ${totalSizeGB.round()} MBs',
                  style: TextStyle(fontSize: 15, color: Colors.green,fontWeight: FontWeight.bold),
                ),Text(
                  'Storage Remaining       :: ${(100 - totalSizeGB).round()} MBs',
                  style: TextStyle(fontSize: 15, color: Colors.green,fontWeight: FontWeight.bold),
                ),
              ],)

            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
print(currentFirebaseUserEmail);
    super.initState();
  }

  Future selectFile() async {
    checkPermission();

    print("User ID :: "+ FirebaseAuth.instance.currentUser!.uid);

    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;


    final fileName = basename(file!.path);
    final destination = 'files/$currentFirebaseUserEmail/$fileName';
print(destination);
    task = FirebaseApi.uploadFile(destination, file!,'');

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );

  void showRequestPermissionDialog(){

    showDialog(
        context: context as BuildContext,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Location Permission',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.indigo)),
          content: Text(
            'Rio Drive collects location Data to enable "Ride Request" and "Location Tracking" Features, even when the app is closed or not in use', style: TextStyle(fontSize: 15,),),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Deny',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.indigo)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: Text('Allow',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.indigo)),
              onPressed: () {
                appPermissioncheck = false;
                Permission.location.request();
                Navigator.pop(context);


              },
            ),
          ],
        ));
  }

  void checkPermission() async{
    var status = await Permission.location.status;

    if(status.isDenied){
      print('location permission is denied..............................');
    }else{

      print('location permission is NOT denied..............................');
    }

    if(status.isRestricted){
      print('location permission is Restricted..............................');
    }else{

      print('location permission is NOT Restricted..............................');
    }

    if(status.isPermanentlyDenied){
      print('location permission is PermanentlyDenied..............................');
    }else{

      print('location permission is NOT PermanentalyDenied..............................');
    } if(status.isGranted){
      print('location permission is Granted..............................');
    }else{
      showRequestPermissionDialog();

    }


  }
}