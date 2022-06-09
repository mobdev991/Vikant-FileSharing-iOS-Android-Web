import 'package:flutter/material.dart';
import 'package:vekant_filesharing_app/api/firebase_api.dart';
import 'package:vekant_filesharing_app/config.dart';
import 'package:vekant_filesharing_app/models/firebase_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';


class HistoryItem extends StatefulWidget {
  final FirebaseFile fileList;
  HistoryItem({required this.fileList});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  Map<int,double> downloadProgress = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sender Email',
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'System',
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'File Name',
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.fileList.name,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'File Type',
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold,),
                      ),
                      Text(
                        widget.fileList.type,style: TextStyle(fontSize: 12
                      ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'File Size',
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.fileList.size} bytes',style: TextStyle(fontSize:12
                      ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 15))),
                          onPressed: (){
                           downloadFileURL(widget.fileList.url, widget.fileList.name);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.download),
                              Text('Download')],
                          )),

                      SizedBox(width: 20),

                      ElevatedButton(style: ButtonStyle(

                          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 15))),
                          onPressed: (){
                            widget.fileList.ref.delete();
                          },
                          child: Row(
                              children: [
                                Icon(Icons.delete),
                                Text('Delete')],
                          )),

                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future downloadFileURL(String url,String name) async {

    print('Download File Function Super Called ' );

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$name';
    await Dio().download(url, path,onReceiveProgress: (received,total){
      double progress = received/total;
      setState(() {
      });
    });
    if(url.contains('.png')){
      await GallerySaver.saveImage(path,toDcim: true);
    }else{
      await GallerySaver.saveImage(path,toDcim: true);
    }


  }
}
