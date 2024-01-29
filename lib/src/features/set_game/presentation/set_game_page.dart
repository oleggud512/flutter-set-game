import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:set_game/src/core/common/constants/app_constants.dart';
import 'package:set_game/src/core/common/constants/sizes.dart';
import 'package:set_game/src/core/common/extensions/build_context.dart';
import 'package:set_game/src/core/common/extensions/string.dart';
import 'package:set_game/src/core/common/logger.dart';
import 'package:set_game/src/core/external/inject.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_state.dart';
import 'package:set_game/src/features/set_game/presentation/hint_set_widget/hint_set_widget.dart';
import 'package:set_game/src/features/set_game/presentation/hints_dialog/hints_dialog.dart';
import 'package:set_game/src/features/set_game/presentation/set_card_widget/set_card_widget.dart';
import 'package:set_game/src/features/set_game/presentation/set_game_bloc.dart';
import 'package:set_game/src/features/set_game/presentation/set_game_page_bloc.dart';

class SetGamePage extends StatefulWidget {
  const SetGamePage({super.key});

  @override
  State<SetGamePage> createState() => _SetGamePageState();
}

class _SetGamePageState extends State<SetGamePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => locate<SetGameBloc>()
            ..add(SetGameWatchEvent()),
        ),
        BlocProvider(
          create: (_) => locate<SetGamePageBloc>()
        ),
      ],
      child: BlocBuilder<SetGameBloc, SetGameState>(
        builder: (context, gameState) {
          return BlocBuilder<SetGamePageBloc, SetGamePageState>(
            builder: (context, pageState) {
              return _SetGamePageContent(
                gameState: gameState,
                pageState: pageState,
              );
            }
          );
        }
      )
    );
  }
}

class _SetGamePageContent extends StatelessWidget {
  _SetGamePageContent({
    // super.key,
    required this.gameState, 
    required this.pageState,
  });

  final SetGameState gameState;
  final SetGamePageState pageState;

  final isShowHint = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    glogger.w(gameState.state);
    final hints = gameState.hints;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {

                },
                child: const Text("Theme"),
              )
            ]
          )
        ],
        title: Text("SET".hardcoded),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: Center(child: buildGame(context))),

          if (hints.isNotEmpty && pageState.isShowHint) Container(
            padding: const EdgeInsets.only(bottom: p8),
            width: p304, 
            child: HintSetWidget(hint: hints[0])
          )
          else const SizedBox.shrink()
        ],
      ),
    
      bottomNavigationBar: buildBottomBar(context)
    );
  }

  Widget buildGame(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 730,
          ),
          child: GridView.count(
            padding: const EdgeInsets.all(p16),
            shrinkWrap: true,
            crossAxisCount: context.isMobile ? 3 : 6,
            mainAxisSpacing: p16,
            crossAxisSpacing: p16,
            childAspectRatio: AppConst.cardAspectRatio,
            children: gameState.table.map((card) => SetCardWidget(
              key: ValueKey(card),
              card: card,
              cardState: gameState.getCardState(card),
              onPressed: () {
                context.read<SetGameBloc>().add(SetGameChooseCardEvent(card));
              }
            )).toList()
          ),
        );
      }
    );
  }

  BottomAppBar buildBottomBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              context.read<SetGameBloc>().add(SetGameResetEvent());
            },
            child: Text("NEW GAME".hardcoded)
          ),
          TextButton(
            onPressed: () {
              HintsDialog(
                hints: gameState.hints,
                isShowHint: pageState.isShowHint,
                onIsShowHintChanged: (newV) {
                  context.read<SetGamePageBloc>()
                    .add(SetGamePageToggleHintEvent());
                },
              ).show(context);
            },
            child: Text("SHOW HINTS".hardcoded)
          ),
          const Spacer(),
          Text(gameState.deckCount.toString(), 
            style: Theme.of(context).textTheme
              .labelLarge
              ?.copyWith(
                color: Theme.of(context).colorScheme.primary
              )
          ),
        ]
      )
    );
  }
}