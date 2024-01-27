import 'package:trotter/trotter.dart';

List<List<T>> combinations<T>(List<T> items, int combCount) {
  final comb = Combinations(combCount, items)();
  return List.from(comb);
}