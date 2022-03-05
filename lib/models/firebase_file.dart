import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFile {
  final Reference ref;
  final String name;
  final String url;
  final String size;

  const FirebaseFile({
    required this.ref,
    required this.name,
    required this.url,
    required this.size
  });
}