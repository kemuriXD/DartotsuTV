import 'package:dartotsu/Screen/Onboarding/OnboardingState.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  const phone = [
    Permission.notification,
    Permission.manageExternalStorage,
    Permission.requestInstallPackages,
    Permission.ignoreBatteryOptimizations,
  ];

  test('Fire OS (Android 9) asks for plain storage, no battery row', () {
    final list = onboardingPermissions(tv: true, sdkInt: 28);
    expect(list, isNot(contains(Permission.ignoreBatteryOptimizations)));
    expect(list, isNot(contains(Permission.manageExternalStorage)));
    expect(list, contains(Permission.storage));
  });

  test('Android 11+ TV keeps all files access, no battery row', () {
    final list = onboardingPermissions(tv: true, sdkInt: 34);
    expect(list, contains(Permission.manageExternalStorage));
    expect(list, isNot(contains(Permission.storage)));
    expect(list, isNot(contains(Permission.ignoreBatteryOptimizations)));
  });

  test('phones keep today\'s list on every version', () {
    expect(onboardingPermissions(tv: false, sdkInt: 28), phone);
    expect(onboardingPermissions(tv: false, sdkInt: 34), phone);
  });
}
