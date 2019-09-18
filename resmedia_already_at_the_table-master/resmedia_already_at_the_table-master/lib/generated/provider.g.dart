// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case DrinkBloc:
        {
          return BlocCache.getBlocInstance(
              "DrinkBloc", () => DrinkBloc.instance());
        }
      case TableEditBloc:
        {
          return BlocCache.getBlocInstance(
              "TableEditBloc", () => TableEditBloc.instance());
        }
      case InviterBloc:
        {
          return BlocCache.getBlocInstance(
              "InviterBloc", () => InviterBloc.instance());
        }
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case DrinkBloc:
        {
          BlocCache.dispose("DrinkBloc");
          break;
        }
      case TableEditBloc:
        {
          BlocCache.dispose("TableEditBloc");
          break;
        }
      case InviterBloc:
        {
          BlocCache.dispose("InviterBloc");
          break;
        }
    }
  }
}
