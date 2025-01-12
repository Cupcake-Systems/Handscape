import 'package:flutter/material.dart';
import 'package:handscape/data_structures/notebook.dart';

class PageBackgroundPainter extends CustomPainter {
  final NotebookPage page;
  static const double lineWidth = 0.1 / 1000;

  PageBackgroundPainter({super.repaint, required this.page});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / page.width, size.height / page.height);

    final linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    switch (page.lineature.type) {
      case LineatureType.checkered:
        for (int xMm = page.lineature.spacingXMm; xMm < page.widthMm; xMm += page.lineature.spacingXMm) {
          final x = xMm / 1000;
          canvas.drawLine(
            Offset(x, 0),
            Offset(x, page.height),
            linePaint,
          );
        }
        for (int yMm = page.lineature.spacingYMm; yMm < page.heightMm; yMm += page.lineature.spacingYMm) {
          final y = yMm / 1000;
          canvas.drawLine(
            Offset(0, y),
            Offset(page.width, y),
            linePaint,
          );
        }
        break;
      case LineatureType.lined:
        for (int yMm = page.lineature.spacingYMm; yMm < page.heightMm; yMm += page.lineature.spacingYMm) {
          final y = yMm / 1000;
          canvas.drawLine(
            Offset(0, y),
            Offset(page.width, y),
            linePaint,
          );
        }
        break;
    }


  }

  @override
  bool shouldRepaint(PageBackgroundPainter oldDelegate) {
    return oldDelegate.page != page;
  }
}
