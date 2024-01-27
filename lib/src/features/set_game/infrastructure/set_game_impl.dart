import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_set.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_state.dart';

List<SetGameSet> _getSets(List<SetCard> cards) {
  // TODO: implement _getSets
  throw UnimplementedError();
}

bool _isSet(SetGameSet set) {
  // TODO: implement _isSet
  throw UnimplementedError();
}

extension SetGameSetExt on SetGameSet {
  bool isSet() {
    return _isSet(this);
  }  
}

class SetGameStateImpl extends Equatable implements SetGameState {
  SetGameStateImpl({
    required this.table, 
    required this.deckCount,
    List<SetCard>? selected
  }) : selected = selected ?? [];

  final List<SetCard> selected;

  @override
  final List<SetCard> table;

  @override
  final int deckCount;

  @override
  SetCardState getCardState(SetCard card) {
    // TODO: implement getCardState
    throw UnimplementedError();
  }

  @override
  List<SetGameSet> get hints => _getSets(table);
  
  @override
  List<Object?> get props => [table, selected, deckCount];
}

@Singleton(as: SetGame)
class SetGameImpl implements SetGame {

  @override
  SetCardState choose(SetCard card) {
    // TODO: implement choose
    throw UnimplementedError();
  }
  
  @override
  Stream<SetGameState> watchGame() {
    // TODO: implement watchGame
    throw UnimplementedError();
  }
  
  @override
  void reset() {
    // TODO: implement reset
  }

}