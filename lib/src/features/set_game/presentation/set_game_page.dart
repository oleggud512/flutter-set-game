import 'package:flutter/material.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/core/common/extensions/string.dart';
import 'package:set_game/src/core/external/inject.dart';
import 'package:set_game/src/features/set_game/application/use_cases/choose_card_use_case.dart';
import 'package:set_game/src/features/set_game/application/use_cases/reset_game_use_case.dart';
import 'package:set_game/src/features/set_game/application/use_cases/watch_game_use_case.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/infrastructure/set_game_impl.dart';
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
            padding: const EdgeInsets.all(p8),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: p8,
              crossAxisSpacing: p8,
              childAspectRatio: 3/2,
              children: state.table.map((card) => SetCardWidget(
                card: card, 
                cardState: state.getCardState(card),
                onPressed: () {
                  inject<ChooseCardUseCase>()(card);
                }
              )).toList()
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
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return Dialog(
                          child: SizedBox(
                            height: 500,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(p8),
                                child: Column(
                                  children: [
                                    for (final set in state.hints) ...[
                                      Row(
                                        children: [
                                          for (final card in set.toList()) Expanded(
                                            child: SetCardWidget(
                                              card: card, 
                                              cardState: SetCardState.available
                                            ),
                                          )
                                        ]
                                      ),
                                      h16gap,
                                    ]
                                  ]
                                ),
                              ),
                            ),
                          )
                        );
                      }
                    );
                  },
                  child: Text("SHOW HINT".hardcoded)
                ),
                const Spacer(),
                Text(state.deckCount.toString(), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary))
              ]
            )
          ),
        );
      }
    );
  }
}