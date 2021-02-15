class EnumUtil {
  static T stringToEnum<T>(Iterable<T> values, String stringType) {
    return values.firstWhere((f) => "${f.toString().substring(f.toString().indexOf('.') + 1)}".toString() == stringType,
        orElse: () => null);
  }

  static String enumToString<T>(T enumValue) => enumValue.toString().split('.').last;
}
