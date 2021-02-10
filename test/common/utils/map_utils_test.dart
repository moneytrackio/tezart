import 'package:test/test.dart';
import 'package:tezart/src/common/utils/map_utils.dart';

void main() {
  group('.fetch', () {
    final subject = (Map map, String key) => MapUtils.fetch(map: map, key: key);

    group('when the key exists', () {
      final map = {'toto': 'tata'};
      final key = 'toto';

      test('it returns the value', () {
        expect(subject(map, key), equals(map[key]));
      });
    });

    group('when the key doesnt exist', () {
      final map = {'404': 'tata'};
      final key = 'toto';

      test('it throws an error', () {
        expect(() => subject(map, key),
            throwsA(predicate((e) => e is ArgumentError && e.toString() == 'Invalid argument: "$key"')));
      });
    });
  });
}
