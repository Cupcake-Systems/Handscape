import 'dart:math';

import 'package:flutter/material.dart';

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

List<Offset> ramerDouglasPeucker(List<Offset> points, double epsilon) {
  if (points.length <= 2) return points;

  // Find the point with the maximum distance from the line segment
  double maxDistance = 0.0;
  int index = 0;
  for (int i = 1; i < points.length - 1; i++) {
    double distance = perpendicularDistance(points[i], points[0], points[points.length - 1]);
    if (distance > maxDistance) {
      maxDistance = distance;
      index = i;
    }
  }

  // If the maximum distance is greater than epsilon, recursively simplify
  List<Offset> result;
  if (maxDistance > epsilon) {
    List<Offset> left = ramerDouglasPeucker(points.sublist(0, index + 1), epsilon);
    List<Offset> right = ramerDouglasPeucker(points.sublist(index, points.length), epsilon);
    result = [...left.sublist(0, left.length - 1), ...right];
  } else {
    result = [points[0], points[points.length - 1]];
  }

  return result;
}

// Calculate the perpendicular distance from a point to a line
double perpendicularDistance(Offset point, Offset lineStart, Offset lineEnd) {
  double dx = lineEnd.dx - lineStart.dx;
  double dy = lineEnd.dy - lineStart.dy;
  double numerator = ((dy * point.dx) - (dx * point.dy) + (lineEnd.dx * lineStart.dy) - (lineEnd.dy * lineStart.dx)).abs();
  double denominator = sqrt(dx * dx + dy * dy);
  return numerator / denominator;
}
