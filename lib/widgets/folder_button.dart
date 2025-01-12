import 'package:flutter/material.dart';
import 'package:handscape/data_structures/folder.dart';
import 'package:handscape/tools.dart';

import '../pages/folder_content.dart';

class FolderButton extends StatelessWidget {
  final Folder folder;

  const FolderButton({super.key, required this.folder});

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
                child: Icon(Icons.folder),
              ),
              Text(folder.name),
            ],
          ),
        ),
      ),
    );
  }

  void onTap(BuildContext context) {
    pushPage(context, FolderContentPage(thisFolder: folder));
  }
}
