import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';
import 'dart:developer';

final _green = AnsiPen()..green();
final _cyan = AnsiPen()..cyan();
final _yellow = AnsiPen()..yellow();
final _red = AnsiPen()..red();

///
/// the AnsiPen color xterm
/// So the trick here is to switch/case and color while printing
///
void _printOutput({
  required DateTime time,
  required String level,
  required String name,
  required String message,
}) {
  dynamic levelColored;
  switch (level) {
    case 'INFO':
      levelColored = _green(level);
      break;
    case 'WARNING':
      levelColored = _yellow(level);
      break;
    case 'SEVERE':
      levelColored = _red(level);
      break;
    default:
      levelColored = _cyan(level);
      break;
  }
  print('$time[$levelColored] - $name : $message');
}

/// Enables the logs to be displayed in the console.
void enableTezartLogger({Level level = Level.ALL}) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((record) {
    _printOutput(
      time: record.time,
      name: record.loggerName,
      level: record.level.name,
      message: record.message,
    );
  });
}

/// Enables the developer logs.
void enableTezartDevLogs({Level level = Level.ALL}) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((record) {
    log(record.message, level: record.level.value, time: record.time, name: record.loggerName);
  });
}
