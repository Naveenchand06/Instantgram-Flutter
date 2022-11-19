extension RemoveAll on String {
  String removeAll(Iterable<String> values) => values.fold(
        this,
        (result, pattern) => result.replaceAll(pattern, ''),
      );
}
