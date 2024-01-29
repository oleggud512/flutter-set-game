import 'package:flutter/material.dart';
import 'package:set_game/src/core/common/constants/app_constants.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_set.dart';
import 'package:set_game/src/features/set_game/presentation/set_card_widget/set_card_widget_content.dart';

class HintSetWidget extends StatelessWidget {
  const HintSetWidget({
    super.key,
    required this.hint
  });

  final SetGameSet hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCard(hint.$1),
        w8gap,
        buildCard(hint.$2),
        w8gap,
        buildCard(hint.$3),
      ]
    );
  }

  Widget buildCard(SetCard card) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: AppConst.cardAspectRatio,
        child: SetCardWidgetContent(card: card, cardState: SetCardState.available
      )),
    );
  }
}