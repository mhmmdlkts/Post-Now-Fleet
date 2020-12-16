import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:post_now_fleet/models/driver.dart';
import 'package:post_now_fleet/models/fleet.dart';
import 'package:post_now_fleet/services/all_drivers_service.dart';
import 'package:post_now_fleet/widgets/custom_button1.dart';

import '../register_new_driver_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:post_now_fleet/enums/permission_typ_enum.dart';
import 'package:post_now_fleet/services/permission_service.dart';

class MapsViewTab extends StatefulWidget {
  final BitmapDescriptor driverLocationIcon, driverLocationIconOnJob;
  final Fleet myFleet;
  MapsViewTab(this.myFleet, this.driverLocationIcon, this.driverLocationIconOnJob);

  @override
  _MapsViewTabState createState() => _MapsViewTabState();
}

class _MapsViewTabState extends State<MapsViewTab> {
  Position _myPosition;
  final GlobalKey _mapKey = GlobalKey();
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    _initMyPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            compassEnabled: false,
            key: _mapKey,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
            onMapCreated: _onMapCreated,
            markers: _createMarker(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ),
        _getBottomMenu(),
      ],
      alignment: Alignment.center,
    );
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Widget _getBottomMenu() {
    return Container();
  }

  Set<Marker> _createMarker() {
    Set markers = Set<Marker>();
    AllDriverService.allDrivers.forEach((e) {
      if (!(e.isOnline??false))
        return;
      markers.add(e.getMarker(e.isOnJob()?widget.driverLocationIconOnJob:widget.driverLocationIcon));
    });
    return markers;
  }

  void _setMyPosition(Position pos) {
    //_placesService = PlacesService(pos);
    _myPosition = pos;
  }

  void _onPositionChanged(Position position) {
    _setMyPosition(position);
  }

  Future<void> _initMyPosition() async {
    if (await PermissionService.positionIsNotGranted(context, PermissionTypEnum.LOCATION))
      return null;

    const locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    Geolocator().getPositionStream(locationOptions).listen(_onPositionChanged);

    _setMyPosition(await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low));

    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) => {
      _myPosition = value,
    });

    await _mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_myPosition.latitude, _myPosition.longitude), zoom: 13)
    ));
  }
}