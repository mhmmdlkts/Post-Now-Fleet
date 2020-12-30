import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/widgets/contact_widget.dart';

class ContactFormScreen extends StatefulWidget {
  final User user;
  ContactFormScreen(this.user);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactFormScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(("CONTACT_FORM.TITLE".tr()), style: TextStyle(color: Colors.white)),
          brightness: Brightness.dark,
          iconTheme:  IconThemeData(color: Colors.white),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            ContactWidget(widget.user)
          ],
        )
    );
  }
}