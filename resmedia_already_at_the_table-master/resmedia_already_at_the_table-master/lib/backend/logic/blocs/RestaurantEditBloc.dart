import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:pocket_map/pocket_map.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/Menu.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantEditBloc extends BlocBase {
  final _pocket = Pocket();

  @override
  void dispose() {
    _restaurantController.close();
    _imageFieldSkeleton.dispose();
    _titleFieldSkeleton.dispose();
    _descriptionFieldSkeleton.dispose();
    _addressFieldSkeleton.dispose();
    _typesOfCuisineSkeleton.dispose();
    _generalInfoSkeleton.dispose();
    _dressCodeInfoSkeleton.dispose();
    _propertyParkingSkeleton.dispose();
    _dimensionParkingSkeleton.dispose();
    _countSeatsSkeleton.dispose();
    _buttonSkeleton.dispose();

    _foodMenuSkeleton.dispose();
    _foodButtonSkeleton.dispose();

    _drinkMenuSkeleton.dispose();
    _drinkButtonSkeleton.dispose();

    _eventController.close();
    super.dispose();
  }

  final FormBone formBone = FormSkeleton();

  final BehaviorSubject<RestaurantModel> _restaurantController = BehaviorSubject();
  Stream<RestaurantModel> get outRestaurant => _restaurantController;
  RestaurantModel get _restaurant => _restaurantController.value;

  final ImageFieldSkeleton _imageFieldSkeleton = ImageFieldSkeleton(maxImages: 10);
  ImageFieldBone get imageFieldBone => _imageFieldSkeleton;

  final TranslationsFieldSkeleton _titleFieldSkeleton = TranslationsFieldSkeleton();
  TranslationsFieldSkeleton get titleFieldBone => _titleFieldSkeleton;

  final TranslationsFieldSkeleton _descriptionFieldSkeleton = TranslationsFieldSkeleton();
  TranslationsFieldSkeleton get descriptionFieldBone => _descriptionFieldSkeleton;

  final PlaceFieldSkeleton _addressFieldSkeleton =
      PlaceFieldSkeleton(apiKey: RepositoryBloc.of().googleMapsApiKey);
  PlaceFieldBone get addressFieldBone => _addressFieldSkeleton;

  final ListEnumSkeleton<TypeOfCuisine> _typesOfCuisineSkeleton = ListEnumSkeleton();
  ListEnumBone<TypeOfCuisine> get typesOfCuisineBone => _typesOfCuisineSkeleton;

  final ListEnumSkeleton<GeneralInfo> _generalInfoSkeleton = ListEnumSkeleton();
  ListEnumBone<GeneralInfo> get generalInfoBone => _generalInfoSkeleton;

  final ListEnumSkeleton<DressCodeInfo> _dressCodeInfoSkeleton = ListEnumSkeleton();
  ListEnumBone<DressCodeInfo> get dressCodeInfoBone => _dressCodeInfoSkeleton;

  final OptionsFieldSkeleton<PropertyParking> _propertyParkingSkeleton = OptionsFieldSkeleton(
    sheet: OptionsFieldSheet(values: PropertyParking.values),
  );
  OptionsFieldBone<PropertyParking> get propertyParkingBone => _propertyParkingSkeleton;

  final OptionsFieldSkeleton<DimensionParking> _dimensionParkingSkeleton = OptionsFieldSkeleton(
    sheet: OptionsFieldSheet(values: DimensionParking.values),
  );
  OptionsFieldBone<DimensionParking> get dimensionParkingBone => _dimensionParkingSkeleton;

  final OptionsFieldSkeleton<int> _countSeatsSkeleton = OptionsFieldSkeleton(
    sheet: OptionsFieldSheet(values: List.generate(5, (index) => index * 10 + 10)),
  );
  OptionsFieldBone<int> get countSeatsBone => _countSeatsSkeleton;

  final ButtonFieldSkeleton _buttonSkeleton = ButtonFieldSkeleton();
  ButtonFieldBone get restaurantButtonBone => _buttonSkeleton;

  // Food Menu Edit
  FoodMenuSkeleton _foodMenuSkeleton = FoodMenuSkeleton();
  MenuBone<FoodCategory> get foodMenusBone => _foodMenuSkeleton;

  Future<void> inEditFood([ProductModel product]) async => _eventController.add(EditFood(product));
  Future<void> newFood(FoodCategory category) async => _eventController.add(NewFood(category));

  final ButtonFieldSkeleton _foodButtonSkeleton = ButtonFieldSkeleton();
  ButtonFieldBone get foodButtonBone => _foodButtonSkeleton;

  //Drink Menu Edit
  DrinkMenuSkeleton _drinkMenuSkeleton = DrinkMenuSkeleton();
  MenuBone<DrinkCategory> get drinkMenusBone => _drinkMenuSkeleton;

  Future<void> inEditDrink([ProductModel product]) async =>
      _eventController.add(EditDrink(product));
  Future<void> newDrink(DrinkCategory category) async => _eventController.add(NewDrink(category));

  final ButtonSkeleton _drinkButtonSkeleton = ButtonSkeleton();
  ButtonBone get drinkButtonBone => _drinkButtonSkeleton;

  // Outer Event
  final PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  RestaurantEditBloc({@required UserModel user}) {
    final restaurantCl = RestaurantCl();
    _pocket
        .putAndGet(_restaurantController)
        .pipeSource(() => restaurantCl.outerYourRestaurant(userID: user.id));
    _restaurantController.listen((restaurant) {
      if (restaurant == null) return;

      _imageFieldSkeleton
          .inValue(UnmodifiableListView(restaurant.imgs.map((img) => ImageFieldData.link(img))));
      _titleFieldSkeleton.inValue(restaurant.title);
      _descriptionFieldSkeleton.inValue(restaurant.description);
      _typesOfCuisineSkeleton.value = restaurant.typesOfCuisine;
      _generalInfoSkeleton.value = restaurant.info.general;
      _dressCodeInfoSkeleton.value = restaurant.info.dressCode;
      _propertyParkingSkeleton.inValue(restaurant.info.parking.property);
      _dimensionParkingSkeleton.inValue(restaurant.info.parking.dimension);
      _countSeatsSkeleton.inValue(restaurant.countSeats);
      _addressFieldSkeleton.inValue(restaurant.address.addressLine);

      _foodMenuSkeleton.pocket.pipeStream(RestaurantDc(restaurant.reference).foods().outer());
      _drinkMenuSkeleton.pocket.pipeStream(RestaurantDc(restaurant.reference).drinks().outer());
    });
    _titleFieldSkeleton.outValue.listen((data) => print(data?.toJson()));
    _buttonSkeleton.onSubmit = () async {
      final restaurantDc =
          _restaurant == null ? restaurantCl.document() : RestaurantDc(_restaurant.reference);

      final address =
          (await Geocoder.local.findAddressesFromQuery(_addressFieldSkeleton.value)).first;
      final point = GeoFirePoint(address.coordinates.latitude, address.coordinates.longitude);

      final newRestaurant = RestaurantModel(
        imgs: await Fs().updateImages(_imageFieldSkeleton.value, restaurantDc.reference.documentID),
        title: _titleFieldSkeleton.value,
        description: _descriptionFieldSkeleton.value,
        typesOfCuisine: _typesOfCuisineSkeleton.enumValues,
        countSeats: _countSeatsSkeleton.value,
        info: InfoRestaurantModel(
          general: _generalInfoSkeleton.enumValues,
          dressCode: _dressCodeInfoSkeleton.enumValues,
          parking: ParkingInfoModel(
            dimension: _dimensionParkingSkeleton.value,
            property: _propertyParkingSkeleton.value,
          ),
        ),
        owner: user.id,
        algoliaPosition: PocketPoint(address.coordinates.latitude, address.coordinates.longitude),
        geoPointFlutter: point,
        address: address,
      );

      restaurantDc.setModel(newRestaurant, merge: true);
      _eventController.add(NextTabEvent());
      return ButtonState.disabled;
    };

    _foodMenuSkeleton.onTapProduct = inEditFood;
    _foodButtonSkeleton.onSubmit = () async {
      _eventController.add(NextTabEvent());
      return ButtonState.disabled;
    };

    _drinkMenuSkeleton.onTapProduct = inEditDrink;
    _drinkButtonSkeleton.onSubmit = () async {
      _eventController.add(CompletedEvent());
      _buttonSkeleton.inState(ButtonState.enabled);
      _foodButtonSkeleton.inState(ButtonState.enabled);
      _drinkButtonSkeleton.inState(ButtonState.enabled);
      return ButtonState.disabled;
    };
  }
  factory RestaurantEditBloc.init(RestaurantEditBloc bloc) => BlocProvider.init(bloc);
  factory RestaurantEditBloc.of() => BlocProvider.of<RestaurantEditBloc>(true);
  static void close() => BlocProvider.dispose<RestaurantEditBloc>();
}

