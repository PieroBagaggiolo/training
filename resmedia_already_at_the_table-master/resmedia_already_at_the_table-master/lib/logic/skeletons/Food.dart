//import 'package:easy_firebase/easy_firebase.dart';
//import 'package:resmedia_already_at_the_table/logic/repository/RestaurantRepository.dart';
//import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
//
//
//abstract class FoodsBone extends BoneValues<FoodModel> {
//  Stream<Map<FoodCategory, List<FoodModel>>> get outCategorized;
//}
//
//class FoodsSkeleton extends SkeletonValues<FoodModel> implements FoodsBone {
//  Stream<Map<FoodCategory, List<FoodModel>>> get outCategorized => outValue.map((sheets) {
//    return categorized<FoodCategory, FoodModel>(
//        FoodCategory.values, sheets, (sheet) => sheet.category);
//  });
//}