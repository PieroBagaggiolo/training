import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';


class MenuModel<C> {
  final C category;
  final List<ProductModel> products;

  MenuModel({this.category, this.products});
}

