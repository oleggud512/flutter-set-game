import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_state.dart';

abstract interface class SetGame { 
  Stream<SetGameState> watchGame();
  void choose(SetCard card);
}