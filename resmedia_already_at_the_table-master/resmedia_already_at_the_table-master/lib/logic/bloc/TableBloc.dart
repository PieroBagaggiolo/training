import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:meta/meta.dart';

import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Functions.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/Menu.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';
import 'package:resmedia_already_at_the_table/model/dynamicLink/InvitationUriData.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:rxdart/rxdart.dart';

class TableBloc extends BlocEvent {
  final UserBloc _userBloc = UserBloc.of();

  final Pocket _pocket = Pocket();

  @protected
  @override
  void dispose() {
    _tableController.close();
    _chairsController.close();
    _foodsSkeleton.dispose();
    _drinksSkeleton.dispose();
    super.dispose();
  }

  final BehaviorSubject<TableModel> _tableController = BehaviorSubject();
  Stream<TableModel> get outTable => _tableController;

  BehaviorSubject<List<ChairModel>> _chairsController = BehaviorSubject();
  Stream<List<ChairModel>> get outChairs => _chairsController.stream;

  Observable<ChairModel> get outMyChair {
    return Observable.combineLatest2<UserModel, List<ChairModel>, ChairModel>(
        _userBloc.userBone.outUser, outChairs, (user, chairs) {
      return chairs.firstWhere((sheet) => sheet.user == user.uid, orElse: () => null);
    });
  }

  Observable<List<ChairModel>> get outOthersChairs {
    return Observable.combineLatest2<UserModel, List<ChairModel>, List<ChairModel>>(
        _userBloc.userBone.outUser, outChairs, (user, chairs) {
      return chairs.where((sheet) => sheet.user != user.uid).toList();
    });
  }

  Future<void> acceptInvite(ChairModel model) async {
    return await FbCloudFunctions().responseInvite(model, true);
  }

  Future<void> cancelInvite(ChairModel model) async {
    return await FbCloudFunctions().responseInvite(model, false);
  }

  final responseInvite = FbCloudFunctions().responseInvite;

  FoodMenuSkeleton _foodsSkeleton = FoodMenuSkeleton();
  MenuBone<FoodCategory> get foodBone => _foodsSkeleton;

  DrinkMenuSkeleton _drinksSkeleton = DrinkMenuSkeleton();
  MenuBone get drinkBone => _drinksSkeleton;

//  Future<int> inviteByPhoneNumber(int phoneNumber) async {
//    return await FunctionsFb().inviteToTable(await ,
//      phoneNumber: phoneNumber,
//    );
//  }

  TableModel get value => _tableController.value;

  Future<SendInvitationEvent> shareInvite() async {
    final table = _tableController.value;
    final link = InvitationData(
      restaurantId: table.idRestaurant,
      tableId: table.id,
    ).toUri();

    final deepLinkParam = DynamicLinkParameters(
      uriPrefix: "https://giaatavola.it/",
      link: link,
      androidParameters: AndroidParameters(
        packageName: "it.resmedia.alreadyAtTheTable.client",
      ),
      iosParameters: IosParameters(
        bundleId: "it.resmedia.gia-a-tavola",
      ),
    );
    return SendInvitationEvent(
      titleRestaurant: table.titleRestaurant.text,
      titleTable: table.title,
      url: (await deepLinkParam.buildShortLink()).shortUrl.toString(),
    );
  }

  TableBloc(TableModel initialValue) {
    _pocket.putAndGet(_tableController).pipeSource(() {
      return TableDc(initialValue.reference).outer();
    });

    final outRestaurantDc = outTable.distinct((bef, aft) {
      return aft == null || bef?.idRestaurant == aft?.idRestaurant;
    }).map((table) {
      return RestaurantCl().document(table.idRestaurant);
    });

    _pocket
        .putAndGet(_chairsController)
        .pipeSource(() => TableDc(initialValue.reference).chairs().nominativeOuter());

    _foodsSkeleton.pocket.pipeSource(() => outRestaurantDc.asyncExpand((restaurantDc) {
          return restaurantDc.foods().outer();
        }));

    _drinksSkeleton.pocket.pipeSource(() => outRestaurantDc.asyncExpand((restaurantDc) {
          return restaurantDc.drinks().outer();
        }));
  }
  factory TableBloc.from({@required InvitationData invitation}) {
    final tableBloc = TableBloc(TableModel(
      reference: RestaurantCl()
          .document(invitation.restaurantId)
          .tables()
          .document(invitation.tableId)
          .reference,
    ));
    tableBloc.outTable.first.then((table) {
      tableBloc.addEvent(JoinInTheTableEvent(
        titleRestaurant: table.titleRestaurant.text,
        titleTable: table.title,
      ));
    });

    return tableBloc;
  }
  factory TableBloc.init(TableBloc bloc) => BlocProvider.init(bloc);
  factory TableBloc.of() => BlocProvider.of<TableBloc>();
  static void close() => BlocProvider.dispose<TableBloc>();
}

class SendInvitationEvent {
  final String titleRestaurant;
  final String titleTable;
  final String url;

  SendInvitationEvent({
    @required this.titleRestaurant,
    @required this.titleTable,
    @required this.url,
  });
}

class JoinInTheTableEvent {
  final String titleRestaurant;
  final String titleTable;

  JoinInTheTableEvent({@required this.titleRestaurant, @required this.titleTable});
}
