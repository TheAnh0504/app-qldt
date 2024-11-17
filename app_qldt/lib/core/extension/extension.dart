import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// thêm khả năng cache cho AutoDisposeRef. Mục tiêu của cacheFor là giữ cho một provider
// không bị huỷ trong một khoảng thời gian nhất định sau khi không còn được sử dụng.
extension AutoDisposeProviderRefExtension on AutoDisposeRef {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    Timer? timer;
    onCancel(() => timer = Timer(duration, () => link.close()));
    onResume(() => timer?.cancel());
    onDispose(() => timer?.cancel());
  }
}
// chuyển đổi names = ['Alice', 'Bob', 'Charlie'] --> ["0: Alice", "1: Bob", "2: Charlie"]
// result = names.mapIndexed((index, name) => '$index: $name').toList();
extension IterableUtils<T> on Iterable<T> {
  Iterable<M> mapIndexed<M>(M Function(int index, T) transformer) sync* {
    for (int i = 0; i < length; i++) {
      yield transformer(i, elementAt(i));
    }
  }
}
