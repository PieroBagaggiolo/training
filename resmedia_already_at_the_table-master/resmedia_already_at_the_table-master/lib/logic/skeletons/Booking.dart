import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';

class BookingBone extends Bone {
  final Stream<List<TableModel>> outAfterTables, outBeforeTables;

  BookingBone({@required this.outAfterTables, @required this.outBeforeTables});
}

class BookingSkeleton extends Skeleton implements BookingBone {
  final _pocket = Pocket();

  BookingSkeleton({@required UserModel user, RestaurantModel restaurant}) {
    _pocket.putAndGet(tablesController).pipeSource(() {
      if (restaurant != null)
        return RestaurantDc(restaurant.reference).tables().userOuter(userID: user.uid);

      return TableQr().userOuter(userID: user.uid);
    });

    outBeforeTables = outTables
        .map((tables) => tables.where((table) {
              return table.dateTime.compareTo(DateTime.now()) <= 0;
            }).toList())
        .shareValue();
    outAfterTables = outTables
        .map((tables) => tables.where((table) {
              return table.dateTime.compareTo(DateTime.now()) > 0;
            }).toList())
        .shareValue();
  }

  void dispose() {
    tablesController.close();
    super.dispose();
  }

  final BehaviorSubject<List<TableModel>> tablesController = BehaviorSubject();
  ValueObservable<List<TableModel>> get outTables => tablesController.stream;

  ValueObservable<List<TableModel>> outBeforeTables;
  ValueObservable<List<TableModel>> outAfterTables;
}
