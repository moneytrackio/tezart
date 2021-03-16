import 'dart:io' show File;
import 'dart:convert';

void main() async {
  final jsonContent = await File('pana_output.json').readAsString();
  final decoded = json.decode(jsonContent);
  print(decoded['scores']['grantedPoints']);
}
