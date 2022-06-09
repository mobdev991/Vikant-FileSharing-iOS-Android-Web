import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:vekant_filesharing_app/my_home_page.dart';
import '../api/firebase_api.dart';
import '../models/firebase_file.dart';
import '../pages/image_page.dart';

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    final userID = FirebaseAuth.instance.currentUser!.uid;


    futureFiles = FirebaseApi.listAll('files/$currentFirebaseUserEmail');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Container(

      padding: EdgeInsets.all(2),
      width: 100,
      height: 50,
      child: IconButton(
        icon: Icon(Icons.file_upload,color: Colors.blue,size: 50,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBar: AppBar(
      title: Text('Images'),
      centerTitle: true,
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
                  SizedBox(height: 20,)

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
      '$length Images Files',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}