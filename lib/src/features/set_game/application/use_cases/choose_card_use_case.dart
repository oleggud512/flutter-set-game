import 'package:injectable/injectable.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart';


@Injectable()
class ChooseCardUseCase {
  final SetGame game;

  ChooseCardUseCase(this.game);
  
  SetCardState call(SetCard card) {
    return game.choose(card);
  }
}