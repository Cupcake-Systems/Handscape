import 'package:flutter/material.dart';
import 'package:handscape/data_structures/notebook.dart';
import 'package:handscape/widgets/singel_notebook_page.dart';

class NotebookPageWidget extends StatefulWidget {
  final Notebook notebook;

  const NotebookPageWidget({super.key, required this.notebook});

  @override
  State<NotebookPageWidget> createState() => _NotebookPageWidgetState();
}

class _NotebookPageWidgetState extends State<NotebookPageWidget> {
  int selectedPageNumber = 0;
  final _transformationController = TransformationController();
  final thePen = const Pen(color: Colors.black, strokeWidth: 0.5 / 1000);
  bool isDrawing = false;

  @override
  Widget build(BuildContext context) {
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
                onInteractionUpdate: (details) {
                  final correctScale = _transformationController.value.getMaxScaleOnAxis();
                },
                child: SizedBox(
                  width: 800,
                  child: SingleNotebookPage(
                    page: widget.notebook.pages[selectedPageNumber],
                    selectedPen: thePen,
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
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.select_all),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.grey,
                      ),
                      colorSelectionButton(Colors.black),
                      colorSelectionButton(Colors.white),
                      colorSelectionButton(Colors.blue),
                      colorSelectionButton(Colors.red),
                      colorSelectionButton(Colors.green),
                      colorSelectionButton(Colors.yellow),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                      ),
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

  Widget colorSelectionButton(Color color) {
    return IconButton(
      onPressed: () {},
      icon: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
          border: Border.all(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}
