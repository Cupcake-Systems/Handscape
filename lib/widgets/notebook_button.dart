import 'package:flutter/material.dart';
import 'package:handscape/data_structures/notebook.dart';
import 'package:handscape/pages/notebook_page.dart';

import '../tools.dart';

class NotebookButton extends StatelessWidget {

  final Notebook notebook;

  const NotebookButton({super.key, required this.notebook});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.book),
              ),
              Text(notebook.title),
            ],
          ),
        ),
      ),
    );
  }

  void onTap(BuildContext context) {
    pushPage(context, NotebookPageWidget(notebook: notebook));
  }

}