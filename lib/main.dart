import 'package:flutter/material.dart';
import 'package:handscape/pages/folder_content.dart';
import 'package:handscape/storage/app_storage.dart';

import 'data_structures/folder.dart';
import 'data_structures/notebook.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handscape',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Handscape"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Text("Handscape"),
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: FolderContentPage(
        thisFolder: Folder(
          name: "Root",
          creationTime: DateTime.now(),
          subFolders: [
            Folder(
              name: "Folder 1",
              creationTime: DateTime.now(),
              subFolders: [],
              notebooks: [],
            ),
            Folder(
              name: "Folder 2",
              creationTime: DateTime.now(),
              subFolders: [],
              notebooks: [],
            ),
          ],
          notebooks: [
            Notebook(
              title: "Liniert",
              creationTime: DateTime.now(),
              pages: [
                NotebookPage.lined(
                  widthMm: 210,
                  heightMm: 297,
                ),
              ],
            ),
            Notebook(
              title: "Kariert",
              creationTime: DateTime.now(),
              pages: [
                NotebookPage.checkered(
                  widthMm: 210,
                  heightMm: 297,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
