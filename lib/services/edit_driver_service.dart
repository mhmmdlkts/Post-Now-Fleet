import 'package:firebase_database/firebase_database.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/services/all_drivers_service.dart';

class EditDriverService {
  final Driver driver;
  DatabaseReference _reference;

  EditDriverService(this.driver) {
    _reference = FirebaseDatabase.instance.reference().child('drivers').child(driver.key);
  }

  void setActive(bool active) {
    active = active??false;
    driver.active = active;
    _reference.child("active").set(active);
  }
}