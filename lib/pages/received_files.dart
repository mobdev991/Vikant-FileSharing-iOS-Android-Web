import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:vekant_filesharing_app/my_home_page.dart';
import '../api/firebase_api.dart';
import '../models/firebase_file.dart';
import '../widgets/recieved_item.dart';
import 'image_page.dart';

class ReceivedFilesPage extends StatefulWidget {
  @override
  _ReceivedFilesPageState createState() => _ReceivedFilesPageState();
}

class _ReceivedFilesPageState extends State<ReceivedFilesPage> {

  @override
  void initState() {
    super.initState();
    final userID = FirebaseAuth.instance.currentUser!.uid;
    currentFirebaseUserID = userID;

    // futureRecievedFiles = FirebaseApi.listAll('files/$currentFirebaseUserEmail/Receive Files');

    // print(futureFiles);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Received Files'),
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
    body: ListView.separated(
      itemBuilder: (BuildContext context, index) {
        return HistoryItem(fileList: listRecievedFiles[index]);
      },
      separatorBuilder: (BuildContext context, index) => SizedBox(
        height: 3,
      ),
      itemCount: listRecievedFiles.length,
      padding: EdgeInsets.all(5),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
    ),

    // FutureBuilder<List<FirebaseFile>>(
    //   future: futureRecievedFiles,
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return Center(child: CircularProgressIndicator());
    //       default:
    //         if (snapshot.hasError) {
    //           return Center(child: Text('Some error occurred!'));
    //         } else {
    //           final files = snapshot.data!;
    //
    //           return Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               buildHeader(files.length),
    //               const SizedBox(height: 12),
    //               Expanded(
    //                 child: ListView.builder(
    //                   itemCount: files.length,
    //                   itemBuilder: (context, index) {
    //                     final file = files[index];
    //
    //                     return buildFile(context, file);
    //                   },
    //                 ),
    //               ),
    //               Text(totalSizeGB.toString()),
    //
    //             ],
    //           );
    //         }
    //     }
    //   },
    // ),
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