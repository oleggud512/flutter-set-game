import 'package:set_game/src/core/common/value_enum.dart';

enum SetNumber implements ValueEnum<int> {
  one(1), 
  two(2),
  three(3);

  @override
  final int value;

  const SetNumber(this.value);
}