
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

  static const _cardColor = {
    SetColor.red: Colors.red,
    SetColor.green: Colors.green,
    SetColor.purple: Colors.purple
  };

  static const _flex = {
    SetNumber.one: (spacer: 3, item: 2),
    SetNumber.two: (spacer: 1, item: 1),
    SetNumber.three: (spacer: 1, item: 2),
  };

  String get shapeAssetName =>
    "assets/images/${widget.card.shape.value}-${widget.card.shade.value}.svg";

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
          Spacer(flex: _flex[widget.card.number]!.spacer),
          for (int i = 0; i < widget.card.number.value; i++) ...[
            Expanded(
              flex: _flex[widget.card.number]!.item, 
              child: buildShape(context)
            ),
            if (i < widget.card.number.value-1) w4gap, 
          ],
          Spacer(flex: _flex[widget.card.number]!.spacer)
        ]
      )
    );
  }

  Widget buildShape(BuildContext context) {
    return SvgPicture.asset(shapeAssetName,
      colorFilter: ColorFilter.mode(_cardColor[widget.card.color]!, BlendMode.srcIn),
    );
  }
}