import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui';
import 'dart:async';

class SoulSphereWidget extends StatefulWidget {
  final double pulseValue; // 1.0 (Struggling) to 3.0 (Calm)
  final String? stateId; // "Peaceful", "Jagged", "Radiant"

  const SoulSphereWidget({
    super.key,
    required this.pulseValue,
    this.stateId,
  });

  @override
  State<SoulSphereWidget> createState() => _SoulSphereWidgetState();
}

class _SoulSphereWidgetState extends State<SoulSphereWidget> with SingleTickerProviderStateMixin {
  FragmentShader? _shader;
  late Ticker _ticker;
  double _elapsed = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed.inMilliseconds / 1000.0;
      });
    });
  }

  Future<void> _loadShader() async {
    try {
      final program = await FragmentProgram.fromAsset('assets/shaders/soul_sphere.frag');
      setState(() {
        _shader = program.fragmentShader();
        _isLoading = false;
        _ticker.start();
      });
    } catch (e) {
      debugPrint('❌ Error loading Soul-Sphere shader: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox(height: 380, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));

    // Map pulse to shader parameters
    // Peaceful (3.0): low noise (0.05), high fluidity (1.0)
    // Jagged (1.0): high noise (0.3), low fluidity (0.5)
    final noise = 0.05 + (1.0 - (widget.pulseValue - 1.0) / 2.0) * 0.25;
    final fluidity = 0.5 + ((widget.pulseValue - 1.0) / 2.0) * 0.5;

    return SizedBox(
      height: 380,
      width: double.infinity,
      child: Stack(
        children: [
          // The Shader Orb
          if (_shader != null)
            Positioned.fill(
              child: CustomPaint(
                painter: SoulSpherePainter(
                  shader: _shader!,
                  time: _elapsed,
                  pulse: widget.pulseValue,
                  noise: noise,
                  fluidity: fluidity,
                ),
              ),
            ),
          
          // Fallback if shader fails
          if (_shader == null)
            Center(child: _buildFallbackOrb(_getGlowColor(widget.pulseValue))),
        ],
      ),
    );
  }

  Widget _buildFallbackOrb(Color color) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.4), color.withOpacity(0.1), Colors.transparent],
        ),
      ),
    );
  }

  Color _getGlowColor(double value) {
    if (value <= 1.5) return Colors.indigo;
    if (value <= 2.5) return Colors.amber;
    return Colors.cyanAccent;
  }
}

class SoulSpherePainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final double pulse;
  final double noise;
  final double fluidity;

  SoulSpherePainter({
    required this.shader,
    required this.time,
    required this.pulse,
    required this.noise,
    required this.fluidity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);
    shader.setFloat(3, pulse);
    shader.setFloat(4, noise);
    shader.setFloat(5, fluidity);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(SoulSpherePainter oldDelegate) => true;
}
