import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_set.dart';

abstract interface class SetGameState {
  List<SetCard> get table;
  List<SetGameSet> get hints;
  int get deckCount;
  SetCardState getCardState(SetCard card);
}