class NextTabEvent {}

class EditFood {
  final ProductModel product;
  final FoodCategory category;
  EditFood(this.product, [this.category]);
}

class EditDrink {
  final ProductModel product;
  EditDrink(this.product);
}

class NewDrink {
  final DrinkCategory category;
  NewDrink(this.category);
}

class NewFood {
  final FoodCategory category;
  NewFood(this.category);
}

class ListEnumSkeleton<TypeEnum> extends Skeleton implements ListEnumBone<TypeEnum> {
  final BehaviorSubject<List<TypeEnum>> _valuesController = BehaviorSubject.seeded([]);
  Stream<List<TypeEnum>> get outEnumValues => _valuesController;
  List<TypeEnum> get enumValues => _valuesController.value;

  void add(List<TypeEnum> enumValues) => _valuesController.add(enumValues);

  set value(List<TypeEnum> enumValues) {
    if (this.enumValues != enumValues) _valuesController.add(enumValues);
  }

  Future<void> inEnumValue(TypeEnum value) async {
    if (enumValues.contains(value)) {
      enumValues.remove(value);
    } else {
      enumValues.add(value);
    }
    _valuesController.add(enumValues.toList());
  }
}

abstract class ListEnumBone<TypeEnum> extends Bone {
  Stream<List<TypeEnum>> get outEnumValues;
//  List<TypeEnum> get enumValues;
  Future<void> inEnumValue(TypeEnum typeOfCuisine);
}
