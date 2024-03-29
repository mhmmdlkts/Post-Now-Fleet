import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/services/register_new_river_service.dart';
import 'package:post_now_fleet/widgets/custom_button1.dart';
import 'package:file_picker/file_picker.dart';


class RegisterNewDriverScreen extends StatefulWidget {
  final Fleet myFleet;
  RegisterNewDriverScreen(this.myFleet);

  @override
  _RegisterNewDriverScreenState createState() => _RegisterNewDriverScreenState();
}

class _RegisterNewDriverScreenState extends State<RegisterNewDriverScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _criminalRecordController = TextEditingController();
  TextEditingController _profilePhotoController = TextEditingController();
  TextEditingController _identityCardFrontController = TextEditingController();
  TextEditingController _identityCardBackController = TextEditingController();
  TextEditingController _residencePermitBackController = TextEditingController();
  TextEditingController _registrationSlipCardBackController = TextEditingController();
  File _profilePhoto;
  File _criminalRecord;
  File _identityCardFront;
  File _identityCardBack;
  File _residencePermit;
  File _registrationSlip;

  String _errorMessage = "";
  bool _isButtonActive = true;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTER_NEW_DRIVERS_SCREEN.TITLE".tr()),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.person),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.NAME".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.NAME".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _surnameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.person),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.SURNAME".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.SURNAME".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _emailController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.email),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.EMAIL".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.EMAIL".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _phoneController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.phone),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.PHONE".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.PHONE".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _profilePhotoController,
              onTap: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                );
                if (result == null)
                  return;
                _profilePhoto = await ImageCropper.cropImage(
                  sourcePath: result.paths.first,
                  aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                  compressFormat: ImageCompressFormat.jpg,
                  cropStyle: CropStyle.circle,
                );
                if (_profilePhoto == null)
                  return;
                setState(() {
                  _profilePhotoController.text = _profilePhoto.path.split("/").last;
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.image),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.PROFILE_PHOTO".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.PROFILE_PHOTO".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _criminalRecordController,
              onTap: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg']
                );
                if (result == null)
                  return;
                _criminalRecord = File(result.paths.first);
                setState(() {
                _criminalRecordController.text = result.names.first;
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.insert_drive_file_rounded),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.CRIMINAL_RECORD".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.CRIMINAL_RECORD".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _identityCardFrontController,
              onTap: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg']
                );
                if (result == null)
                  return;
                _identityCardFront = File(result.paths.first);
                setState(() {
                  _identityCardFrontController.text = result.names.first;
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.insert_drive_file_rounded),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.IDENTIFY_CARD_FRONT".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.IDENTIFY_CARD_FRONT".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _identityCardBackController,
              onTap: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg'],
                );
                if (result == null)
                  return;
                _identityCardBack = File(result.paths.first);
                setState(() {
                  _identityCardBackController.text = result.names.first;
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.insert_drive_file_rounded),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.IDENTIFY_CARD_BACK".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.IDENTIFY_CARD_BACK".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _residencePermitBackController,
              onTap: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg'],
                );
                if (result == null)
                  return;
                _residencePermit = File(result.paths.first);
                setState(() {
                  _residencePermitBackController.text = result.names.first;
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.insert_drive_file_rounded),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.RESIDENCE_PERMIT".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.RESIDENCE_PERMIT".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            TextFormField(
              controller: _registrationSlipCardBackController,
              onTap: () async {
                FilePickerResult result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg'],
                );
                if (result == null)
                  return;
                _registrationSlip = File(result.paths.first);
                setState(() {
                  _registrationSlipCardBackController.text = result.names.first;
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.insert_drive_file_rounded),
                hintText: "REGISTER_NEW_DRIVERS_SCREEN.REGISTRATION_SLIP".tr(),
                labelText: "REGISTER_NEW_DRIVERS_SCREEN.REGISTRATION_SLIP".tr(),
              ),
              onChanged: (val) => setState((){
              }),
            ),
            Container(height: 10),
            CustomButton1(
              isActive: _isFormCompleted(),
              onTap: () {
                setState(() {
                  _errorMessage = "";
                  _isButtonActive = false;
                });
                RegisterNewDriverService().registerDriver(
                  widget.myFleet.key,
                  _nameController.text,
                  _surnameController.text,
                  _emailController.text,
                  _phoneController.text,
                  _profilePhoto,
                  _criminalRecord,
                  _identityCardFront,
                  _identityCardBack,
                  _residencePermit,
                  _registrationSlip
                ).then((value) async {
                  if (value == null) {
                    setState(() {
                      _errorMessage = "REGISTER_NEW_DRIVERS_SCREEN.ERROR.REGISTERING".tr();
                      _isButtonActive = false;
                    });
                    return;
                  }
                  Navigator.pop(context, value);
                });
              },
              margin: 0,
              padding: 15,
              text: "REGISTER_NEW_DRIVERS_SCREEN.REGISTER_DRIVER".tr(),
            ),
            Container(height: 10,),
            Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 24), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  bool _isFormCompleted({bool areDocsRequired = false}) {
    if (!_isButtonActive) {
      _isButtonActive = true;
      return false;
    }
    return (_identityCardFrontController.text.isNotEmpty || !areDocsRequired) &&
      (_identityCardBackController.text.isNotEmpty || !areDocsRequired) &&
      (_criminalRecordController.text.isNotEmpty || !areDocsRequired) &&
      (_residencePermitBackController.text.isNotEmpty || !areDocsRequired) &&
      (_registrationSlipCardBackController.text.isNotEmpty || !areDocsRequired) &&
      _profilePhotoController.text.isNotEmpty &&
      _surnameController.text.isNotEmpty &&
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty;
  }
}