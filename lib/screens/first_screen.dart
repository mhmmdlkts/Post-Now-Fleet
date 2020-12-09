import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/screens/main_screen.dart';
import 'package:post_now_fleet/screens/splash_screen.dart';
import 'package:post_now_fleet/services/auth_service.dart';
import 'package:post_now_fleet/services/first_screen_service.dart';
import 'package:post_now_fleet/services/remote_config_service.dart';

import 'auth_screen.dart';


class FirstScreen extends StatefulWidget {
  final AsyncSnapshot snapshot;
  FirstScreen(this.snapshot);

  @override
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  final FirstScreenService _firstScreenService = FirstScreenService();
  bool needsUpdate;

  @override
  void initState() {
    super.initState();
    checkUpdates();
  }

  @override
  Widget build(BuildContext context) {
    if (needsUpdate??true)
      return SplashScreen();

    if (widget.snapshot.hasData) {
      _fetchUser();
      if (!(_firstScreenService.hasPermission()??false))
        return SplashScreen();
      return MainScreen(widget.snapshot.data, _firstScreenService.myFleet);
    }
    return AuthScreen();
  }

  checkUpdates() async {
    await RemoteConfigService.fetch();
    final onlineVersion = await RemoteConfigService.getBuildVersion();
    final int localVersion = int.parse((await PackageInfo.fromPlatform()).buildNumber);

    needsUpdate = localVersion < onlineVersion;

    if (mounted) setState(() {});

    if (needsUpdate)
      _firstScreenService.showUpdateAvailableDialog(context);
  }

  void _fetchUser() => _firstScreenService.fetchUser(widget.snapshot.data, context).then((value) {
    if (!value)
      return;
    setState(() {});
  });
}