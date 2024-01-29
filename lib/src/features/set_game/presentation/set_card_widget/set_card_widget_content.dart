
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:set_game/src/core/common/constants/app_constants.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';

class SetCardWidgetContent extends StatefulWidget {
  const SetCardWidgetContent({
    super.key,
    required this.card,
    required this.cardState,
  });

  final SetCard card;
  final SetCardState cardState;

  @override
  State<SetCardWidgetContent> createState() => _SetCardWidgetContentState();
}

class _SetCardWidgetContentState extends State<SetCardWidgetContent> {

    Color get cardColor => switch (widget.card.color) {
    SetColor.red => Colors.red,
    SetColor.green => Colors.green,
    SetColor.purple => Colors.purple
  };

  // TODO: replace with some animation
  // Color get tempStateColor => switch (widget.cardState) {
  //   SetCardState.available || SetCardState.choosen => Theme.of(context).colorScheme.surfaceVariant,
  //   SetCardState.correct => Colors.green.shade100,
  //   SetCardState.incorrect => Theme.of(context).colorScheme.surfaceVariant
  // };

  String get shapeAssetName => "assets/images/${widget.card.shape.value}-${widget.card.shade.value}.svg";

  int get spacerFlex => switch (widget.card.number.value) {
    1 => 3,
    2 => 1,
    3 => 1,
    _ => 1
  };
  
  int get itemFlex => switch (widget.card.number.value) {
    1 => 2,
    2 => 1,
    3 => 2,
    _ => 1,
  };


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(p8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: AppConst.cardBorderRadius,
        border: Border.all(color: Theme.of(context).colorScheme.surfaceTint)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: spacerFlex),
          for (int i = 0; i < widget.card.number.value; i++) ...[
            Expanded(flex: itemFlex, child: buildShape(context)),
            if (i < widget.card.number.value-1) w4gap, 
          ],
          Spacer(flex: spacerFlex)
        ]
      )
    );
  }

  Widget buildShape(BuildContext context) {
    return SvgPicture.asset(shapeAssetName,
      colorFilter: ColorFilter.mode(cardColor, BlendMode.srcIn),
    );
  }
}