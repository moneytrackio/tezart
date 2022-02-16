import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:tezart/src/common/logger/common_logger.dart';

void main() {
  test('gets recorded to LogRecord', () {
    enableTezartLogger(level: Level.FINE);
    var records = <LogRecord>[];
    var sub = Logger.root.onRecord.listen(records.add);

    Logger.root.log(Level.INFO, 'info');
    Logger.root.log(Level.WARNING, 'warning');
    Logger.root.log(Level.SEVERE, 'severe');
    Logger.root.log(Level.SHOUT, 'default');
    sub.cancel();
    expect(records, hasLength(4));
  });
}
