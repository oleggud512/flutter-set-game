import 'package:injectable/injectable.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_state.dart';


@Injectable()
class GetGameUseCase {
  final SetGame game;

  GetGameUseCase(this.game);
  
  SetGameState call() {
    return game.getGame();
  }
}