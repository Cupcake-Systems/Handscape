import 'package:flutter/material.dart';
import 'package:handscape/data_structures/folder.dart';
import 'package:handscape/widgets/folder_button.dart';

import '../widgets/notebook_button.dart';

class FolderContentPage extends StatelessWidget {
  final Folder thisFolder;

  const FolderContentPage({super.key, required this.thisFolder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(thisFolder.name),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            for (final folder in thisFolder.subFolders)
              FolderButton(
                folder: folder,

              ),
            for (final notebook in thisFolder.notebooks)
              NotebookButton(
                notebook: notebook,
              ),
          ],
        ),
      ),
    );
  }
}
