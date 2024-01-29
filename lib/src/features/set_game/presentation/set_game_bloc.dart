import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:set_game/src/core/common/constants/app_constants.dart';
import 'package:set_game/src/features/set_game/application/use_cases/choose_card_use_case.dart';
import 'package:set_game/src/features/set_game/application/use_cases/get_game_use_case.dart';
import 'package:set_game/src/features/set_game/application/use_cases/reset_game_use_case.dart';
import 'package:set_game/src/features/set_game/application/use_cases/watch_game_use_case.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_game_state_state.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_state.dart';
import 'package:set_game/src/features/set_game/infrastructure/set_game_impl.dart';

sealed class SetGameEvent extends Equatable {}

final class SetGameChooseCardEvent extends SetGameEvent {
  final SetCard card;
  SetGameChooseCardEvent(this.card);

  @override
  List<Object?> get props => [card];
}

final class SetGameWatchEvent extends SetGameEvent {
  @override
  List<Object?> get props => [];
}

final class SetGameResetEvent extends SetGameEvent {
  @override
  List<Object?> get props => [];
}

@Injectable()
class SetGameBloc extends Bloc<SetGameEvent, SetGameState> {
  final WatchGameUseCase watchGame;
  final ChooseCardUseCase chooseCard;
  final ResetGameUseCase resetGame;

  SetGameStateState? prev;

  Stream<SetGameState> watchDelayedGame() async* {
    await for (final gameState in watchGame()) {
      if (prev?.isSet == true && gameState.state.isNone) {
        await Future.delayed(AppConst.correctSetAnimationDuration);
      } else if (prev?.isNotSet == true && gameState.state.isNone) {
        await Future.delayed(AppConst.incorrectSetAnimationDuration);
      } else if (!gameState.state.isNone) {
        await Future.delayed(AppConst.elevateCardAnimatinoDuration);
      }
      prev = gameState.state;
      yield gameState;
    }
  }

  SetGameBloc(
    this.watchGame, 
    this.chooseCard, 
    this.resetGame,
    GetGameUseCase getGame
  ) : super(getGame()) {

    on<SetGameWatchEvent>((event, emit) async {
      await emit.forEach(watchDelayedGame(), onData: (state) => state);
    });

    on<SetGameChooseCardEvent>((event, emit) async {
      chooseCard(event.card);
    });

    on<SetGameResetEvent>((event, emit) {
      resetGame();
    });
  }


}