
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../models/firebase_file.dart';

class FirebaseApi {

  static Future<List<String>> _getDownloadLinks(List<firebase_storage.Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = firebase_storage.FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();


    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
      final ref = result.items[index];
      print('Referacnce :: ${ref}');
      final name = ref.name;
      var size = 'nosize';

      ref.getMetadata().then((value) {

        print('in then');
        var sizeInBytes= value.size;
        var s = value.contentType?.contains('video');
        print('Content Type :: ' + s!.toString());
        totalSizeGB = totalSizeGB + (sizeInBytes!/(1024 * 1024));
        size = (sizeInBytes/(1024 * 1024)).toString();
        print(size);

      });

      final file = FirebaseFile(ref: ref, name: name, url: url,size: size,type: '');

      print('File Name :: $name  File Size :: $size');

      return MapEntry(index, file);
    })
        .values
        .toList();
  }

  static Future receivedFilesListAll(String path) async {
    var ref = firebase_storage.FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    bool dateIsAfter = true;
    String size = ' ';
    FirebaseFile file;

    for(int index = 0; index < result.items.length; index++){
      final ref = result.items[index];
      final name = ref.name;
      final url = await ref.getDownloadURL();
      String size = '';
      String fileType = '';

      final cmetadata = await ref.getMetadata();
      final custommeta = await cmetadata.customMetadata!['showDate'];
      size = cmetadata.size.toString();
      fileType = cmetadata.contentType!;

      print('Costom Meta Data :: ${custommeta}');
      
      DateTime showDate = DateTime.parse(custommeta!);
      DateTime nowDate = DateTime.now();
      
      bool timeafter = nowDate.isAfter(showDate);

      print(timeafter);

      if(timeafter == true){
        final file = FirebaseFile(ref: ref, name: name, url: url, size: size,type: fileType);
        listRecievedFiles.add(file);
      }else{
        print('time after was true :: no added');
      }




    }
print(listRecievedFiles.length);
print(listRecievedFiles.first.name);



  }

  static Future copyfile() async {

    final fileRefrence = firebase_storage.FirebaseStorage.instance.ref().child('files/gogo@gmail.com/Receive Files/pexels-max-andrey-1366630.jpg');
    print(fileRefrence.name);
    print(fileRefrence.fullPath);
    final url = await fileRefrence.getDownloadURL();
    print(url);
    print(fileRefrence.getDownloadURL());
    String email = 'gogo';
    String showDate = '2022-04-16 02:02:00.000';


    Map userDataMap = {
      "showDate": showDate,
      "name": fileRefrence.name,
      "dURL": url,
      "fullPath": fileRefrence.fullPath,
    };
    // recievedFilesRef.child(email).set(userDataMap);

  }

  static Future putteeFile() async {
    final ref = firebase_storage.FirebaseStorage.instance.ref().child('files/yoyo');

    print('Download File Function Called ' );
    File file = File('files/member@gmail.com/pexels-max-andrey-1366630.jpg');
    print(file);

    ref.putFile(file);

  }

  static Future downloadFile(firebase_storage.Reference ref) async {

    print('Download File Function Called ' );
    print(ref.name);
    final dir = await getApplicationDocumentsDirectory();
    print(dir.absolute);
    File file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);

  }
  // static Future downloadFileURL(String url,String name) async {
  //
  //   print('Download File Function Super Called ' );
  //
  //   final dir = await getApplicationDocumentsDirectory();
  //   final path = '${dir.path}/$name';
  //   await Dio().download(url, path,onReceiveProgress: (received,total){
  //     double progress = received/total;
  //   });
  //    if(url.contains('.png')){
  //      await GallerySaver.saveImage(path,toDcim: true);
  //    }else{
  //        await GallerySaver.saveImage(path,toDcim: true);
  //    }
  //
  //
  // }

  // upload tasks files and hales

  static firebase_storage.UploadTask? uploadFile(String destination, File file, String showDate) {
print(destination);
    firebase_storage.SettableMetadata metadata =
    firebase_storage.SettableMetadata(
      cacheControl: 'max-age=60',
      customMetadata: <String, String>{
        'showDate': showDate,
      },
    );

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      return ref.putFile(file, metadata);
    } on firebase_storage.FirebaseException catch (e) {
      return null;
    }
  }

  static firebase_storage.UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);

    } on firebase_storage.FirebaseException catch (e) {
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

  static Future<List<FirebaseFile>> listAllImages(String path) async {
    print('priinting in ListAllImages');
    final ref = firebase_storage.FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

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
        if(value.contentType!.contains('video')){
          print('printing inside videos');
          numberOfVideos = numberOfVideos + 1;
        }
        else if(value.contentType!.contains('image')){
          numberOfImages = numberOfImages + 1;
        }
        else if(value.contentType!.contains('audio')){
          numberOfAudio = numberOfAudio + 1;
        }
        else{
          numberOfFiles = numberOfFiles + 1;
        }
      });

      // final sizeInMbs = (size/(1024 * 1024)).toString();
      final file = FirebaseFile(ref: ref, name: name, url: url,size: size,type: '');

      print('File Name :: $name  File Size :: $size');

      return MapEntry(index, file);
    })
        .values
        .toList();
  }


  // var filePath = File(ref.fullPath);
  // int bytes = await filePath.length();
}