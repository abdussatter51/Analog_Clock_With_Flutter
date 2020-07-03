
import 'dart:math';

import 'package:flutter/material.dart';
final radian = 0.0174533;
class AnalogClock extends StatefulWidget {
  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {

  Stream<DateTime> tick() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_){
      return DateTime.now();
    });
  }

  final _clockContainer = Container(
    width: double.infinity,
    height: double.infinity,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: ClockPainter(),
            child: _clockContainer,
          ),
          StreamBuilder(
            stream: tick(),
            builder: (context, AsyncSnapshot<DateTime> snapshot) =>
                snapshot.hasData ? Stack(
                  children: <Widget>[
                    Transform.rotate(
                      angle: (snapshot.data.second * 6.0 * radian),
                      child: CustomPaint(
                        painter: SecondHandPainter(),
                        child: _clockContainer,
                      ),
                    ),
                    Transform.rotate(
                      angle: ((snapshot.data.minute + (((snapshot.data.second * 100) / 60)/100)) * 6.0 * radian),
                      child: CustomPaint(
                        painter: MinuteHandPainter(),
                        child: _clockContainer,
                      ),
                    ),
                    Transform.rotate(
                      angle: ((snapshot.data.hour % 12) * 30.0 + ((snapshot.data.minute * 30) / 60)) * radian,
                      child: CustomPaint(
                        painter: HourHandPainter(),
                        child: _clockContainer,
                      ),
                    ),
                    CustomPaint(
                      painter: CenterPointPainter(),
                      child: _clockContainer,
                    ),
                  ],
                ) : Container()
          ),
        ],
      ),
    );
  }
}

class CenterPointPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white60
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.02;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
   return false;
  }
}

class HourHandPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width/2, size.height/2);
    var radius = min(size.width, size.height) * 0.27;
    canvas.drawLine(Offset(center.dx, center.dy - radius * 0.80), Offset(center.dx, center.dy + 20), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
  return true;
  }
}

class MinuteHandPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width/2, size.height/2);
    var radius = min(size.width, size.height) * 0.35;
    canvas.drawLine(Offset(center.dx, center.dy - radius * 0.80), Offset(center.dx, center.dy + 25), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
   return true;
  }

}

class SecondHandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
        ..color = Colors.white30
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
    final center = Offset(size.width/2, size.height/2);
    var radius = min(size.width, size.height) * 0.40;
    canvas.drawLine(Offset(center.dx, center.dy - radius * 0.80), Offset(center.dx, center.dy + 30), paint);



  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClockPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 4
        ..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.45;
    canvas.drawCircle(center, radius, paint);
    canvas.save();

    canvas.translate(center.dx, center.dy);
    var tickHeight;
    paint.color = Colors.white;
    for(var i = 0; i < 60; i++){
      tickHeight = i % 5 == 0 ? 20 : 10;
      canvas.drawLine(Offset(0, -radius), Offset(0, -radius + tickHeight), paint);
      canvas.rotate(6 * radian);
    }
    canvas.restore();
    var labelRadius = radius * 0.80;
    var angle = -90;
    for(int i = 0; i < 12; i++){
      var x = labelRadius * cos(angle * radian) + center.dx;
      var y = labelRadius * sin(angle * radian) + center.dy;
      angle += 30;
      _drawText(Offset(x,y), canvas, i);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
  }

  void _drawText(Offset offset, Canvas canvas, int i) {
    var txtPainter = TextPainter(
      text: TextSpan(
        text: i == 0 ? '12' : '${i % 12}',
        style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    txtPainter.layout();
    txtPainter.paint(canvas, Offset(offset.dx - (txtPainter.width/2), offset.dy - (txtPainter.height/2)));
  }
}