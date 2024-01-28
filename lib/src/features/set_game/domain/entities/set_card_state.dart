enum SetCardState {
  available,
  choosen,
  correct,
  incorrect;

  bool get isNotAvailable => this != available;
}