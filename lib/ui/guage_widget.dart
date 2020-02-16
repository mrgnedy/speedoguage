import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Guage extends StatelessWidget {
  final double speed;

  const Guage({Key key, this.speed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 3000,
      axes: <RadialAxis>[buildRadialAxis()],
    );
  }

  RadialAxis buildRadialAxis() {
    return RadialAxis(
      minimum: 0,
      maximum: 60,
      ranges: [
        GaugeRange(startValue: 0, endValue: 20, color: Colors.green),
        GaugeRange(startValue: 20, endValue: 40, color: Colors.yellow),
        GaugeRange(startValue: 40, endValue: 60, color: Colors.red),
      ],
      annotations: [buildGaugeAnnotation()],
      pointers: [
        buildNeedlePointer(),
      ],
      useRangeColorForAxis: true,
    );
  }

  GaugeAnnotation buildGaugeAnnotation() {
    return GaugeAnnotation(
        widget: Text(
          '${speed.toStringAsFixed(3)}Kmh/h',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        positionFactor: 0.7,
        angle: 90);
  }

  NeedlePointer buildNeedlePointer() {
    return NeedlePointer(
      knobStyle: KnobStyle(
        color: Colors.green,
        borderColor: Colors.red,
        borderWidth: 0.05,
      ),
      animationDuration: 3000,
      animationType: AnimationType.easeInCirc,
      needleColor: Colors.yellow,
      gradient: LinearGradient(colors: [
        Colors.green,
        Colors.yellow,
        Colors.red,
      ]),
      value: speed,
    );
  }
}
