import 'package:flutter/material.dart';
import 'package:single_line_rawing/modules/puzzle_painter/edge.dart';
import 'package:single_line_rawing/modules/puzzle_painter/line.dart';

class PuzzlePainter extends CustomPainter {
  final List<Offset> dots;
  final List<Line> lines;
  final List<Edge> edges;
  final List<int> visitedDots;
  final Set<String> traversedEdges;

  PuzzlePainter({
    required this.dots,
    required this.lines,
    required this.edges,
    required this.visitedDots,
    required this.traversedEdges,
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

    // Vẽ các cạnh đã đi qua (đậm)
    final traversedPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (var line in lines) {
      canvas.drawLine(line.start, line.end, traversedPaint);
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
