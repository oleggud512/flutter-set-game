// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:set_game/src/features/set_game/application/use_cases/choose_card_use_case.dart'
    as _i6;
import 'package:set_game/src/features/set_game/application/use_cases/get_game_use_case.dart'
    as _i7;
import 'package:set_game/src/features/set_game/application/use_cases/reset_game_use_case.dart'
    as _i8;
import 'package:set_game/src/features/set_game/application/use_cases/watch_game_use_case.dart'
    as _i5;
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart'
    as _i3;
import 'package:set_game/src/features/set_game/presentation/set_game_bloc.dart'
    as _i9;
import 'package:set_game/src/features/set_game/presentation/set_game_page_bloc.dart'
    as _i4;
import 'package:set_game/src/get_it.dart' as _i10;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.SetGame>(registerModule.game);
    gh.factory<_i4.SetGamePageBloc>(() => _i4.SetGamePageBloc());
    gh.factory<_i5.WatchGameUseCase>(
        () => _i5.WatchGameUseCase(gh<_i3.SetGame>()));
    gh.factory<_i6.ChooseCardUseCase>(
        () => _i6.ChooseCardUseCase(gh<_i3.SetGame>()));
    gh.factory<_i7.GetGameUseCase>(() => _i7.GetGameUseCase(gh<_i3.SetGame>()));
    gh.factory<_i8.ResetGameUseCase>(
        () => _i8.ResetGameUseCase(gh<_i3.SetGame>()));
    gh.factory<_i9.SetGameBloc>(() => _i9.SetGameBloc(
          gh<_i5.WatchGameUseCase>(),
          gh<_i6.ChooseCardUseCase>(),
          gh<_i8.ResetGameUseCase>(),
          gh<_i7.GetGameUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i10.RegisterModule {}
