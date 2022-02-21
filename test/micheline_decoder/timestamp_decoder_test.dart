// ignore_for_file: prefer_function_declarations_over_variables

import 'package:test/test.dart';
import 'package:tezart/src/micheline_decoder/micheline_decoder.dart';

void main() {
  final subject = (Map<String, dynamic> type, dynamic data) => MichelineDecoder(type: type, data: data).decode();
  final type = {'prim': 'timestamp'};

  void _itDecodesDataCorrectly(data) {
    test('it decodes data correctly', () {
      final expectedResult = DateTime.fromMillisecondsSinceEpoch(1614620399 * 1000).toUtc();

      expect(subject(type, data).toUtc(), expectedResult);
    });
  }

  group('when the data is an int', () {
    final data = {'int': 1614620399};

    _itDecodesDataCorrectly(data);
  });

  group('when the data is a timestamp as a string', () {
    final data = {'int': '1614620399'};

    _itDecodesDataCorrectly(data);
  });

  group('when the data is a string date', () {
    final data = {'string': '2021-03-01 17:39:59.000Z'};

    _itDecodesDataCorrectly(data);
  });
}
