import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class SetGamePageState extends Equatable {
  final bool isShowHint;

  const SetGamePageState({this.isShowHint = false});

  @override
  List<Object?> get props => [isShowHint];
}

sealed class SetGamePageEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SetGamePageToggleHintEvent extends SetGamePageEvent {}


@Injectable()
class SetGamePageBloc extends Bloc<SetGamePageEvent, SetGamePageState> {
  SetGamePageBloc() : super(const SetGamePageState()) {

    on<SetGamePageToggleHintEvent>((event, emit) {
      emit(SetGamePageState(
        isShowHint: !state.isShowHint
      ));
    });
    
  }
}