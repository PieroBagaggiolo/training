//import 'package:easy_firebase/easy_firebase.dart';
//import 'package:resmedia_already_at_the_table/logic/repository/RestaurantRepository.dart';
//import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
//
//
//abstract class DrinksBone extends BoneValues<DrinkModel> {
//  Stream<Map<DrinkCategory, List<DrinkModel>>> get outCategorized;
//}
//
//class DrinksSkeleton extends SkeletonValues<DrinkModel> implements DrinksBone {
//  Stream<Map<DrinkCategory, List<DrinkModel>>> get outCategorized => outValue.map((sheets) {
//    return categorized<DrinkCategory, DrinkModel>(
//        DrinkCategory.values, sheets, (sheet) => sheet.category);
//  });
//}