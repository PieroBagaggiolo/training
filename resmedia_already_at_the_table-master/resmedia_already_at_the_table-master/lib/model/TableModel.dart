import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:json_annotation/json_annotation.dart';


part 'TableModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class TableModel extends FirebaseModel {
  final String idRestaurant;
  final Translations titleRestaurant;
  final String title;
  final int countChairs;
  final DateTime dateTime;
  final List<String> users;
  final int total;

  TableModel({
    DocumentReference reference,
    this.total,
    this.title,
    this.dateTime,
    this.countChairs,
    this.users,
    this.idRestaurant,
    this.titleRestaurant,
  }) : super(reference);

  static TableModel fromJson(Map json) => _$TableModelFromJson(json);
  static TableModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$TableModelToJson(this);
}


enum MenuStatus {
  OPEN, CLOSED, ORDERED,
}



@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class PartialChairModel extends PartialDocumentModel {
  final String nominative;
  final MenuStatus state;

  PartialChairModel({String id, this.nominative, this.state,}) : super(id);

  static PartialChairModel fromJson(Map json) => _$PartialChairModelFromJson(json);
  Map<String, dynamic> toJson() => _$PartialChairModelToJson(this);
}


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ChairModel extends FirebaseModel {
  final bool isFree;
  final MenuStatus menuState;
  final String user;
  final String nominative;
  final ProductsModel products;

  ChairModel({DocumentReference reference,
    this.isFree, this.menuState, this.products,
    this.user, this.nominative,
  }) : super(reference);

  ChairModel.free() : this(
    isFree: true,
    products: ProductsModel.init()
  );

  ChairModel.join() : this(
    products: ProductsModel.init(),
  );

  static ChairModel fromJson(Map json) => _$ChairModelFromJson(json);
  static ChairModel fromFirebase(DocumentSnapshot snap) =>
    FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ChairModelToJson(this);
}


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ProductsModel extends JsonRule {
  final ArrayDocObj<ProductCartFirebase> foods, drinks;

  ProductsModel({
    this.foods, this.drinks,
  }) : super();

  ProductsModel.init() : this(foods: ArrayDocObj([]), drinks: ArrayDocObj([]));

  static ProductsModel fromJson(Map json) {
    print(json);
    return _$ProductsModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ProductsModelToJson(this);
}

