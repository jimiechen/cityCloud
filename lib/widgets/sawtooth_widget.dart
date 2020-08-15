import 'package:flutter/material.dart';

class SawtoothWidget extends StatelessWidget {
  final Color color;
  final double xStep;
  SawtoothWidget({this.color = Colors.white, this.xStep = 8});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: SawtoothPainter(xStep: xStep, color: color),
    );
  }
}

class SawtoothPainter extends CustomPainter {
  final Color color;
  final double xStep;
  SawtoothPainter({this.color = Colors.white, this.xStep = 8});
  @override
  void paint(Canvas canvas, Size size) {
    double y = 0;
    double x = 0;

    Path path = Path()
      ..moveTo(0, xStep + 1)
      ..lineTo(0, 0);
    do {
      x += xStep;
      y = xStep - y;
      path.lineTo(x, y);
    } while (x < size.width);
    path.lineTo(x, xStep + 1);
    path.close();
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(SawtoothPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
