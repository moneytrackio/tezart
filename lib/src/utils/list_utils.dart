class ListUtils {
  static List flatten<T>(List arr) => arr.fold(
      [],
      (value, element) => [
            ...value,
            ...(element is List ? flatten(element) : [element])
          ]).cast<T>();
}
