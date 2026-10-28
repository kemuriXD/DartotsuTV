enum WatchdogAction { none, stillStarting, failure }

const _patience = Duration(seconds: 20);
const _tvPatience = Duration(seconds: 60);

WatchdogAction watchdogAction(Duration elapsed, {required bool tv}) {
  if (elapsed < _patience) return WatchdogAction.none;
  if (!tv || elapsed >= _tvPatience) return WatchdogAction.failure;
  return WatchdogAction.stillStarting;
}
