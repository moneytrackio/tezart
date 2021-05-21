extension ListExtension on List {
  /// Flattens this
  List<T> flatten<T>() => fold(
      [],
      (List<dynamic> value, dynamic element) => [
            ...value,
            ...(element is List ? element.flatten() : [element]),
          ]).cast<T>();
}
