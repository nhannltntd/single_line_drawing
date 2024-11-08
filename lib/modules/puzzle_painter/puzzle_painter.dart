import 'package:flutter/material.dart';
import 'package:single_line_rawing/modules/puzzle_painter/edge.dart';
import 'package:single_line_rawing/modules/puzzle_painter/line.dart';

class PuzzlePainter extends CustomPainter {
  final List<Offset> dots;
  final List<Line> lines;
  final List<Edge> edges;
  final List<int> visitedDots;
  final Set<String> traversedEdges;
  final List<Offset> currentDrawingPoints;
  final bool isDrawing;
  final double currentProgress;

  PuzzlePainter({
    required this.dots,
    required this.lines,
    required this.edges,
    required this.visitedDots,
    required this.traversedEdges,
    required this.currentDrawingPoints,
    required this.isDrawing,
    required this.currentProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ các cạnh hợp lệ (mờ)
    final edgePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var edge in edges) {
      canvas.drawLine(
        dots[edge.startIndex],
        dots[edge.endIndex],
        edgePaint,
      );
    }

    // Vẽ các cạnh đã hoàn thành
    final completedPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (var line in lines) {
      canvas.drawLine(line.start, line.end, completedPaint);
    }

    // Vẽ đường đang vẽ
    if (isDrawing && currentDrawingPoints.length == 2) {
      final currentPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      Offset start = currentDrawingPoints[0];
      Offset end = currentDrawingPoints[1];

      canvas.drawLine(start, end, currentPaint);
    }

    // Vẽ các điểm
    for (int i = 0; i < dots.length; i++) {
      final paint = Paint()
        ..color =
            visitedDots.contains(i) ? Colors.grey : const Color(0xFF4CAF50)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dots[i], 10, paint);
    }
  }

  @override
  bool shouldRepaint(PuzzlePainter oldDelegate) {
    return true;
  }
}
