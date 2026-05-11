import 'package:flutter/material.dart';

// Simulated Dark Map UI with Rider Chevron and Traffic Heatmap (P3-T11)
class GisCanvas extends StatelessWidget {
  const GisCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A0A0A), // Dark map base
      child: Stack(
        children: [
          // Simulated map grid
          CustomPaint(
            painter: MapGridPainter(),
            size: Size.infinite,
          ),

          // Simulated Traffic Heatmap Layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.red, Colors.transparent],
                    center: Alignment(0.2, -0.3),
                    radius: 0.4,
                  ),
                ),
              ),
            ),
          ),

          // Rider Chevron (Center)
          const Center(
            child: Icon(
              Icons.navigation,
              color: Colors.tealAccent,
              size: 40.0,
            ),
          ),

          // Debug Overlay for constraints
          const Positioned(
            top: 16.0,
            left: 16.0,
            child: Card(
              color: Colors.black54,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📍 Lagos / Wuse Hub", style: TextStyle(color: Colors.white70)),
                    Text("🚦 Heatmap Active", style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
