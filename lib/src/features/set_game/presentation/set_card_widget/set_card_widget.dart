import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/core/external/inject.dart';
import 'package:set_game/src/features/set_game/application/use_cases/choose_card_use_case.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';

class SetCardWidget extends StatefulWidget {
  const SetCardWidget({
    super.key,
    required this.card,
    required this.cardState,
    this.onPressed
  });

  final SetCard card;
  final SetCardState cardState;
  final VoidCallback? onPressed;

  @override
  State<SetCardWidget> createState() => _SetCardWidgetState();
}

class _SetCardWidgetState extends State<SetCardWidget> {
  Color get cardColor => switch (widget.card.color) {
    SetColor.red => Colors.red,
    SetColor.green => Colors.green,
    SetColor.purple => Colors.purple
  };

  // TODO: replace with some animation
  Color get tempStateColor => switch (widget.cardState) {
    SetCardState.available => Colors.grey.shade300,
    SetCardState.choosen => Colors.amber,
    SetCardState.correct => Colors.green,
    SetCardState.incorrect => Colors.red
  };

  String get shapeAssetName => "assets/images/${widget.card.shape.value}-${widget.card.shade.value}.svg";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        widget.onPressed?.call();
      },
      child: Container(
        color: tempStateColor,
        padding: const EdgeInsets.all(p8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            for (int i = 0; i < widget.card.number.value-1; i++) ...[
              Expanded(child: buildShape(context)),
              w4gap, 
            ],
            Expanded(child: buildShape(context)),
            Spacer()
          ]
        )
      ),
    );
  }

  Widget buildShape(BuildContext context) {
    return Container(
      // width: 20,
      // color: Colors.grey,
      child: SvgPicture.asset(shapeAssetName,
        // height: 40,
        // width: 20,
        colorFilter: ColorFilter.mode(cardColor, BlendMode.srcIn),
      ),
    );
  }
}