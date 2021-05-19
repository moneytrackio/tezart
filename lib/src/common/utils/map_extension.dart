extension MapExtension on Map {
  /// Fetches [key] in this and throws ArgumentError if [key] is not found
  T fetch<T>(dynamic key) {
    if (this[key] == null) throw ArgumentError.value(key);

    return this[key];
  }
}
