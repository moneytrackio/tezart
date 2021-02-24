extension MapExtension on Map {
  T fetch<T>(dynamic key) {
    if (this[key] == null) throw ArgumentError.value(key);

    return this[key];
  }
}
