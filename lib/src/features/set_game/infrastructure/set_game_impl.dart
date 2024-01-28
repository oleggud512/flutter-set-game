import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:rxdart/subjects.dart';
import 'package:set_game/src/core/external/combinations.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_set.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_state.dart';

List<SetGameSet> _getSets(List<SetCard> cards) {
  final allSets = combinations(cards, 3);
  final correctSets = <SetGameSet>[];
  for (final set in allSets) {
    final gameSet = set.toGameSet()!;
    if (_isSet(gameSet)) {
      correctSets.add(gameSet);
    }
  }
  return correctSets;
}

bool _isSet(SetGameSet set) {
  final cards = set.toList();
  final numbers = cards.map((card) => card.number).toSet();
  final shapes = cards.map((card) => card.shape).toSet();
  final shades = cards.map((card) => card.shade).toSet();
  final colors = cards.map((card) => card.color).toSet();
  return [numbers.length, shapes.length, shades.length, colors.length]
    .every((len) => len != 2);
}

extension SetGameSetExt on SetGameSet {
  bool isSet() {
    return _isSet(this);
  }  

  List<SetCard> toList() {
    return [$1, $2, $3];
  }
}

extension _ListToSetExt on List {
  SetGameSet? toGameSet() {
    return length == 3
      ? (this[0], this[1], this[2])
      : null;
  }
}

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

class SetGameImpl implements SetGame {
  static List<SetCard> generateDeck({ 
    bool numbers = true, 
    bool shapes = true, 
    bool shades = true, 
    bool colors = true 
  }) {
    var deck = <SetCard>[];

    for (final number in SetNumber.values) {
      for (final shape in SetShape.values) {
        for (final shade in SetShade.values) {
          for (final color in SetColor.values) {
            deck.add(SetCard(
              number: numbers ? number : SetNumber.one, 
              shape: shapes ? shape : SetShape.diamond, 
              shade: shades ? shade : SetShade.solid, 
              color: colors ? color : SetColor.purple
            ));
          }
        }
      }
    }
    
    // deck = deck.toSet().toList();

    deck.shuffle();
    return deck;
  }

  SetGameImpl() {
    reset();
  }

  @override
  void reset() {
    deck = generateDeck();
    takeTable();
    selected.clear();
    pushState();
  }

  List<SetCard> deck = [];
  List<SetCard> selected = [];
  List<SetCard> table = [];

  final gameStateStream = BehaviorSubject<SetGameState>();

  @override
  SetCardState choose(SetCard card) {
    if (selected.contains(card)) {
      selected.remove(card);
      pushState();
      // TODO: or maybe correct or incorrect?
      return SetCardState.available;
    }
    selected.add(card);

    late SetCardState resultState;

    var delay = 0;

    if (selected.length < 3) {
      resultState = SetCardState.choosen;
    } else {
      final isSet = _isSet(selected.toGameSet()!);
      pushState();
      delay = 100;
      if (isSet) {
        replaceSet();
        resultState = SetCardState.correct;
      } else {
        resultState = SetCardState.incorrect;
      }
      selected.clear();
    }

    Future.delayed(Duration(milliseconds: delay), pushState);
    // Future(pushState);

    return resultState;
  }

  void replaceSet() {

    if (deck.isEmpty) {
      for (final card in selected) {
        table.remove(card);
      }
      return;
    }

    final updatedTable = [...table];

    var deckIndexes = <int>[];

    do {
      deckIndexes.clear();
      for (int i = 0; i < 3; i++) {
        late int nextIndex;
        do {
          nextIndex = Random().nextInt(deck.length);
        } while (deckIndexes.contains(nextIndex));
        deckIndexes.add(nextIndex);
      }
      for (int i = 0; i < deckIndexes.length; i++) {
        updatedTable[i] = deck[deckIndexes[i]];
      }
    } while (_getSets(updatedTable).isEmpty);
    
    final cardsToRemove = deckIndexes.map((i) => deck[i]).toList();

    deck.removeWhere((card) => cardsToRemove.contains(card));

    table = updatedTable;
  }

  void takeTable() {
    var newTable = <SetCard>[];

    do {
      newTable.clear();
      for (int i = 0; i < 12; i++) {
        late SetCard nextCard;
        do {
          nextCard = deck[Random().nextInt(deck.length)];
        } while (newTable.contains(nextCard));
        newTable.add(nextCard);
      }
    } while (_getSets(newTable).isEmpty);
    
    for (final card in newTable) {
      deck.remove(card);
    }
    table = newTable;
  }

  void pushState() {
    gameStateStream.sink.add(SetGameStateImpl(
      table: table, 
      deckCount: deck.length, 
      selected: [...selected]
    ));
  }
  
  @override
  Stream<SetGameState> watchGame() {
    return gameStateStream.stream;
  }

}