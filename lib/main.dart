import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('21 Day Roadmap'),
        ),
        body: const CirclesWithCurvyLine(),
      ),
    );
  }
}

class Circle extends StatefulWidget {
  const Circle({super.key});

  @override
  State<Circle> createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CirclesWithCurvyLine extends StatefulWidget {
  const CirclesWithCurvyLine({super.key});

  @override
  State<CirclesWithCurvyLine> createState() => _CirclesWithCurvyLineState();
}

class _CirclesWithCurvyLineState extends State<CirclesWithCurvyLine> {
  final Random random = Random();
  final int numberOfCircles = 21;

  final int currentDay = 5;

  List<Offset> circlePositions = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    generateRandomPositions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void generateRandomPositions() {
    for (int i = 0; i < numberOfCircles; i++) {
      circlePositions.add(Offset(
        random.nextDouble() * 300,
        i * 100.0 + 50.0,
      ));
    }
    circlePositions = circlePositions.reversed.toList();
  }

  bool isActive(int index) {
    if (index < currentDay) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: CustomPaint(
        size: Size(double.infinity, numberOfCircles * 100.0 + 50.0),
        painter: CurvyLinePainter(circlePositions, currentDay),
        child: SizedBox(
          height: numberOfCircles * 100.0 + 50.0,
          child: Stack(
            children: circlePositions.map((position) {
              bool isActivePosition =
                  isActive(circlePositions.indexOf(position));
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: isActivePosition ? Colors.blue : Colors.grey,
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3)),
                  ),
                  // child: Text(
                  //   'Day ${circlePositions.indexOf(position) + 1}',
                  //   style: const TextStyle(color: Colors.white, fontSize: 10),
                  // ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class CurvyLinePainter extends CustomPainter {
  final List<Offset> circlePositions;
  final int currentDay;

  CurvyLinePainter(this.circlePositions, this.currentDay);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (circlePositions.isNotEmpty) {
      Path path = Path();
      path.moveTo(size.width / 2, size.height);

      for (int i = 0; i < currentDay; i++) {
        var p = circlePositions[i];

        if (i == 0) {
          var p1 = Offset(size.width / 2, size.height);
          var controlPoint1 = Offset(p1.dx, (p1.dy + p.dy) / 2);
          var controlPoint2 = Offset(p.dx, (p1.dy + p.dy) / 2);
          path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
              controlPoint2.dy, p.dx + 25, p.dy + 25);
        } else {
          var p1 = circlePositions[i - 1];
          var controlPoint1 = Offset(p1.dx, (p1.dy + p.dy) / 2);
          var controlPoint2 = Offset(p.dx, (p1.dy + p.dy) / 2);
          path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
              controlPoint2.dy, p.dx + 25, p.dy + 25);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
