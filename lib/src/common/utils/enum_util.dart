/// Utils related to enums
class EnumUtil {
  /// Searches [stringType] in [values] and converts it to [T]
  ///
  /// if [stringType] doesn't exist a StateError is thrown
  static T? stringToEnum<T>(Iterable<T> values, String stringType) {
    return values.firstWhere(
      (f) => f.toString().substring(f.toString().indexOf('.') + 1).toString() == stringType,
    );
  }

  /// Converts [enumValue] to its string representation
  static String enumToString<T>(T enumValue) => enumValue.toString().split('.').last;
}
