part of "set_game_impl.dart";


class SetGameStateImpl extends Equatable implements SetGameState {
  const SetGameStateImpl({
    required this.table, 
    required this.deckCount,
    required this.selected
  });

  final List<SetCard> selected;

  @override
  final List<SetCard> table;

  @override
  SetGameStateState get state {
    if (selected.length < 3) return SetGameStateState.none;
    if (_isSet(selected.toGameSet()!)) return SetGameStateState.set;
    return SetGameStateState.noSet;
  }

  @override
  final int deckCount;

  @override
  SetCardState getCardState(SetCard card) {
    if (!selected.contains(card)) return SetCardState.available;
    if (selected.length < 3) return SetCardState.choosen;
    if (_isSet(selected.toGameSet()!)) return SetCardState.correct;
    return SetCardState.incorrect;
  }

  @override
  List<SetGameSet> get hints => _getSets(table);
  
  @override
  List<Object?> get props => [table, selected, deckCount];
}