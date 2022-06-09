

import 'package:vekant_filesharing_app/models/firebase_file.dart';

String currentFirebaseUserID = '';
String currentFirebaseUserEmail = '';
String emailUrlDownload = '';

double totalSizeGB = 0;

int numberOfImages = 0;
int numberOfVideos = 0;
int numberOfAudio = 0;
int numberOfFiles = 0;

final List<String> filesNames = [];
final List<FirebaseFile> filesList = [];

List<FirebaseFile> listRecievedFiles = [];