import 'package:equatable/equatable.dart';
import 'package:set_game/src/core/common/value_enum.dart';

enum SetNumber implements ValueEnum<int> {
  one(1), 
  two(2),
  three(3);

  @override
  final int value;

  const SetNumber(this.value);
}

enum SetShape implements ValueEnum<String> {
  diamond("diamond"),
  squiggle("squiggle"),
  oval("oval");

  @override
  final String value;

  const SetShape(this.value);
}

enum SetShade implements ValueEnum<String> {
  open("open"),
  stiped("striped"),
  solid("solid");

  @override
  final String value;

  const SetShade(this.value);
}

enum SetColor implements ValueEnum<String> {
  red("red"),
  green("green"),
  purple("purple");

  @override
  final String value;

  const SetColor(this.value);
}

class SetCard extends Equatable {
  final SetNumber number;
  final SetShape shape;
  final SetShade shade;
  final SetColor color;

  const SetCard({
    required this.number, 
    required this.shape, 
    required this.shade, 
    required this.color
  });

  @override
  List<Object?> get props => [number, shape, shade, color];
}