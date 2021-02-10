import 'package:meta/meta.dart';

class MapUtils {
  static T fetch<T>({@required Map<dynamic, T> map, @required dynamic key}) {
    if (map[key] == null) throw ArgumentError.value(key);

    return map[key];
  }
}
