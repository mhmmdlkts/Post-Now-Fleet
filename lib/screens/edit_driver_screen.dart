import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/services/edit_driver_service.dart';


class EditDriverScreen extends StatefulWidget {
  final Driver driver;

  EditDriverScreen(this.driver);

  @override
  _EditDriverScreenState createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  EditDriverService _editDriverService;
  bool _active;

  @override
  void initState() {
    super.initState();
    _active = widget.driver.active;
    _editDriverService = EditDriverService(widget.driver);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driver.name + widget.driver.surname),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Row(
            children: [
              _circularImage(widget.driver.image),
              Text(widget.driver.name + widget.driver.surname, style: TextStyle(fontSize: 18),)
            ],
          ),
          Container(height: 15,),
          _getInfoRow("PHONE".tr() + ":", widget.driver.phone),
          Container(height: 5,),
          _getInfoRow("EMAIL".tr() + ":", widget.driver.email),
          Container(height: 5,),
          _getInfoRow("IS_ACTIVE".tr() + ":", (_active??false).toString()),
          Container(height: 5,),
          Opacity(
            opacity: _active == null?0.3:1,
            child: FlatButton(
              onPressed: _active == null?(){}:() => setState(() {
                _active = !_active;
                _editDriverService.setActive(_active);
              }),
              child: Text((_active??false?"DEACTIVATE":"ACTIVATE").tr(), style: TextStyle(color: Colors.white),),
              color: (_active??false?Colors.red:Colors.green),
            ),
          )
        ],
      ),
    );
  }

  Widget _getInfoRow(String key, String val) {
    TextStyle style = TextStyle(fontSize: 18);
    return Row(
      children: [
        Text(key, style: style,),
        Container(width: 10,),
        SelectableText(val, style: style,),
      ],
    );
  }

  Widget _circularImage(String imgUrl) {
    return Container(
      margin: EdgeInsets.only(right: 14),
      child: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(imgUrl),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.red,
      ),
    );
  }
}