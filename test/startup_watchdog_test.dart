import 'package:dartotsu/Core/Startup/StartupWatchdog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WatchdogAction at(int s, {required bool tv}) =>
      watchdogAction(Duration(seconds: s), tv: tv);

  test('phone fails at 20 s as before', () {
    expect(at(0, tv: false), WatchdogAction.none);
    expect(at(19, tv: false), WatchdogAction.none);
    expect(at(20, tv: false), WatchdogAction.failure);
  });

  test('TV says it is still starting until 60 s', () {
    expect(at(19, tv: true), WatchdogAction.none);
    expect(at(20, tv: true), WatchdogAction.stillStarting);
    expect(at(59, tv: true), WatchdogAction.stillStarting);
    expect(at(60, tv: true), WatchdogAction.failure);
  });
}
