import 'package:get_it/get_it.dart';

T locate<T extends Object>() {
  return GetIt.instance.get<T>();
}