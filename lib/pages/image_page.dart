
import 'package:flutter/material.dart';
import 'package:vekant_filesharing_app/config.dart';

import '../../models/firebase_file.dart';
import '../api/firebase_api.dart';
import 'list_files.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);

    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              await FirebaseApi.downloadFile(file.ref);
              final snackBar = SnackBar(
                content: Text('Downloaded ${file.name}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await file.ref.delete();
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ListPage()));
            },
          ),
          const SizedBox(width: 12),

        ],
      ),
      body: isImage
          ? Image.network(
        file.url,
        height: double.infinity,
        fit: BoxFit.cover,
      )
          : Center(
        child: Text(
          'Cannot be displayed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}