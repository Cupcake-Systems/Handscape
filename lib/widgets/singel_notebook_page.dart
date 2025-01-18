import 'package:flutter/material.dart';
import 'package:handscape/canvas/page_background_canvas.dart';
import 'package:handscape/canvas/page_strokes_painter.dart';
import 'package:handscape/data_structures/notebook.dart';
import 'package:handscape/tools.dart';

import '../data_structures/drawing_tools.dart';

class SingleNotebookPage extends StatefulWidget {
  final NotebookPage page;
  final void Function() onStartDrawing, onStopDrawing;

  final DrawingToolType selectedTool;
  final Color? selectedColor;
  final double? selectedStrokeWidth;

  const SingleNotebookPage({
    super.key,
    required this.page,
    required this.selectedTool,
    required this.onStartDrawing,
    required this.onStopDrawing,
    required this.selectedColor,
    required this.selectedStrokeWidth,
  });

  @override
  State<SingleNotebookPage> createState() => _SingleNotebookPageState();
}

class _SingleNotebookPageState extends State<SingleNotebookPage> {
  bool isDrawing = false;
  List<Offset> selectionPath = [];

  @override
  Widget build(BuildContext context) {
    BrushTool? brushTool;

    if (widget.selectedTool == DrawingToolType.pen || widget.selectedTool == DrawingToolType.highlighter) {
      switch (widget.selectedTool) {
        case DrawingToolType.pen:
          brushTool = Pen(color: widget.selectedColor!, strokeWidth: widget.selectedStrokeWidth!);
          break;
        case DrawingToolType.highlighter:
          brushTool = Highlighter(color: widget.selectedColor!, strokeWidth: widget.selectedStrokeWidth!);
          break;
        default:
          throw Exception("Invalid brush tool type");
      }
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: widget.page.aspectRatio,
        child: Listener(
          onPointerDown: (event) {
            if (event.buttons != 1) return;

            isDrawing = true;

            widget.onStartDrawing();

            if (brushTool != null) {
              final position = localPositionInPage(event.localPosition);
              setState(() {
                widget.page.content.strokes.add((brushTool!, [position]));
              });
            } else if (widget.selectedTool == DrawingToolType.selection) {
              setState(() {
                selectionPath.add(localPositionInPage(event.localPosition));
              });
            }
          },
          onPointerMove: (event) {
            if (event.buttons != 1) return;

            if (brushTool != null) {
              final position = localPositionInPage(event.localPosition);
              setState(() {
                widget.page.content.strokes.last.$2.add(position);
              });
            } else if (widget.selectedTool == DrawingToolType.selection) {
              setState(() {
                selectionPath.add(localPositionInPage(event.localPosition));
              });
            }
          },
          onPointerUp: (event) {
            if (!isDrawing) return;

            widget.onStopDrawing();

            isDrawing = false;

            final oldPoints = widget.page.content.strokes.last.$2;
            final optimizedPoints = ramerDouglasPeucker(oldPoints, 0.00005);
            widget.page.content.strokes.last.$2.clear();
            widget.page.content.strokes.last.$2.addAll(optimizedPoints);
            selectionPath.clear();
          },
          child: CustomPaint(
            painter: PageBackgroundPainter(page: widget.page),
            foregroundPainter: PageStrokesPainter(page: widget.page, selectionPath: selectionPath),
          ),
        ),
      ),
    );
  }

  Offset localPositionInPage(Offset localPosition) {
    return Offset(localPosition.dx / 800 * widget.page.width, localPosition.dy / (800 / widget.page.aspectRatio) * widget.page.height);
  }
}
