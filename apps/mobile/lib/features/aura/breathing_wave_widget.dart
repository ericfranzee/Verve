import 'dart:ui';
import 'package:flutter/material.dart';

class BreathingWaveWidget extends StatefulWidget {
  final Color waveColor;
  final double intensity; // 0.0 to 1.0 depending on state

  const BreathingWaveWidget({
    super.key,
    required this.waveColor,
    this.intensity = 1.0,
  });

  @override
  State<BreathingWaveWidget> createState() => _BreathingWaveWidgetState();
}

class _BreathingWaveWidgetState extends State<BreathingWaveWidget> with SingleTickerProviderStateMixin {
  FragmentProgram? _program;
  late final AnimationController _timeController;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _timeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Controls time passing to shader
    )..repeat();
  }

  Future<void> _loadShader() async {
    try {
      final program = await FragmentProgram.fromAsset('shaders/breathing_wave.frag');
      setState(() {
        _program = program;
      });
    } catch (e) {
      debugPrint("Failed to load shader: $e");
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_program == null) {
      return const SizedBox.shrink(); // fallback while loading
    }

    return AnimatedBuilder(
      animation: _timeController,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavePainter(
            program: _program!,
            time: _timeController.value * 10.0, // Scale time for visual effect
            waveColor: widget.waveColor,
            intensity: widget.intensity,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final FragmentProgram program;
  final double time;
  final Color waveColor;
  final double intensity;

  _WavePainter({
    required this.program,
    required this.time,
    required this.waveColor,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);
    shader.setFloat(3, waveColor.r);
    shader.setFloat(4, waveColor.g);
    shader.setFloat(5, waveColor.b);
    shader.setFloat(6, intensity);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.time != time ||
           oldDelegate.intensity != intensity ||
           oldDelegate.waveColor != waveColor;
  }
}
