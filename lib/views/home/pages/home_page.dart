import 'package:flutter/material.dart';
import 'package:single_line_rawing/modules/puzzle_painter/edge.dart';
import 'package:single_line_rawing/modules/puzzle_painter/line.dart';
import 'package:single_line_rawing/modules/puzzle_painter/puzzle_painter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Single Line Drawing',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const PuzzlePage(),
    );
  }
}

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final List<Offset> dots = [
    const Offset(100, 100),
    const Offset(300, 100),
    const Offset(200, 200),
    const Offset(100, 300),
    const Offset(300, 300),
  ];
  final List<Edge> edges = [
    Edge(0, 2),
    Edge(2, 1),
    Edge(1, 4),
    Edge(4, 2),
    Edge(2, 3),
    Edge(3, 0),
  ];

  final List<Line> lines = [];
  final List<int> visitedDots = [];
  Set<String> traversedEdges = {};
  bool isDrawing = false;
  String message = '';
  int lastDotIndex = -1;
  List<Offset> currentDrawingPoints = [];
  double currentProgress = 0.0;

  Offset getProjectedPoint(Offset point, Offset lineStart, Offset lineEnd) {
    final lineVector = lineEnd - lineStart;
    final pointVector = point - lineStart;

    final lineLength = lineVector.distance;
    if (lineLength == 0) return lineStart;

    final t =
        (pointVector.dx * lineVector.dx + pointVector.dy * lineVector.dy) /
            (lineLength * lineLength);

    final clampedT = t.clamp(0.0, 1.0);

    return lineStart + (lineVector * clampedT);
  }

  void _onPanStart(DragStartDetails details) {
    int dotIndex = _getNearestDotIndex(details.localPosition);
    if (dotIndex != -1) {
      setState(() {
        lines.clear();
        visitedDots.clear();
        traversedEdges.clear();
        isDrawing = true;
        lastDotIndex = dotIndex;
        currentDrawingPoints = [dots[dotIndex]];
        visitedDots.add(dotIndex);
        message = '';
        currentProgress = 0.0;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isDrawing) return;

    if (lastDotIndex != -1) {
      Offset startPoint = dots[lastDotIndex];
      Offset? endPoint;

      // Tìm cạnh hợp lệ từ điểm hiện tại
      for (int i = 0; i < dots.length; i++) {
        if (i != lastDotIndex) {
          Edge attemptedEdge = Edge(lastDotIndex, i);
          if (edges.contains(attemptedEdge) ||
              edges.contains(attemptedEdge.reversed())) {
            // Kiểm tra xem chuột có nằm gần đường thẳng không
            Offset projectedPoint =
                getProjectedPoint(details.localPosition, startPoint, dots[i]);
            double distanceToLine =
                (details.localPosition - projectedPoint).distance;

            // Nếu chuột đủ gần đường thẳng (trong phạm vi 30 pixel)
            if (distanceToLine < 30) {
              endPoint = dots[i];
              break;
            }
          }
        }
      }

      if (endPoint != null) {
        // Tính điểm chiếu
        Offset projectedPoint =
            getProjectedPoint(details.localPosition, startPoint, endPoint);

        setState(() {
          currentDrawingPoints = [
            startPoint,
            projectedPoint,
          ];

          // Tính tiến độ vẽ
          currentProgress = (projectedPoint - startPoint).distance /
              (endPoint! - startPoint).distance;

          if (currentProgress > 0.9) {
            Edge attemptedEdge = Edge(lastDotIndex, dots.indexOf(endPoint));
            String edgeKey = attemptedEdge.getKey();

            if (!traversedEdges.contains(edgeKey)) {
              traversedEdges.add(edgeKey);
              lines.add(Line(
                start: startPoint,
                end: endPoint,
                progress: 1.0,
              ));

              int newDotIndex = dots.indexOf(endPoint);
              if (!visitedDots.contains(newDotIndex)) {
                visitedDots.add(newDotIndex);
              }
              lastDotIndex = newDotIndex;

              // Kiểm tra xem có thể đi tiếp được không
              if (!hasAvailableEdges(lastDotIndex) &&
                  traversedEdges.length != edges.length) {
                setState(() {
                  message = 'Thất bại! Bạn đã đi vào ngõ cụt!';
                  isDrawing = false;
                });
                return;
              }

              currentDrawingPoints = [dots[lastDotIndex]];
              currentProgress = 0.0;
            }
          }
        });
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDrawing = false;
      lastDotIndex = -1;
      currentDrawingPoints.clear();
      if (message.isEmpty) {
        _checkPuzzleCompletion();
      }
    });
  }

  int _getNearestDotIndex(Offset position) {
    for (int i = 0; i < dots.length; i++) {
      if ((position - dots[i]).distance < 20) {
        return i;
      }
    }
    return -1;
  }

  void _checkPuzzleCompletion() {
    if (traversedEdges.length == edges.length) {
      message = 'Chúc mừng! Bạn đã hoàn thành game!';
    } else {
      message = 'Thất bại! Bạn chưa đi qua tất cả các cạnh!';
    }
  }

  // Thêm method để kiểm tra xem từ một điểm có thể đi tiếp được không
  bool hasAvailableEdges(int currentDotIndex) {
    for (var edge in edges) {
      String edgeKey = edge.getKey();
      if ((edge.startIndex == currentDotIndex ||
              edge.endIndex == currentDotIndex) &&
          !traversedEdges.contains(edgeKey)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Line Drawing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: CustomPaint(
                  painter: PuzzlePainter(
                    dots: dots,
                    lines: lines,
                    edges: edges,
                    visitedDots: visitedDots,
                    traversedEdges: traversedEdges,
                    currentDrawingPoints: currentDrawingPoints,
                    isDrawing: isDrawing,
                    currentProgress: currentProgress,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
