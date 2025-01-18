import 'dart:ui';

import '../data_structures/drawing_tools.dart';

const List<Color> defaultPenColors = [
  Color(0xFF000000),
  Color(0xFF0000FF),
  Color(0xFF00FF00),
  Color(0xFF00FFFF),
  Color(0xFFFF0000),
  Color(0xFFFF00FF),
  Color(0xFFFFFF00),
  Color(0xFFFFFFFF),
];

const List<double> defaultPenWidths = [0.2 / 1000, 0.5 / 1000, 1 / 1000, 2 / 1000, 5 / 1000];
const List<double> defaultHighlighterWidths = [5 / 1000, 10 / 1000, 20 / 1000];
const List<double> defaultEraserWidths = defaultPenWidths;

abstract class DrawingToolsStorage {
  static List<Color> _savedPenColors = _loadAvailablePenColors();
  static List<Color> _savedHighlighterColors = _loadAvailableHighlighterColors();

  static List<double> _savedPenWidths = _loadAvailablePenWidths();
  static List<double> _savedHighlighterWidths = _loadAvailableHighlighterWidths();

  static List<double> _savedEraserWidths = _loadAvailableEraserWidths();

  static List<Color> _loadAvailablePenColors() {
    return defaultPenColors;
  }

  static List<Color> _loadAvailableHighlighterColors() {
    return defaultPenColors;
  }

  static List<double> _loadAvailablePenWidths() {
    return defaultPenWidths;
  }

  static List<double> _loadAvailableHighlighterWidths() {
    return defaultHighlighterWidths;
  }

  static List<double> _loadAvailableEraserWidths() {
    return defaultEraserWidths;
  }

  static List<Color> getSavedColors(DrawingToolType toolType) {
    switch (toolType) {
      case DrawingToolType.pen:
        return _savedPenColors;
      case DrawingToolType.highlighter:
        return _savedHighlighterColors;
      default:
        throw Exception("Invalid tool type");
    }
  }

  static List<double> getSavedWidths(DrawingToolType toolType) {
    switch (toolType) {
      case DrawingToolType.pen:
        return _savedPenWidths;
      case DrawingToolType.highlighter:
        return _savedHighlighterWidths;
      case DrawingToolType.eraser:
        return _savedEraserWidths;
      default:
        throw Exception("Invalid tool type");
    }
  }
}
