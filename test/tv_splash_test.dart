import 'package:dartotsu/Screen/Splash/SplashApp.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Size logoSize(WidgetTester tester) =>
      tester.getSize(find.byKey(SplashApp.logoKey));

  double logoOpacity(WidgetTester tester) => tester
      .widget<Opacity>(
        find.ancestor(
          of: find.byKey(SplashApp.logoKey),
          matching: find.byType(Opacity),
        ),
      )
      .opacity;

  double logoScale(WidgetTester tester) => tester
      .widget<Transform>(
        find.byWidgetPredicate((w) => w is Transform && w.child is ClipOval),
      )
      .transform
      .storage[0];

  testWidgets('matchNative starts at the native logo size, fully visible', (
    tester,
  ) async {
    await tester.pumpWidget(const SplashApp(matchNative: true));
    expect(logoSize(tester), const Size(192, 192));
    expect(logoOpacity(tester), 1);
    expect(logoScale(tester), closeTo(1, 0.001));
  });

  testWidgets('a pre-decoded logo is painted on the first frame', (
    tester,
  ) async {
    final logo = (await tester.runAsync(
      () => createTestImage(width: 576, height: 576),
    ))!;
    await tester.pumpWidget(SplashApp(matchNative: true, logo: logo));
    final raw = tester.widget<RawImage>(find.byKey(SplashApp.logoKey));
    expect(raw.image, same(logo));
    expect(logoSize(tester), const Size(192, 192));
  });

  testWidgets('shows the startup status under the bar', (tester) async {
    await tester.pumpWidget(
      const SplashApp(matchNative: true, status: 'Still starting… bridge'),
    );
    expect(find.text('Still starting… bridge'), findsOneWidget);
    expect(logoSize(tester), const Size(192, 192));
  });

  testWidgets('default splash keeps its entrance', (tester) async {
    await tester.pumpWidget(const SplashApp());
    expect(logoSize(tester), const Size(144, 144));
    expect(logoOpacity(tester), 0);
    expect(logoScale(tester), closeTo(0.8, 0.001));
    await tester.pump(const Duration(milliseconds: 700));
    expect(logoOpacity(tester), 1);
  });
}
