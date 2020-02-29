import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors/sensors.dart';

class CurrentLocationRepo {
  Geolocator _geolocator = Geolocator();
  Stream<Position> speedStream;
  Stream<PermissionStatus> geoStatusStream;

  CurrentLocationRepo.init() {
    // geoStatusStream= _geolocator.checkGeolocationPermissionStatus().asStream();
    geoStatusStream= PermissionHandler().checkPermissionStatus(PermissionGroup.location).asStream();
    
    speedStream = _geolocator.getPositionStream(
        LocationOptions(), GeolocationPermission.location);
  }
}
