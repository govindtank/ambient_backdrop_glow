import 'package:flutter_test/flutter_test.dart';
import 'package:ambient_backdrop_glow_example/main.dart';

void main() {
  testWidgets('AmbientBackdropGlow Example app smoke test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AmbientGlowDemoApp());
    await tester.pump();

    expect(find.text('ambient_backdrop_glow'), findsOneWidget);
    expect(find.text('Midnight Horizon'), findsOneWidget);
  });
}
