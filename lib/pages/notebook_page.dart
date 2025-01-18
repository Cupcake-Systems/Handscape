import 'package:flutter/material.dart';
import 'package:handscape/data_structures/notebook.dart';
import 'package:handscape/storage/drawing_tools_storage.dart';
import 'package:handscape/widgets/singel_notebook_page.dart';

import '../data_structures/drawing_tools.dart';

class NotebookPageWidget extends StatefulWidget {
  final Notebook notebook;

  const NotebookPageWidget({super.key, required this.notebook});

  @override
  State<NotebookPageWidget> createState() => _NotebookPageWidgetState();
}

class _NotebookPageWidgetState extends State<NotebookPageWidget> {
  int selectedPageNumber = 0;
  final _transformationController = TransformationController();
  bool isDrawing = false;

  DrawingToolType selectedToolType = DrawingToolType.pen;
  Color selectedHighlighterColor = Colors.yellow;
  Color selectedPenColor = Colors.black;
  double selectedHighlighterStrokeWidth = 5 / 1000;
  double selectedPenStrokeWidth = 0.2 / 1000;
  double selectedEraserStrokeWidth = 5 / 1000;

  @override
  Widget build(BuildContext context) {
    Color? selectedColor;
    double? selectedStrokeWidth;

    switch (selectedToolType) {
      case DrawingToolType.pen:
        selectedColor = selectedPenColor;
        selectedStrokeWidth = selectedPenStrokeWidth;
        break;
      case DrawingToolType.highlighter:
        selectedColor = selectedHighlighterColor;
        selectedStrokeWidth = selectedHighlighterStrokeWidth;
        break;
      case DrawingToolType.eraser:
        selectedStrokeWidth = selectedEraserStrokeWidth;
        break;
      default:
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notebook.title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (var i = 0; i < widget.notebook.pages.length; i++)
                    ListTile(
                      title: Text('Page ${i + 1}'),
                      onTap: () {
                        setState(() {
                          selectedPageNumber = i;
                        });
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
            ListTile(
              title: const Text("Close"),
              leading: const Icon(Icons.close),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[300],
            child: Center(
              child: InteractiveViewer(
                panEnabled: !isDrawing,
                scaleEnabled: !isDrawing,
                boundaryMargin: const EdgeInsets.all(400),
                constrained: false,
                minScale: 0.1,
                maxScale: 5,
                transformationController: _transformationController,
                child: SizedBox(
                  width: 800,
                  child: SingleNotebookPage(
                    page: widget.notebook.pages[selectedPageNumber],
                    selectedTool: selectedToolType,
                    selectedColor: selectedColor,
                    selectedStrokeWidth: selectedStrokeWidth,
                    onStartDrawing: () {
                      setState(() {
                        isDrawing = true;
                      });
                    },
                    onStopDrawing: () {
                      setState(() {
                        isDrawing = false;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      for (final tool in DrawingToolType.values) ...[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedToolType = tool;
                            });
                          },
                          icon: Icon(tool.icon),
                          color: selectedToolType == tool ? Colors.blue : Colors.black,
                        ),
                      ],
                      if (selectedToolType.hasColor) ...[
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey,
                        ),
                        for (final color in DrawingToolsStorage.getSavedColors(selectedToolType)) ...[
                          colorSelectionButton(color, selectedColor == color, () {
                            setState(() {
                              if (selectedToolType == DrawingToolType.pen) {
                                selectedPenColor = color;
                              } else {
                                selectedHighlighterColor = color;
                              }
                            });
                          }),
                        ],
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                        ),
                      ],
                      if (selectedToolType.hasStrokeWidth) ...[
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey,
                        ),
                        for (final strokeWidth in DrawingToolsStorage.getSavedWidths(selectedToolType)) ...[
                          strokeWidthSelectionButton(strokeWidth, selectedStrokeWidth == strokeWidth, () {
                            setState(() {
                              if (selectedToolType == DrawingToolType.pen) {
                                selectedPenStrokeWidth = strokeWidth;
                              } else if (selectedToolType == DrawingToolType.highlighter) {
                                selectedHighlighterStrokeWidth = strokeWidth;
                              } else {
                                selectedEraserStrokeWidth = strokeWidth;
                              }
                            });
                          }),
                        ],
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorSelectionButton(Color color, bool isSelected, void Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey, width: isSelected ? 2 : 1),
        ),
      ),
    );
  }

  Widget strokeWidthSelectionButton(double strokeWidth, bool isSelected, void Function() onPressed) {
    const maxSize = 48;
    final maxStrokeWidth = DrawingToolsStorage.getSavedWidths(selectedToolType).reduce((a, b) => a > b ? a : b);
    final size = strokeWidth / maxStrokeWidth * maxSize;
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: Colors.black,
          border: Border.all(color: isSelected ? Colors.yellow : Colors.grey, width: isSelected ? 2 : 1),
        ),
      ),
    );
  }
}
