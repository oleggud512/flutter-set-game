import 'dart:math';

import 'package:trotter/trotter.dart';

void main() {
  // for (final comb in Combinations(2, [1, 2, 3, 4])()) {
  //   print(comb);
  // }
  final list = <int>[];
  for (int i = 0; i < 10000; i++) {
    list.add(Random().nextInt(58));
  }
  print(list.contains(58));
}