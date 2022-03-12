import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:vekant_filesharing_app/files_category/audio.dart';
import 'package:vekant_filesharing_app/files_category/files.dart';
import 'package:vekant_filesharing_app/files_category/images.dart';
import 'package:vekant_filesharing_app/files_category/videos.dart';
import 'package:vekant_filesharing_app/my_home_page.dart';
import 'package:vekant_filesharing_app/signin_page.dart';
import '../api/firebase_api.dart';
import '../models/firebase_file.dart';
import 'image_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    final userID = FirebaseAuth.instance.currentUser!.uid;
    currentFirebaseUserID = userID;

    futureFiles = FirebaseApi.listAll('files/$currentFirebaseUserID');
    futureFiles = FirebaseApi.listAllImages('files/$currentFirebaseUserID');
  }

  @override
  Widget build(BuildContext context) => Scaffold(

    drawer: Drawer(
      child: Container(
        color: Colors.blue,
        child: ListView(
          children: [
            Container(
                color: Colors.blue,
                child: DrawerHeader(
                    child: Container(
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              "images/profile.png",
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'UserName',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                      // color: Colors.indigo,
                    ))),
            Divider(thickness: 1, color: Colors.white),
            ListTile(
              leading: Icon(Icons.insert_drive_file_sharp, color: Colors.white),
              title: Text(
                "Received Files",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {

              },
            ),
            ListTile(
              leading:
              Icon(Icons.send_and_archive, color: Colors.white),
              title: Text(
                "Send Files",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {

              },
            ),

            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                "Settings",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onTap: () {

              },
            ),

            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInPage()));
              },
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    appBar: AppBar(
      title: Text('Theircalling'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.file_upload),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),

        const SizedBox(width: 12),
      ],
    ),
    body: FutureBuilder<List<FirebaseFile>>(
      future: futureFiles,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Some error occurred!'));
            } else {
              final files = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(files.length),
                  const SizedBox(height: 12),
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: files.length,
                  //     itemBuilder: (context, index) {
                  //       final file = files[index];
                  //
                  //       return buildFile(context, file);
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ImageScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.blue.shade100,
                            height: 60,
                            child: Row(
                              children: [
                                Icon(Icons.image, color: Colors.white,),
                                SizedBox(width: 20,),
                                Text('Images'),
                                SizedBox(width: 10,),
                                Text('(${numberOfImages.toString()})'),
                                SizedBox(width: 160,),
                                Icon(Icons.navigate_next, color: Colors.white,size: 40,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => VideoScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.blue.shade100,
                            height: 60,
                            child: Row(
                              children: [
                                Icon(Icons.video_file, color: Colors.white),
                                SizedBox(width: 20,),
                                Text('Videos'),
                                SizedBox(width: 10,),
                                Text('(${numberOfVideos.toString()})'),
                                SizedBox(width: 165,),
                                Icon(Icons.navigate_next, color: Colors.white,size: 40,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => AudioScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.blue.shade100,
                            height: 60,
                            child: Row(
                              children: [
                                Icon(Icons.audio_file, color: Colors.white),
                                SizedBox(width: 20,),
                                Text('Audio'),
                                SizedBox(width: 10,),
                                Text('(${numberOfAudio.toString()})'),
                                SizedBox(width: 171,),
                                Icon(Icons.navigate_next, color: Colors.white,size: 40,),
                              ],
                            ),

                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => FilesScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.blue.shade100,
                            height: 60,
                            child: Row(
                              children: [
                                Icon(Icons.file_copy, color: Colors.white),
                                SizedBox(width: 20,),
                                Text('Files'),
                                SizedBox(width: 10,),
                                Text('(${numberOfFiles.toString()})'),
                                SizedBox(width: 178,),
                                Icon(Icons.navigate_next, color: Colors.white,size: 40,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              );
            }
        }
      },
    ),
  );

  // Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
  //   leading: ClipOval(
  //     child: Image.network(
  //       file.url,
  //       width: 52,
  //       height: 52,
  //       fit: BoxFit.cover,
  //     ),
  //   ),
  //   title: Text(
  //     file.name,
  //     style: TextStyle(
  //       fontWeight: FontWeight.bold,
  //       decoration: TextDecoration.underline,
  //       color: Colors.blue,
  //     ),
  //   ),
  //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => ImagePage(file: file),
  //   )),
  // );

  Widget buildHeader(int length) => ListTile(
    tileColor: Colors.blue,
    leading: Container(
      width: 52,
      height: 52,
      child: Icon(
        Icons.file_copy,
        color: Colors.white,
      ),
    ),
    title: Text(
      '$length Files',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}