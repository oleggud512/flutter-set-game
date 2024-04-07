import 'package:flutter/material.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/core/common/extensions/string.dart';
import 'package:set_game/src/core/common/presentation/dialog_widget.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_set.dart';
import 'package:set_game/src/features/set_game/presentation/hint_set_widget/hint_set_widget.dart';

class HintsDialog extends StatefulWidget with DialogWidget<void> {
  const HintsDialog({
    super.key, 
    required this.hints, 
    required this.isShowHint, 
    required this.onIsShowHintChanged
  });

  final List<SetGameSet> hints;
  final bool isShowHint;
  final void Function(bool newV) onIsShowHintChanged;

  @override
  State<HintsDialog> createState() => _HintsDialogState();
}

class _HintsDialogState extends State<HintsDialog> {

  late bool isShowHint;

  @override
  void initState() { 
    super.initState();
    isShowHint = widget.isShowHint;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 500,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(p32),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Hints".hardcoded),
              centerTitle: true,
            ),
            body: ListView.separated(
              itemCount: widget.hints.length,
              padding: const EdgeInsets.all(p16),
              itemBuilder: (context, i) {
                return HintSetWidget(hint: widget.hints[i]);
              },
              separatorBuilder: (context, i) {
                return const Divider();
              },
            ),
            bottomNavigationBar: BottomAppBar(
              child: ListTile(
                onTap: () {
                  widget.onIsShowHintChanged(!isShowHint);
                  setState(() => isShowHint = !isShowHint);
                },
                leading: Checkbox(
                  value: isShowHint,
                  onChanged: (_) {},
                ),
                title: Text("Always display hint".hardcoded)
              )
            ),
          ),
        ),
      )
    );
  }
}