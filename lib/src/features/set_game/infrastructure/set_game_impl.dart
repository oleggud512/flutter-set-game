import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:rxdart/subjects.dart';
import 'package:set_game/src/core/external/combinations.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_card_state.dart';
import 'package:set_game/src/features/set_game/domain/entities/set_game_state_state.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_set.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game_state.dart';

part "set_game_state_impl.dart";
part "set_game_set_ext.dart";


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

  void pushState() {
    final newState = createState();
    // glogger.i(newState.state);
    gameStateStream.sink.add(newState);
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

    if (selected.length < 3) {
      resultState = SetCardState.choosen;
    } else {
      final isSet = _isSet(selected.toGameSet()!);
      pushState();
      if (isSet) {
        replaceSelectedCorrectSet();
        resultState = SetCardState.correct;
      } else {
        resultState = SetCardState.incorrect;
      }
      selected.clear();
    }

    pushState();

    return resultState;
  }

  void replaceSelectedCorrectSet() {

    if (deck.isEmpty) {
      for (final card in selected) {
        table.remove(card);
      }
      return;
    }

    final updatedTable = [...table];

    var deckIndexes = <int>[];

    do {
      // generate list of unique indexes
      deckIndexes.clear();
      for (int i = 0; i < 3; i++) {
        late int nextIndex;
        do {
          nextIndex = Random().nextInt(deck.length);
        } while (deckIndexes.contains(nextIndex));
        deckIndexes.add(nextIndex);
      }
      // replace selected cards in table with random ones
      for (int i = 0; i < 3; i++) {
        final tableIndex = table.indexOf(selected[i]);
        updatedTable[tableIndex] = deck[deckIndexes[i]];
      }
    } while (_getSets(updatedTable).isEmpty);
    
    // remove taken cards from the deck
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

  @override
  Stream<SetGameState> watchGame() {
    return gameStateStream.stream;
  }

  @override
  SetGameState getGame() {
    return createState();
  }

  SetGameStateImpl createState() {
    return SetGameStateImpl(
      table: table, 
      deckCount: deck.length, 
      selected: [...selected]
    );
  }

}