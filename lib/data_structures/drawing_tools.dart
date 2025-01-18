import 'package:flutter/material.dart';

abstract class DrawingTool {
  final DrawingToolType drawingToolType;

  const DrawingTool({required this.drawingToolType});
}

abstract class BrushTool extends DrawingTool {
  final Color color;
  final double strokeWidth;

  const BrushTool({
    required this.color,
    required this.strokeWidth,
    required super.drawingToolType,
  });

  BrushTool copyWith({Color? color, double? strokeWidth});

  Paint get paint;
}

class Pen extends BrushTool {
  const Pen({required super.color, required super.strokeWidth}) : super(drawingToolType: DrawingToolType.pen);

  @override
  Pen copyWith({Color? color, double? strokeWidth}) {
    return Pen(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  Paint get paint => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round;
}

class Highlighter extends BrushTool {
  const Highlighter({
    required super.color,
    required super.strokeWidth,
  }) : super(
          drawingToolType: DrawingToolType.highlighter,
        );

  @override
  BrushTool copyWith({Color? color, double? strokeWidth}) {
    return Highlighter(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  Paint get paint => Paint()
    ..color = color.withOpacity(0.7)
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.square
    ..blendMode = BlendMode.darken;
}

class EraserTool extends DrawingTool {
  final double strokeWidth;

  const EraserTool({required this.strokeWidth}) : super(drawingToolType: DrawingToolType.eraser);
}

enum DrawingToolType {
  pen(name: "Pen", icon: Icons.create, hasColor: true, hasStrokeWidth: true),
  highlighter(name: "Highlighter", icon: Icons.highlight, hasColor: true, hasStrokeWidth: true),
  selection(name: "Selection", icon: Icons.select_all, hasColor: false, hasStrokeWidth: false),
  eraser(name: "Eraser", icon: Icons.delete, hasColor: false, hasStrokeWidth: true),
  ruler(name: "Ruler", icon: Icons.straighten, hasColor: false, hasStrokeWidth: false),
  circle(name: "Circle", icon: Icons.architecture, hasColor: false, hasStrokeWidth: false);

  final String name;
  final IconData icon;
  final bool hasColor, hasStrokeWidth;

  const DrawingToolType({required this.name, required this.icon, required this.hasColor, required this.hasStrokeWidth});
}
