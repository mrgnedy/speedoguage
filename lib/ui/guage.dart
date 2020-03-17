import 'package:division/division.dart';
import 'package:flutt_guage/main.dart';
import 'package:flutt_guage/ui/guage_widget.dart';
import 'package:flutter/material.dart';

class SpeedoGuage extends StatefulWidget {
  @override
  _SpeedoGuageState createState() => _SpeedoGuageState();
}

class _SpeedoGuageState extends State<SpeedoGuage> {
  Offset offset = Offset(0, 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(-0.9, -0.9),
              child: gpsStatusWidget(),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Align(
                        alignment: Alignment(0, 0),
                        child: accelerationWidget())),
                Expanded(child: speedWidget()),
              ],
            ),
          ],
        ),
        // child: SpeedoGuage()
      ),
    );
  }
}

Widget gpsStatusWidget() {
  return Container(
    height: 20,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
        gradient: RadialGradient(colors: [Colors.greenAccent, Colors.green])),
  );
}

Widget speedWidget() {
  return StreamBuilder<double>(
      initialData: 0,
      stream: speedBloc.speedStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        return Container(
            width: 250, height: 250, child: Guage(speed: snapshot.data));
      });
}

TextEditingController startSpeedCtrler = TextEditingController();
TextEditingController endSpeedCtrler = TextEditingController();
Widget accelerationWidget() {
  return StreamBuilder<double>(
    stream: speedBloc.accelStream,
    initialData: 0,
    builder: (context, snapshot) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Txt('Acceleration Time',
            style: TxtStyle()
              ..textColor(Colors.white)
              ..fontSize(24)),
        Txt('${snapshot.data}',
            style: TxtStyle()
              ..textColor(Colors.white)
              ..fontSize(18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Txt(
                  'End',
                  style: TxtStyle()..textColor(Colors.white),
                ),
                speedTextField(endSpeedCtrler),
              ],
            ),
            RaisedButton(
            child: Txt('Start'),
             
              onPressed: () {
              speedBloc.startCalculating(
                  true,
                  double.parse(startSpeedCtrler.text),
                  double.parse(endSpeedCtrler.text));
            }),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Txt(
                  'Start',
                  style: TxtStyle()..textColor(Colors.white),
                ),
                speedTextField(startSpeedCtrler),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
            visible: speedBloc.maxSpeedReached(),
            child: Txt(
              'Max Speed Reached ${speedBloc.maxSpeed}',
              style: TxtStyle()
                ..textColor(Colors.white)
                ..alignment.center()
                ..alignmentContent.center()
                ..fontSize(22),
            ))
      ],
    ),
  );
}

Widget speedTextField(TextEditingController speedCtrlre) {
  return Container(
    width: 60,
    child: TextField(
      controller: speedCtrlre,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        hintText: '0.0',
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red)),
        fillColor: Colors.blueGrey[100],
      ),
      style: TextStyle(color: Colors.black),
    ),
  );
}

/// DEPRECATED
class _Guage extends CustomPainter {
  final Offset offset;

  _Guage(this.offset);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Path path = Path()
    // ..moveTo(0, 0)
    // ..quadraticBezierTo(-45, -50, 0, -100);
    // paint.color = Colors.green;

    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square;
    paint.strokeWidth = 10;
    // canvas.drawPath(path, paint);
    // path = Path()
    // ..moveTo(0, -100)
    // ..quadraticBezierTo(50, -142, 100, -100);
    // paint.color = Colors.orange;
    // canvas.drawPath(path, paint);
    // path = Path()
    // ..moveTo(100, -100)
    // ..quadraticBezierTo(145, -50, 100, 0);
    final rect = Rect.fromCenter(center: Offset(0, 0), width: 150, height: 0);
    // paint.color = Colors.red;
    paint.shader = LinearGradient(colors: [
      Colors.green,
      // Colors.green.withOpacity(0.3),
      Colors.yellow,
      Colors.yellow,

      Colors.red,

      // Colors.red.withOpacity(0.0),
    ]).createShader(rect);
    // canvas.translate(50, 0);
    paint.strokeCap = StrokeCap.round;
    canvas.translate(60, 0);
    canvas.drawPath(
        Path()
          ..moveTo(-80, 100)
          ..cubicTo(-100, -40, 100, -40, 80, 100),
        paint);

    paint.shader = null;
    paint.style = PaintingStyle.fill;
    paint.color = Colors.red;
    canvas.drawCircle(Offset(0, 90), 10, paint);
    Path path = Path()
      ..moveTo(-10, 90)
      ..quadraticBezierTo(offset.dx, -30, 10, 90);
    canvas.drawPath(path, paint);

    // canvas.drawPath(path, paint);
    // canvas.drawCircle(Offset(5, 5), 30, paint);
    // TODO: implement paint
    // canvas.drawpa
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
