import 'package:flutter/material.dart';

/// P5-T06: Spatial Depletion Horizon
///
/// An AR prototype visualization for the predictive pantry.
/// Uses a Stack to simulate an AR overlay showing depletion horizons of pantry items
/// over a camera view placeholder.
class SpatialDepletionHorizon extends StatelessWidget {
  const SpatialDepletionHorizon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera View Placeholder
          // In a real AR implementation, this would be ARKit/ARCore camera view
          const Center(
            child: Text(
              '[ Camera View Placeholder ]\nPoint at your pantry',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          ),

          // 2. Depletion Horizon Overlay Grid
          Positioned.fill(
            child: CustomPaint(
              painter: _HorizonGridPainter(),
            ),
          ),

          // 3. Simulated AR Item Tags
          Positioned(
            top: 200,
            left: 100,
            child: _buildItemTag('Almond Milk', 'Depletes in 2 days', Colors.redAccent),
          ),
          Positioned(
            top: 350,
            right: 80,
            child: _buildItemTag('Oats', 'Depletes in 5 days', Colors.orangeAccent),
          ),
          Positioned(
            bottom: 150,
            left: 150,
            child: _buildItemTag('Olive Oil', 'Healthy Stock (30+ days)', Colors.greenAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTag(String name, String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(status, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class _HorizonGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double spacing = 50.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
