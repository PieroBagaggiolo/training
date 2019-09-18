import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';

import 'package:resmedia_already_at_the_table/generated/provider.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:rxdart/rxdart.dart';

class TableEditBloc implements Bloc {
  final FormBone formBone = FormSkeleton();

  @override
  void dispose() {
    _titleControl.dispose();
    _countPersonController.dispose();
    _dateTimeFieldSkeleton.dispose();

    _bookTableController.dispose();
    _orderTableController.dispose();
  }

  final TextFieldSkeleton _titleControl = TextFieldSkeleton();
  TextFieldBone get titleFieldBone => _titleControl;

  final DateTimeFieldSkeleton _dateTimeFieldSkeleton = DateTimeFieldSkeleton(
    validator:
        DateTimeFieldValidator(getMaxDateTime: _getMaxDateTime, getMinDateTime: _getMinDateTime),
  );
  DateTimeFieldBone get dateTimeFieldBone => _dateTimeFieldSkeleton;

  final TextFieldAdapter<int> _countPersonController = TextFieldAdapter.integer();
  TextFieldBone get countPersonFieldBone => _countPersonController;

  final ButtonFieldSkeleton _bookTableController = ButtonFieldSkeleton(),
      _orderTableController = ButtonFieldSkeleton();
  ButtonFieldBone get bookTableBone => _bookTableController;
  ButtonFieldBone get orderTableFieldBone => _orderTableController;

  Future<ButtonState> _bookTable(bool isOrder) async {
    final sheet = RestaurantBloc.of().restaurant;
    final user = UserBloc.of().userBone.user;

    final res = await RestaurantDc(sheet.reference).tables().addModel(TableModel(
        idRestaurant: sheet.id,
        titleRestaurant: sheet.title,
        title: _titleControl.value,
        countChairs: _countPersonController.adapterValue,
        dateTime: _dateTimeFieldSkeleton.value,
        users: ArrayFirst([user.id])));
    _eventController.add(TableEditEvent(
      isOrder: isOrder,
      refTable: res,
    ));
    return ButtonState.disabled;
  }

  static DateTime _getMaxDateTime() => DateTime.now().add(Duration(days: 30));
  static DateTime _getMinDateTime() => DateTime.now().add(Duration(hours: 1));

  PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  TableEditBloc.instance() {
    _bookTableController.onSubmit = () async => await _bookTable(false);
    _orderTableController.onSubmit = () async => await _bookTable(true);
  }
  factory TableEditBloc.of() => $Provider.of<TableEditBloc>();
  static void close() => $Provider.dispose<TableEditBloc>();
}

class TableEditEvent {
  final bool isOrder;
  final DocumentReference refTable;

  TableEditEvent({this.isOrder, this.refTable});
}
