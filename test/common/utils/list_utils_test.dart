import 'package:test/test.dart';
import 'package:tezart/src/common/utils/list_utils.dart';

void main() {
  group('.flatten', () {
    final subject = (List arr) => ListUtils.flatten<int>(arr);

    group('when the array is already flattened', () {
      final arr = [1, 2, 3];

      test('it returns the same array', () {
        expect(subject(arr), equals(arr));
      });
    });

    group('when the array is not flattened', () {
      final arr = [
        1,
        [
          2,
          [3, 4],
          5
        ],
        [6, 7]
      ];

      test('it returns a flattened array', () {
        expect(subject(arr), equals([1, 2, 3, 4, 5, 6, 7]));
      });

      test('it casts the type', () {
        expect(subject(arr), isA<List<int>>());
      });
    });
  });
}
