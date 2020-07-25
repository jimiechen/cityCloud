import 'dart:math';

extension IterableExtension<E> on Iterable<E> {
  bool get isNotNullAndEmpty {
    if (this == null) {
      return false;
    } else {
      return isNotEmpty;
    }
  }

  E get firstOrNull => isNotNullAndEmpty ? first : null;

  int get notNulllength => this == null ? 0 : length;

  E get randomItem {
    if (isNotNullAndEmpty) {
      if (length == 1) return last;
      return elementAt(Random().nextInt(length));
    }
    return null;
  }
}

extension MapExtension<K, V> on Map<K, V> {
  bool get isNotNullAndEmpty {
    if (this == null) {
      return false;
    } else {
      return isNotEmpty;
    }
  }

  int get notNulllength => this == null ? 0 : length;
}
