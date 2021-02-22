extension ListExtension on List {
  List<T> flatten<T>() => fold(
      [],
      (value, element) => [
            ...value,
            ...(element is List ? element.flatten() : [element]),
          ]).cast<T>();
}
