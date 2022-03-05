import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:vekant_filesharing_app/config.dart';


import '../models/firebase_file.dart';

class FirebaseApi {

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    final totalFizeSize = '0 MB';

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
      final ref = result.items[index];
      final name = ref.name;
      // var urleee = Uri.https('www.googleapis.com', ref.fullPath);
      // http.Response response = http.get(urleee) as http.Response;
      var size = ' ';
      ref.getMetadata().then((value) {
        print('in then');
        var sizeInBytes= value.size;
        totalSizeGB = totalSizeGB + (sizeInBytes!/(1024 * 1024));
        size = (sizeInBytes/(1024 * 1024)).toString();
        print(size);
      });

      // final sizeInMbs = (size/(1024 * 1024)).toString();
      final file = FirebaseFile(ref: ref, name: name, url: url,size: size);

      print('File Name :: $name  File Size :: $size');

      return MapEntry(index, file);
    })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');
    print(await file.length());

    await ref.writeToFile(file);
  }

  // upload tasks files and hales

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

    } on FirebaseException catch (e) {
      return null;
    }
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    int finalSize = 2;
    return finalSize;
  }

  // var filePath = File(ref.fullPath);
  // int bytes = await filePath.length();
}