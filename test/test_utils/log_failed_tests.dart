import 'package:logging/logging.dart';
import '../env/env.dart';
import 'package:test/test.dart';
import 'dart:async';

Level _logLevel() {
  return Level.LEVELS.firstWhere((level) => level.name == Env.logLevel, orElse: () => Level.OFF);
}

void logFailedTests() {
  Logger.root.level = _logLevel();
  StreamSubscription? subscription;

  setUp(() {
    subscription = Logger.root.onRecord.listen((record) {
      printOnFailure(record.message);
    });
  });

  tearDown(() {
    subscription?.cancel();
    subscription = null;
  });
}
