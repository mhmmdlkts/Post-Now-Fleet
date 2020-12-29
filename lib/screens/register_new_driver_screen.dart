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
  File _profilePhoto;
  File _criminalRecord;
  File _identityCardFront;
  File _identityCardBack;

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
        title: Text("Register New Driver"),
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
                hintText: "Name",
                labelText: "Name",
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
                hintText: "Surname",
                labelText: "Surname",
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
                hintText: "Email",
                labelText: "Email",
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
                hintText: "Phone",
                labelText: "Phone",
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
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.image),
                hintText: "Vesikalik",
                labelText: "Vesikalik",
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
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.insert_drive_file_rounded),
                hintText: "Sabika kaydi",
                labelText: "Sabika kaydi",
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
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.insert_drive_file_rounded),
                hintText: "Kimlik Ön",
                labelText: "Kimlik Ön",
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
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.insert_drive_file_rounded),
                hintText: "Kimlik Arka",
                labelText: "Kimlik Arka",
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
                  _identityCardBack
                ).then((value) async {
                  if (value == null) {
                    setState(() {
                      _errorMessage = "Kayit sirasinda hata cikti.";
                      _isButtonActive = false;
                    });
                    return;
                  }
                  Navigator.pop(context, value);
                });
              },
              margin: 0,
              padding: 15,
              text: "Register Driver",
            ),
            Container(height: 10,),
            Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 24), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  bool _isFormCompleted() {
    if (!_isButtonActive) {
      _isButtonActive = true;
      return false;
    }
    return _identityCardFrontController.text.isNotEmpty &&
      _identityCardBackController.text.isNotEmpty &&
      _criminalRecordController.text.isNotEmpty &&
      _surnameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty;
  }
}