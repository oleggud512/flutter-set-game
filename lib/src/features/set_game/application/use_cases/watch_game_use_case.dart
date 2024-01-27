import 'package:injectable/injectable.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_state.dart';


@Injectable()
class WatchGameUseCase {
  final SetGame game;

  WatchGameUseCase(this.game);
  
  Stream<SetGameState> call() {
    return game.watchGame();
  }
}