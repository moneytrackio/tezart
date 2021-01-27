import 'dart:typed_data';

import 'package:tezart/keystore.dart';

void main() {
     const secretKey =
          'edsk3RR5U7JsUJ8ctjsuymUPayxMm4LHXaB7VJSfeyMb8fAvbJUnsa';
  print(KeyStore.fromSecretKey(secretKey).edsk);
}