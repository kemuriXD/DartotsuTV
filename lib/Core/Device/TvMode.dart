import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

bool get isTv => TvMode.isTv;

abstract final class TvMode {
  static const _channel = MethodChannel('dartotsu/device');
  static bool _isTv = false;

  static bool get isTv => _isTv;

  @visibleForTesting
  static set debugIsTv(bool? value) => _isTv = value ?? false;

  static Future<void> init() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      _isTv = await _channel.invokeMethod<bool>('isTv') ?? false;
    } catch (_) {
      _isTv = false;
    }
  }
}
