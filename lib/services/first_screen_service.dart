import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class FirstScreenService {

  Fleet myFleet;

  Future<bool> fetchUser(User user, BuildContext context) async {
    if (myFleet != null)
      return false;
    DataSnapshot result = await FirebaseDatabase.instance.reference().child('fleets').child(user.uid).once();
    myFleet = Fleet.fromSnapshot(result);
    if (!hasPermission())
      showNoAccountDialog(context);
    return true;
  }

  Future<void> showNoAccountDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('DIALOGS.NO_ACCOUNT.TITLE'.tr()),
          content: SingleChildScrollView(
            child: Text('DIALOGS.NO_ACCOUNT.BODY'.tr()),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('DIALOGS.NO_ACCOUNT.BUTTON'.tr()),
              onPressed: () => exit(0), // TODO first logout
            ),
          ],
        );
      },
    );
  }

  Future<void> showUpdateAvailableDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('DIALOGS.UPDATE_AVAILABLE.TITLE'.tr()),
          content: SingleChildScrollView(
            child: Text('DIALOGS.UPDATE_AVAILABLE.BODY'.tr()),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('DIALOGS.UPDATE_AVAILABLE.BUTTON'.tr()),
              onPressed: () {
                StoreRedirect.redirect();
              },
            ),
          ],
        );
      },
    );
  }

  bool hasPermission() => myFleet?.isActive??false;
}