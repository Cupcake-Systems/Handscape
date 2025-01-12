import 'package:flutter/material.dart';
import 'package:handscape/data_structures/notebook.dart';

class PageStrokesPainter extends CustomPainter {
  final NotebookPage page;

  PageStrokesPainter({super.repaint, required this.page});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / page.width, size.height / page.height);

    for (final pen in page.content.strokes.keys) {
      final penPaint = Paint()
        ..color = pen.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = pen.strokeWidth
        ..strokeCap = StrokeCap.round;

      for (final stroke in page.content.strokes[pen]!) {
        if (stroke.isEmpty) continue;

        if (stroke.length == 1) {
          canvas.drawCircle(stroke.first, pen.strokeWidth / 2, Paint()..color = pen.color);
          continue;
        }

        paintSmoothStrokeCatmull(stroke, penPaint, canvas);
      }
    }
  }

  /// Paints a smooth stroke using cubic Bezier curves
  void paintSmoothStrokeBezier(List<Offset> stroke, Paint penPaint, Canvas canvas) {
    final path = Path();
    if (stroke.length < 2) return;

    path.moveTo(stroke[0].dx, stroke[0].dy);

    for (int i = 1; i < stroke.length - 1; i++) {
      // Calculate the midpoints between consecutive points
      final midPoint1 = Offset(
        (stroke[i - 1].dx + stroke[i].dx) / 2,
        (stroke[i - 1].dy + stroke[i].dy) / 2,
      );
      final midPoint2 = Offset(
        (stroke[i].dx + stroke[i + 1].dx) / 2,
        (stroke[i].dy + stroke[i + 1].dy) / 2,
      );

      // Draw a cubic Bezier curve
      path.quadraticBezierTo(
        stroke[i].dx,
        stroke[i].dy,
        midPoint2.dx,
        midPoint2.dy,
      );
    }

    // Connect the last two points
    path.lineTo(stroke.last.dx, stroke.last.dy);

    canvas.drawPath(path, penPaint);
  }

  /// Paints a smooth stroke using Catmull-Rom splines
  void paintSmoothStrokeCatmull(List<Offset> stroke, Paint penPaint, Canvas canvas) {
    if (stroke.length < 2) return;

    final path = Path();
    path.moveTo(stroke[0].dx, stroke[0].dy);

    for (int i = 0; i < stroke.length - 1; i++) {
      final p0 = i == 0 ? stroke[i] : stroke[i - 1];
      final p1 = stroke[i];
      final p2 = stroke[i + 1];
      final p3 = i + 2 < stroke.length ? stroke[i + 2] : stroke[i + 1];

      // Calculate control points for the Catmull-Rom spline
      final controlPoint1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final controlPoint2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );

      // Draw cubic Bezier curve
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    canvas.drawPath(path, penPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
