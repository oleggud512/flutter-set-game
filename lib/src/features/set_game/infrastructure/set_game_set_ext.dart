part of "set_game_impl.dart";

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