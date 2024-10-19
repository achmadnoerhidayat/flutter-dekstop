import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double dashWidth;
  final double dashSpace;
  final Color color;

  const DashedLine({
    super.key,
    this.dashWidth = 10.0,
    this.dashSpace = 5.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        color: color,
      ),
      child: Container(),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color;

  DashedLinePainter({
    required this.dashWidth,
    required this.dashSpace,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double distance = 0;
    while (distance < size.width) {
      path.moveTo(distance, 0);
      path.lineTo(distance + dashWidth, 0);
      distance += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
