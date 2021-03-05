import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';

final _green = AnsiPen()..green();
final _cyan = AnsiPen()..cyan();
final _yellow = AnsiPen()..yellow();
final _red = AnsiPen()..red();

///
/// the AnsiPen color xterm
/// So the trick here is to switch/case and color while printing
///
void _printOutput({
  DateTime time,
  String level,
  String name,
  String message,
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
  print('${time}[${levelColored}] - ${name} : ${message}');
}

/// Enables the logs to be displayed in the console.
void enableTezartLogger() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    _printOutput(
      time: record.time,
      name: record.loggerName,
      level: record.level.name,
      message: record.message,
    );
  });
}
