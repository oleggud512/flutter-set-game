// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:set_game/src/features/set_game/application/use_cases/watch_game_use_case.dart'
    as _i4;
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart'
    as _i3;
import 'package:set_game/src/get_it.dart' as _i5;

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
    gh.factory<_i4.WatchGameUseCase>(
        () => _i4.WatchGameUseCase(gh<_i3.SetGame>()));
    return this;
  }
}

class _$RegisterModule extends _i5.RegisterModule {}
