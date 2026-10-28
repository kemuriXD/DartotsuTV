import 'package:dartotsu/Core/Device/TvMode.dart';
import 'package:dartotsu/Core/Preferences/StorageManager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var requests = 0;
  var checks = 0;

  setUp(() {
    requests = 0;
    checks = 0;
    StorageManager.debugHas = () async {
      checks++;
      return false;
    };
    StorageManager.debugRequest = () async {
      requests++;
      return false;
    };
  });

  tearDown(() {
    TvMode.debugIsTv = null;
    StorageManager.debugHas = null;
    StorageManager.debugRequest = null;
  });

  test('on TV a directory lookup only checks the permission', () async {
    TvMode.debugIsTv = true;
    expect(await StorageManager.storageAccess(), isFalse);
    expect(await StorageManager.storageAccess(), isFalse);
    expect(requests, 0);
    expect(checks, 2);
  });

  test('on TV a granted permission is used', () async {
    TvMode.debugIsTv = true;
    StorageManager.debugHas = () async => true;
    expect(await StorageManager.storageAccess(), isTrue);
    expect(requests, 0);
  });

  test('off TV a directory lookup still requests', () async {
    expect(await StorageManager.storageAccess(), isFalse);
    expect(requests, 1);
    expect(checks, 0);
  });
}
