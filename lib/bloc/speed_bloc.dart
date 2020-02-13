import 'dart:async';

import 'package:flutt_guage/resources/geo_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors/sensors.dart';

class SpeedBloc {
  CurrentLocationRepo _locationRepo = CurrentLocationRepo.init();
  StreamController<double> speedStreamController = StreamController();
  PermissionStatus geoStatus;
  StreamController<double> geoStatusController = StreamController();
  Sink<double> get speedSink  => speedStreamController.sink;
  Stream<double> get speedStream  => speedStreamController.stream;
  SpeedBloc.init(){
    _locationRepo.speedStream.listen((postion){
      
      if(postion==null)
      print('isNull');
      print(geoStatus);
      speedSink.add(postion. speed);
      print(postion.speed);
    });
    // _locationRepo.geoStatusStream.listen((status){

    //   geoStatus = status;
    //   print(geoStatus);
    // });
    
  }



  dispose(){
    speedStreamController?.close();
    geoStatusController?.close();
  }
}