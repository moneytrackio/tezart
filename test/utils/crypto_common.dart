  import 'dart:typed_data';

final decodedAddress = Uint8List.fromList(<int>[
    133,
    150,
    69,
    73,
    131,
    91,
    131,
    238,
    27,
    209,
    60,
    160,
    78,
    103,
    17,
    231,
    140,
    79,
    21,
    176
  ]);

Uint8List fakeUint8List() {
 final values = List<int>.generate(32, (index) => index + 1);
 return Uint8List.fromList(values);
}
