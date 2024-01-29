enum SetGameStateState {
  /// when selected less than 3 cards
  none,

  /// when three selected cards are set
  set,

  /// when threee selected cards are not set
  noSet;

  bool get isSet => this == set;
  bool get isNotSet => this == noSet;
  bool get isNone => this == none;
}