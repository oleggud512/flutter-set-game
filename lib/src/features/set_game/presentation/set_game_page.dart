import 'package:flutter/material.dart';
import 'package:set_game/src/core/common/constants/app_constants.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/core/common/extensions/string.dart';
import 'package:set_game/src/core/external/inject.dart';
import 'package:set_game/src/features/set_game/application/use_cases/choose_card_use_case.dart';
import 'package:set_game/src/features/set_game/application/use_cases/reset_game_use_case.dart';
import 'package:set_game/src/features/set_game/application/use_cases/watch_game_use_case.dart';
import 'package:set_game/src/features/set_game/presentation/hint_set_widget/hint_set_widget.dart';
import 'package:set_game/src/features/set_game/presentation/hints_dialog/hints_dialog.dart';
import 'package:set_game/src/features/set_game/presentation/set_card_widget/set_card_widget.dart';

class SetGamePage extends StatefulWidget {
  const SetGamePage({super.key});

  @override
  State<SetGamePage> createState() => _SetGamePageState();
}

class _SetGamePageState extends State<SetGamePage> {

  final gameStream = inject<WatchGameUseCase>()();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: gameStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Container();
        final state = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text("SET!".hardcoded),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: p16),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      // TODO: TEMPORARY. Replace with layout builder.
                      constraints: BoxConstraints(
                        maxWidth: p408
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: p16,
                        crossAxisSpacing: p16,
                        childAspectRatio: AppConst.cardAspectRatio,
                        children: state.table.map((card) => SetCardWidget(
                          // key: ValueKey(card),
                          card: card, 
                          cardState: state.getCardState(card),
                          onPressed: () {
                            inject<ChooseCardUseCase>()(card);
                          }
                        )).toList()
                      ),
                    ),
                  ),
                ),
                const Divider(),
                state.hints.isNotEmpty ? HintSetWidget(hint: state.hints[0]) : Text("no hints."),
                const Divider(),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    inject<ResetGameUseCase>()();
                  },
                  child: Text("NEW GAME".hardcoded)
                ),
                TextButton(
                  onPressed: () {
                    HintsDialog(hints: state.hints).show(context);
                  },
                  child: Text("SHOW HINTS".hardcoded)
                ),
                const Spacer(),
                Text(state.deckCount.toString(), 
                  style: Theme.of(context).textTheme
                    .labelLarge
                    ?.copyWith(
                      color: Theme.of(context).colorScheme.primary
                    )
                ),
              ]
            )
          ),
        );
      }
    );
  }
}