import 'package:trotter/trotter.dart';

void main() {
  for (final comb in Combinations(2, [1, 2, 3, 4])()) {
    print(comb);
  }
}