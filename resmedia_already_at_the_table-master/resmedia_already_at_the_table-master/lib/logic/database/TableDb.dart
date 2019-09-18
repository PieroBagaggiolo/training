import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_already_at_the_table/logic/Collections.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';


mixin TableDb implements FirebaseDatabase {
  TablesCollection get tables;

  ChairsCollection get chairs => tables.$chairs;

  Future<DocumentReference> createTable(TableModel model) async {
    return await tables.col(fs).add(model.toJson());
  }

  Stream<List<TableModel>> getTables(String uid) {
    return tables.col(fs).where(tables.users+'.'+uid, isEqualTo: true)
        .snapshots().map((querySnap) {
      return fromQuerySnaps(querySnap, TableModel.fromFirebase);
    });
  }

  Stream<TableModel> getTable(String path) {
    return fs.document(path).snapshots().map(TableModel.fromFirebase);
  }

  Stream<List<ChairModel>> getChairs(String tablePath) {
    return fs.document(tablePath).collection(chairs.id)
        .snapshots().map((querySnap) => fromQuerySnaps(querySnap, ChairModel.fromFirebase));
  }

  Stream<ChairModel> getChair(String tableId, String chairId) {
    return fs.collection(tables.id).document(tableId)
        .collection(chairs.id).document(chairId)
        .snapshots().map(ChairModel.fromFirebase);
  }

  Future<void> updateChairProducts(ChairModel model, Map<String, dynamic> map) {
    return fs.document(model.path).updateData({'${chairs.products}.${map.keys.first}': map.values.first});
  }

  CollectionReference $tables() => fs.collection(tables.id);
  DocumentReference $table([String tableId]) => $tables().document(tableId);
  CollectionReference $chairs(String tableId) => $table(tableId).collection(chairs.id);
  DocumentReference $chair(String tableId, [String chairId]) => $chairs(tableId).document(chairId);
}