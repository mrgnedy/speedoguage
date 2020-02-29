import 'dart:async';

import 'package:flutt_guage/resources/geo_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors/sensors.dart';

class SpeedBloc {
  Timer time;

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();


  bool _startCalculating = true;

  bool get getCalcStatus  => _startCalculating;
  bool startCalculating(bool b)  => _startCalculating = b;
  // int startSpeed;
  // int endSpeed;

  CurrentLocationRepo _locationRepo = CurrentLocationRepo.init();
  
  StreamController<double> speedStreamController = StreamController.broadcast();
  StreamController<double> accelTimeStreamController = StreamController.broadcast();
  StreamController<PermissionStatus> geoStatusController = StreamController();

  // TODO
  // Sink<PermissionStatus> get geoStatusSink => geoStatusController.sink;
  // Stream<PermissionStatus> get geoStatusStream => geoStatusController.stream;
  
  Sink<double> get speedSink => speedStreamController.sink;
  Stream<double> get speedStream => speedStreamController.stream;

  Sink<double> get accelSink => accelTimeStreamController.sink;
  Stream<double> get accelStream => accelTimeStreamController.stream;

  SpeedBloc.init() {
      _locationRepo.geoStatusStream.listen((geoLocPermission){
          //TODO
      });

    _locationRepo.speedStream.listen((postion) {
      final accelTime = calculateAcc(postion.speedInKMH());
      if (accelTime >= 0) accelSink.add(accelTime);
      speedSink.add(postion.speedInKMH());
      print(postion.speed);
    });
  }
  double calculateAcc(double x) {
    if (_startCalculating) {
      if (x >= 10) {
        timeStart = DateTime.now();
      }
      if (x >= 30) {
        _startCalculating = false;
        timeEnd = DateTime.now();
      }
    }
    final diference = timeStart.difference(timeEnd).inMilliseconds / 1000;

    return diference;
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
