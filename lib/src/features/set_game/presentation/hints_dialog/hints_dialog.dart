import 'package:flutter/material.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/core/common/presentation/dialog_widget.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_set.dart';
import 'package:set_game/src/features/set_game/presentation/hint_set_widget/hint_set_widget.dart';

class HintsDialog extends StatelessWidget with DialogWidget<void> {
  const HintsDialog({super.key, required this.hints});

  final List<SetGameSet> hints;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 500,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(p32),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: Column(
                children: [
                  for (int i = 0; i < hints.length; i++) ...[
                    HintSetWidget(hint: hints[i]),
                    if (i != hints.length-1) const Divider()
                  ]
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}