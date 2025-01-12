import 'package:handscape/data_structures/notebook.dart';

class Folder {
  final String name;
  final DateTime creationTime;
  final List<Folder> subFolders;
  final List<Notebook> notebooks;

  const Folder({
    required this.name,
    required this.creationTime,
    required this.subFolders,
    required this.notebooks,
  });
}
