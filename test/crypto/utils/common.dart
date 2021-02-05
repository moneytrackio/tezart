import 'dart:typed_data';

Uint8List fakeUint8List() {
  final values = List<int>.generate(32, (index) => index + 1);
  return Uint8List.fromList(values);
}
