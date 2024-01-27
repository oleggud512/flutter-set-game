import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:set_game/src/features/set_game/domain/interfaces/set_game.dart';
import 'package:set_game/src/features/set_game/infrastructure/set_game_impl.dart';
import 'package:set_game/src/get_it.config.dart';

final injector = GetIt.instance;

@module
abstract class RegisterModule {

  @singleton
  SetGame get game => SetGameImpl();

}


@InjectableInit()
GetIt configureDependencies() => injector.init();