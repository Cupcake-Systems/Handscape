import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:handscape/data_structures/notebook.dart';

class PageStrokesPainter extends CustomPainter {
  final NotebookPage page;
  final List<Offset>? selectionPath;

  PageStrokesPainter({super.repaint, required this.page, this.selectionPath});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / page.width, size.height / page.height);

    for (final stroke in page.content.strokes) {
      final strokePaint = stroke.$1.paint;
      final strokePoints = stroke.$2;

      if (strokePoints.isEmpty) continue;

      if (strokePoints.length == 1) {
        canvas.drawCircle(strokePoints.first, strokePaint.strokeWidth / 2, Paint()..color = strokePaint.color);
        continue;
      }

      paintSmoothStrokeCatmull(strokePoints, strokePaint, canvas);
    }

    if (selectionPath != null && selectionPath!.isNotEmpty) {
      paintDashedPath(
        path: Path()..addPolygon(selectionPath!, false),
        canvas: canvas,
        paint: Paint()
          ..color = Colors.black.withOpacity(0.4)
          ..strokeWidth = 0.4 / 1000
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round,
      );
      paintDashedPath(
        path: Path()
          ..moveTo(selectionPath!.first.dx, selectionPath!.first.dy)
          ..lineTo(selectionPath!.last.dx, selectionPath!.last.dy),
        canvas: canvas,
        paint: Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..strokeWidth = 0.3 / 1000
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  /// Paints a smooth stroke using cubic Bezier curves
  void paintSmoothStrokeBezier(List<Offset> stroke, Paint penPaint, Canvas canvas) {
    final path = Path();
    if (stroke.length < 2) return;

    path.moveTo(stroke[0].dx, stroke[0].dy);

    for (int i = 1; i < stroke.length - 1; i++) {
      // Calculate the midpoints between consecutive points
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

  void paintDashedPath({
    required Path path,
    required Canvas canvas,
    double dashWidth = 3 / 1000,
    double dashSpace = 3 / 1000,
    double distance = 0.0 / 1000,
    required Paint paint,
  }) {
    Path dashPath = Path();

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
