import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_already_at_the_table/generated/provider.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';


class DrinkBloc implements Bloc {
  DrinkBloc.instance();

  void initPathDrink(String path) async {
    DrinkDc(Firestore.instance.document(path)).outer().listen(_drinkModelControl.add);
  }

  @protected
  dispose() {
    _drinkModelControl.close();
  }

  final CacheSubject<DrinkModel> _drinkModelControl = CacheSubject();
  CacheObservable<DrinkModel> get outDrink => _drinkModelControl.stream;

  static DrinkBloc of() => $Provider.of<DrinkBloc>();
  void close() => $Provider.dispose<DrinkBloc>();
}
