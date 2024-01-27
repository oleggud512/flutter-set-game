import 'package:flutter/material.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';

class SetCardWidget extends StatefulWidget {
  const SetCardWidget({
    super.key,
    required this.card,
    required this.cardState,
  });

  final SetCard card;
  final SetCardState cardState;

  @override
  State<SetCardWidget> createState() => _SetCardWidgetState();
}

class _SetCardWidgetState extends State<SetCardWidget> {
  Color get cardColor => switch (widget.card.color) {
    SetColor.red => Colors.red,
    SetColor.green => Colors.green,
    SetColor.purple => Colors.purple
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}