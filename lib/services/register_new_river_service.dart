import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:http/http.dart' as http;
import 'package:post_now_fleet/environment/global_variables.dart';

class RegisterNewDriverService {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://post-now-f3c53.appspot.com');

  Future<String> registerDriver (
    String fleetId,
    String name,
    String surname,
    String email,
    String phone,
    File profilePhoto,
    File criminalRecord,
    File identityCardFront,
    File identityCardBack,
  ) async {
    Driver newDriver = Driver(fleetId: fleetId, name: name, surname: surname, email: email, phone: phone);

    String url = Uri.encodeFull('${FIREBASE_URL}registerDriverPart1?driver=${json.encode(newDriver.toJson())}&uid=$fleetId');
    http.Response response = await http.get(url);
    if (response.statusCode != 200)
      throw('Status code: ' + response.statusCode.toString());
    dynamic result = json.decode(response.body);
    if (result["error"] != null && result["key"] == null)
      return null;

    String ppUrl = await _startUpload(profilePhoto, result["key"], 'profile', getDownloadUrl: true, extension: "png");
    newDriver.image = ppUrl;
    await FirebaseDatabase.instance.reference().child('drivers').child(result["key"]).set(newDriver.toJson()).catchError((onError) => print(onError));

    try {
      _startUpload(criminalRecord, result["key"], 'criminal_record');
      _startUpload(identityCardFront, result["key"], 'identity_card_front');
      _startUpload(identityCardBack, result["key"], 'identity_card_back');
    } catch (e) {
      print(e);
    }
    print('bityp');
    return result["key"];
  }

  Future<String> _startUpload(File file, String driverId, String filename, {bool getDownloadUrl = false, String extension}) async {
    assert(file != null);
    if (extension == null) extension = file.path.split('.').last;
    final dbImagePath = 'drivers_doc/$driverId/$filename.$extension';
    final _uploadTask = await (_storage.ref().child(dbImagePath).putFile(file)).catchError((onError) => print(onError.toString() + "   " + dbImagePath));
    if (getDownloadUrl)
      return await _uploadTask.ref.getDownloadURL();
    return null;
  }
}