import 'package:flutter/material.dart';
import 'package:handscape/canvas/page_background_canvas.dart';
import 'package:handscape/canvas/page_strokes_painter.dart';
import 'package:handscape/data_structures/notebook.dart';
import 'package:handscape/tools.dart';

class SingleNotebookPage extends StatefulWidget {
  final NotebookPage page;
  final Pen selectedPen;
  final void Function() onStartDrawing, onStopDrawing;

  const SingleNotebookPage({
    super.key,
    required this.page,
    required this.selectedPen,
    required this.onStartDrawing,
    required this.onStopDrawing,
  });

  @override
  State<SingleNotebookPage> createState() => _SingleNotebookPageState();
}

class _SingleNotebookPageState extends State<SingleNotebookPage> {
  bool isDrawing = false;

  @override
  Widget build(BuildContext context) {
    widget.page.content.strokes.putIfAbsent(widget.selectedPen, () => []);
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

            final position = localPositionInPage(event.localPosition);
            widget.page.content.strokes[widget.selectedPen]!.add([position]);
          },
          onPointerMove: (event) {
            if (event.buttons != 1) return;

            final position = localPositionInPage(event.localPosition);
            setState(() {
              widget.page.content.strokes[widget.selectedPen]!.last.add(position);
            });
          },
          onPointerUp: (event) {
            if (!isDrawing) return;

            widget.onStopDrawing();

            isDrawing = false;

            final strokes = widget.page.content.strokes[widget.selectedPen]!;

            widget.page.content.strokes[widget.selectedPen]![strokes.length - 1] = ramerDouglasPeucker(strokes.last, 0.00005);
          },
          child: CustomPaint(
            painter: PageBackgroundPainter(page: widget.page),
            foregroundPainter: PageStrokesPainter(page: widget.page),
          ),
        ),
      ),
    );
  }

  Offset localPositionInPage(Offset localPosition) {
    return Offset(localPosition.dx / 800 * widget.page.width, localPosition.dy / (800 / widget.page.aspectRatio) * widget.page.height);
  }
}
