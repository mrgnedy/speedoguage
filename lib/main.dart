import 'package:flutt_guage/bloc/speed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutt_guage/ui/guage.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main()  {
  SyncfusionLicense.registerLicense('NT8mJyc2IWhiZH1nfWN9Z2VoYHxiYXxhY2Fjc2ZpZmdpZmBzAx5oPiE0PTY3KhM0PjI6P30wPD4=');
  runApp(MyApp());}

  SpeedBloc speedBloc = SpeedBloc.init();
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      dispose: (_, __) => speedBloc.dispose(),
      create: (context) => speedBloc,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SpeedoGuage(),
      ),
    );
  }
}
