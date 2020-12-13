import 'package:firebase_database/firebase_database.dart';
import 'package:post_now_fleet/models/address.dart';
import 'global_settings.dart';

class Fleet {
  String key;
  String name;
  String phone;
  String email;
  String token;
  Address address;
  GlobalSettings settings;
  bool isActive;

  Fleet({this.key, this.name, this.isActive, this.phone, this.email, this.token, this.address, this.settings}) {
    settings = GlobalSettings();
  }

  Fleet.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    name = snapshot.value["name"];
    phone = snapshot.value["phone"];
    email = snapshot.value["email"];
    token = snapshot.value["token"];
    isActive = snapshot.value["active"];
    if (snapshot.value["settings"] != null)
      settings = GlobalSettings.fromJson(snapshot.value["settings"]);
    if (snapshot.value["address"] != null)
      address = Address.fromJson(snapshot.value["address"]);
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'name': name,
    'phone': phone,
    'email': email,
    'token': token,
    'active': isActive,
    'address': address?.toMap(),
    'settings': settings?.toJson()
  };
}