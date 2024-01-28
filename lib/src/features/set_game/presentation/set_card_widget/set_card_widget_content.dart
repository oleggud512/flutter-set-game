part of 'set_card_widget.dart';

class _SetCardWidgetContent extends StatefulWidget {
  const _SetCardWidgetContent({
    super.key,
    required this.card,
    required this.cardState,
  });

  final SetCard card;
  final SetCardState cardState;

  @override
  State<_SetCardWidgetContent> createState() => _SetCardWidgetContentState();
}

class _SetCardWidgetContentState extends State<_SetCardWidgetContent> {

    Color get cardColor => switch (widget.card.color) {
    SetColor.red => Colors.red,
    SetColor.green => Colors.green,
    SetColor.purple => Colors.purple
  };

  // TODO: replace with some animation
  Color get tempStateColor => switch (widget.cardState) {
    SetCardState.available || SetCardState.choosen => Theme.of(context).colorScheme.surfaceVariant,
    SetCardState.correct => Colors.green.shade300,
    SetCardState.incorrect => Colors.red.shade300
  };

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
        color: tempStateColor,
        borderRadius: BorderRadius.circular(p16),
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