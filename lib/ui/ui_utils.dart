import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

/// Creates a default
Widget makeDottedLine() {
  return DottedLine(
      dashLength: 1,
      dashGapLength: 3,
      lineThickness: 1,
      dashColor: Colors.blueGrey,
  );
}