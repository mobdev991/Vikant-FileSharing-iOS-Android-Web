import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:vekant_filesharing_app/my_home_page.dart';
import 'package:vekant_filesharing_app/signin_page.dart';
import '../api/firebase_api.dart';
import '../models/firebase_file.dart';
import 'image_page.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    final userID = FirebaseAuth.instance.currentUser!.uid;
    currentFirebaseUserID = userID;

    futureFiles = FirebaseApi.listAll('files/$currentFirebaseUserID');
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
      title: Text('MyApp.title'),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];

                        return buildFile(context, file);
                      },
                    ),
                  ),
                  Text(totalSizeGB.toString()),

                ],
              );
            }
        }
      },
    ),
  );

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
    leading: ClipOval(
      child: Image.network(
        file.url,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
      ),
    ),
    title: Text(
      file.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        color: Colors.blue,
      ),
    ),
    onTap: () => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImagePage(file: file),
    )),
  );

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