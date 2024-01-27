import 'package:injectable/injectable.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart';


@Injectable()
class ResetGameUseCase {
  final SetGame game;

  ResetGameUseCase(this.game);
  
  void call() {
    game.reset();
  }
}