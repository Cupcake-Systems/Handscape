import 'dart:ui';

import 'drawing_tools.dart';

class Notebook {
  String title;
  List<NotebookPage> pages;
  final DateTime creationTime;

  Notebook({
    required this.title,
    required this.pages,
    required this.creationTime,
  });
}

class NotebookPage {
  final int widthMm, heightMm;
  final Lineature lineature;
  final NotebookPageContent content;

  NotebookPage({
    required this.widthMm,
    required this.heightMm,
    required this.lineature,
    NotebookPageContent? content,
  }) : content = content ?? NotebookPageContent.empty();

  double get width => widthMm / 1000;

  double get height => heightMm / 1000;

  double get aspectRatio => width / height;

  NotebookPage.checkered({
    required this.widthMm,
    required this.heightMm,
    int spacingXMm = 5,
    int spacingYMm = 5,
    int? marginWidthMm,
  })  : lineature = Lineature(
          name: "Checkered $spacingXMm x $spacingYMm",
          type: LineatureType.checkered,
          spacingXMm: spacingXMm,
          spacingYMm: spacingYMm,
          marginWidthMm: marginWidthMm,
        ),
        content = NotebookPageContent.empty();

  NotebookPage.lined({
    required this.widthMm,
    required this.heightMm,
    int spacingYMm = 5,
    int? marginWidthMm,
  })  : lineature = Lineature(
          name: "Lined $spacingYMm",
          type: LineatureType.lined,
          spacingXMm: 0,
          spacingYMm: spacingYMm,
          marginWidthMm: marginWidthMm,
        ),
        content = NotebookPageContent.empty();
}

class NotebookPageContent {
  final List<(BrushTool brush, List<Offset> points)> strokes;

  const NotebookPageContent({
    required this.strokes,
  });

  NotebookPageContent.empty() : strokes = [];
}

class Lineature {
  final String name; // Name der Lineatur
  final LineatureType type; // Typ der Lineatur (z. B. "kariert", "liniert", "punktkariert")
  final int spacingXMm; // Horizontaler Abstand zwischen den Linien (in mm)
  final int spacingYMm; // Vertikaler Abstand zwischen den Linien (in mm)
  final int? marginWidthMm; // Breite des Randes (in mm)

  const Lineature({
    required this.name,
    required this.type,
    required this.spacingXMm,
    required this.spacingYMm,
    this.marginWidthMm,
  });
}

enum LineatureType {
  checkered,
  lined,
}
