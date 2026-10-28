import 'package:dartotsu/Core/Device/TvMode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dartotsu/device');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    messenger.setMockMethodCallHandler(channel, null);
    TvMode.debugIsTv = null;
  });

  test('isTv defaults to false', () {
    expect(TvMode.isTv, isFalse);
    expect(isTv, isFalse);
  });

  test('init() keeps false when the channel is missing', () async {
    await TvMode.init();
    expect(isTv, isFalse);
  });

  test('init() keeps false when the channel throws', () async {
    messenger.setMockMethodCallHandler(
      channel,
      (_) async => throw PlatformException(code: 'x'),
    );
    await TvMode.init();
    expect(isTv, isFalse);
  });

  test('init() is true when the channel returns true', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'isTv');
      return true;
    });
    await TvMode.init();
    expect(isTv, isTrue);
  });

  test('debugIsTv overrides the platform value', () {
    TvMode.debugIsTv = true;
    expect(isTv, isTrue);
    TvMode.debugIsTv = false;
    expect(isTv, isFalse);
  });
}
