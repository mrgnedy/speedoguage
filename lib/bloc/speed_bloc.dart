import 'dart:async';

import 'package:flutt_guage/resources/geo_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors/sensors.dart';

class SpeedBloc {
  Timer time;

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  double _startSpeed;
  double _endSpeed;

  double _difference;

  bool _detectStartSpeedTime = false;
  bool _detectEndSpeedTime = false;

  bool maxSpeedReached() =>
      !(_detectEndSpeedTime && _detectStartSpeedTime) && _difference != 0;

  bool get getCalcStatus => _detectStartSpeedTime;
  void startCalculating(bool isCalc, double startSpeed, double endSpeed) {
    _difference = 0.0;
    _startSpeed = startSpeed;
    _endSpeed = endSpeed;
    timeStart = DateTime.now();
    timeEnd = DateTime.now();
    _detectEndSpeedTime = false;
    _detectStartSpeedTime = isCalc;
    print('Starting speed is: $startSpeed');
    print('Finishing speed is: $endSpeed');
  }
  // int startSpeed;
  // int endSpeed;

  CurrentLocationRepo _locationRepo = CurrentLocationRepo.init();

  StreamController<double> speedStreamController = StreamController.broadcast();
  StreamController<double> accelTimeStreamController =
      StreamController.broadcast();
  StreamController<PermissionStatus> geoStatusController = StreamController();

  // TODO
  // Sink<PermissionStatus> get geoStatusSink => geoStatusController.sink;
  // Stream<PermissionStatus> get geoStatusStream => geoStatusController.stream;

  Sink<double> get speedSink => speedStreamController.sink;
  Stream<double> get speedStream => speedStreamController.stream;

  Sink<double> get accelSink => accelTimeStreamController.sink;
  Stream<double> get accelStream => accelTimeStreamController.stream;

  SpeedBloc.init() {
    _locationRepo.geoStatusStream.listen((geoLocPermission) {
      //TODO
    });

    _locationRepo.speedStream.listen((postion) {
      final accelTime = calculateAcc(postion.speedInKMH());
      if (accelTime >= 0) accelSink.add(accelTime);
      speedSink.add(postion.speedInKMH());
      print(postion.speedInKMH());
    });
  }
  double calculateAcc(double x) {
    if (_detectStartSpeedTime) {
      if (x >= _startSpeed) {
        timeStart = DateTime.now();
        _detectStartSpeedTime = false;
        _detectEndSpeedTime = true;
      }
    }
    if (_detectEndSpeedTime) {
      if (x >= _endSpeed) {
        timeEnd = DateTime.now();
        _detectEndSpeedTime = false;
      }
    }
    _difference = 0.0;
    if (!(_detectEndSpeedTime && _detectStartSpeedTime))
      _difference = timeStart.difference(timeEnd).inMilliseconds / 1000;

    return _difference;
  }

  double msToKMH(double value) {
    return value * 3.6;
    // _locationRepo.geoStatusStream.listen((status){

    //   geoStatus = status;
    //   print(geoStatus);
    // });
  }

  dispose() {
    speedStreamController?.close();
    accelTimeStreamController?.close();
    geoStatusController?.close();
  }
}

extension PositinMOD on Position {
  double speedInKMH() {
    return this.speed * 3.6;
  }
}
