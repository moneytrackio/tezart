extension ListExtension on List {
  List<T> flatten<T>() => fold(
      [],
      (List<dynamic> value, dynamic element) => [
            ...value,
            ...(element is List ? element.flatten() : [element]),
          ]).cast<T>();
}
