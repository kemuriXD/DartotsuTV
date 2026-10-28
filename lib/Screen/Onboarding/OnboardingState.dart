import '../../Utils/Functions/NavigateToScreen.dart';
import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Core/Device/TvMode.dart';
import '../../Core/State/State.dart';
import '../../Core/ThemeManager/ThemeController.dart';
import '../../Utils/Animation/WidgetAnimations.dart';
import '../../Widgets/Components/ScreenState.dart';
import '../Login/LoginScreen.dart';

List<Permission> onboardingPermissions({
  required bool tv,
  required int sdkInt,
}) => [
  Permission.notification,
  if (!tv || sdkInt >= 30)
    Permission.manageExternalStorage
  else
    Permission.storage,
  Permission.requestInstallPackages,
  if (!tv) Permission.ignoreBatteryOptimizations,
];

class OnboardingState extends ScreenState {
  static final pageCount = Platform.isAndroid ? 5 : 4;

  final permissions = onboardingPermissions(tv: false, sdkInt: 0).liveList;

  final granted = <Permission, bool>{}.liveMap;

  @override
  void onInit() {
    super.onInit();
    if (Platform.isAndroid) refreshPermissions();
  }

  Future<void> refreshPermissions() async {
    if (isTv) {
      final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      permissions.assignAll(onboardingPermissions(tv: true, sdkInt: sdk));
    }
    for (final p in permissions) {
      granted[p] = await p.isGranted;
    }
  }

  Future<void> grant(Permission p) async {
    final status = await p.request();
    granted[p] = status.isGranted;
    if (status.isPermanentlyDenied) await openAppSettings();
  }

  ThemeController get theme => find();

  final controller = PageController();
  final page = 0.live;

  bool get isFirst => page.value == 0;
  bool get isLast => page.value == pageCount - 1;

  void next() {
    if (isLast) return finish();
    go(page.value + 1);
  }

  void back() {
    if (!isFirst) go(page.value - 1);
  }

  void go(int index) => controller.animateToPage(
    index,
    duration: animDuration(420),
    curve: Curves.easeOutCubic,
  );

  void finish() =>
      unawaited(replacePage<void, void>(context, const LoginScreen()));

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
