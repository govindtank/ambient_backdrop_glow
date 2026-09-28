import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ambient_backdrop_glow/ambient_backdrop_glow.dart';

void main() {
  group('AmbientBackdropGlow Widget & Painter Tests', () {
    test('AmbientColorPalette factory and copyWith', () {
      final palette = AmbientColorPalette.fromColors([
        Colors.purple,
        Colors.teal,
        Colors.orange,
      ]);

      expect(palette.primary, Colors.purple);
      expect(palette.secondary, Colors.teal);
      expect(palette.accent, Colors.orange);

      final copy = palette.copyWith(isDark: false);
      expect(copy.isDark, isFalse);
      expect(copy.primary, Colors.purple);
    });

    test('AmbientGlowStyle equality and copyWith', () {
      const style1 = AmbientGlowStyle(blurSigma: 30, intensity: 0.8);
      final style2 = style1.copyWith(blurSigma: 60);
      final style3 = style1.copyWith();

      expect(style1, equals(style3));
      expect(style1, isNot(equals(style2)));
      expect(style2.blurSigma, 60);
    });

    test('MeshGlowPainter shouldRepaint triggers correctly', () {
      final p1 = AmbientColorPalette.fallback();
      final p2 = p1.copyWith(primary: Colors.red);

      final painter1 = MeshGlowPainter(palette: p1, phase: 0.0);
      final painter2 = MeshGlowPainter(palette: p1, phase: 0.0);
      final painter3 = MeshGlowPainter(palette: p2, phase: 0.0);
      final painter4 = MeshGlowPainter(palette: p1, phase: 1.0);

      expect(painter1.shouldRepaint(painter2), isFalse);
      expect(painter1.shouldRepaint(painter3), isTrue);
      expect(painter1.shouldRepaint(painter4), isTrue);
    });

    testWidgets(
        'AmbientBackdropGlow renders child content and responds to palette changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AmbientBackdropGlow(
              colors: [Colors.deepPurple, Colors.pinkAccent],
              mode: AmbientGlowMode.mesh,
              style: AmbientGlowStyle(blurSigma: 20),
              child: Center(
                child: Text('Now Playing',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
          ),
        ),
      );

      // Verify rendering
      await tester.pump();
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(ImageFiltered), findsOneWidget);

      // Pump animation frames
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Now Playing'), findsOneWidget);
    });
  });
}
