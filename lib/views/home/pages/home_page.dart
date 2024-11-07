import 'package:flutter/material.dart';
import 'package:single_line_rawing/modules/puzzle_painter/edge.dart';
import 'package:single_line_rawing/modules/puzzle_painter/line.dart';
import 'package:single_line_rawing/modules/puzzle_painter/puzzle_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _onPanStart(DragStartDetails details) {
    // ✅ Kiểm tra khi người dùng bắt đầu chạm lên màn hình
    int dotIndex = _getNearestDotIndex(details.localPosition);
    // tức là kiểm tra xem ngón tay người dùng chọn vào nó ngay điểm nào
    if (dotIndex != -1) {
      setState(() {
        lines.clear();
        visitedDots.clear();
        traversedEdges.clear();
        isDrawing = true;
        lastDotIndex = dotIndex;
        visitedDots.add(dotIndex);
        message = '';
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isDrawing) return;

    // ✅kiểm tra khi user nó di chuyển đến chổ khác xem có trúng vào nút không
    int dotIndex = _getNearestDotIndex(details.localPosition);
    if (dotIndex != -1 && dotIndex != lastDotIndex) {
      Edge attemptedEdge = Edge(lastDotIndex, dotIndex);

      // check nếu cạnh hợp lê
      bool isValidEdge = edges.contains(attemptedEdge) ||
          edges.contains(attemptedEdge.reversed());

      if (!isValidEdge) {
        setState(() {
          isDrawing = false;
          message = 'Thất bại! Cạnh không hợp lệ!';
        });
        return;
      }

      // ✅Kiểm tra cạnh được đi qua
      String edgeKey = attemptedEdge.getKey();
      if (traversedEdges.contains(edgeKey)) {
        // Cạnh đã được đi qua trước đó
        setState(() {
          isDrawing = false;
          message = 'Thất bại! Bạn không được đi lại đường cũ!';
        });
      } else {
        setState(() {
          // Thêm cạnh mới
          traversedEdges.add(edgeKey);
          lines.add(Line(
            start: dots[lastDotIndex],
            end: dots[dotIndex],
          ));
          if (!visitedDots.contains(dotIndex)) {
            visitedDots.add(dotIndex);
          }
          lastDotIndex = dotIndex;
        });
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDrawing = false;
      lastDotIndex = -1;
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
    // Kiểm tra nếu người dùng đã đi qua tất cả các cạnh hợp lệ
    if (traversedEdges.length == edges.length) {
      message = 'Chúc mừng! Bạn đã hoàn thành game!';
    } else {
      message = 'Thất bại! Bạn chưa đi qua tất cả các cạnh!';
    }
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
