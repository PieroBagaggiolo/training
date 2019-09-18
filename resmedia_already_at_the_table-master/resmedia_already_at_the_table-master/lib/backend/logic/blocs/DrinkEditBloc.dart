import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:rational/rational.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';

class DrinkEditBloc extends BlocBase {
  final _pocket = Pocket();

  @override
  void dispose() {
    _drinkControl.close();
    _imageControl.close();
    _titleFieldSkeleton.dispose();
    _descriptionFieldSkeleton.dispose();
    _priceSkeleton.dispose();
    _buttonSkeleton.dispose();
    _eventController.close();
    super.dispose();
  }

  final FormBone formBone = FormSkeleton();

  final BehaviorSubject<DrinkModel> _drinkControl = BehaviorSubject();
  Stream<DrinkModel> get outDrink => _drinkControl.stream;

  final BehaviorSubject<String> _imageControl = BehaviorSubject();
  Stream<String> get outImage => _imageControl.stream;

  final TranslationsFieldSkeleton _titleFieldSkeleton = TranslationsFieldSkeleton();
  TranslationsFieldBone get titleFieldBone => _titleFieldSkeleton;

  final TranslationsFieldSkeleton _descriptionFieldSkeleton = TranslationsFieldSkeleton();
  TranslationsFieldBone get descriptionFieldBone => _descriptionFieldSkeleton;

  final TextFieldAdapter<Rational> _priceSkeleton = TextFieldAdapter.price();
  TextFieldBone get priceFieldBone => _priceSkeleton;

  final ButtonFieldSkeleton _buttonSkeleton = ButtonFieldSkeleton();
  ButtonFieldBone get submitButtonBone => _buttonSkeleton;

  final PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

//  final BehaviorSubject<int> _mainCategoryControl = BehaviorSubject();
//  Stream<int> get outMainCategory => _mainCategoryControl.stream;
//
//  final BehaviorSubject<int> _subCategoryControl = BehaviorSubject();
//  Stream<int> get outSubCategory => _subCategoryControl.stream;

//  final BehaviorSubject<ButtonStatus> _buttonStatusControl =
//      BehaviorSubject.seeded(ButtonStatus.CREATE);
//  Stream<ButtonStatus> get outButtonStatus => _buttonStatusControl.stream;


  DrinkEditBloc({DrinkModel drink, RestaurantModel restaurant}) {
    assert(drink != null || restaurant != null);
    final foodDc = drink != null
        ? DrinkDc(drink.reference)
        : RestaurantDc(restaurant.reference).drinks().document();

    _pocket.putAndGet(_drinkControl).pipeSource(() => foodDc.outer());
    _drinkControl.listen((_food) {
      if (drink == null)
        return;
      _titleFieldSkeleton.inValue(_food.title);
      _descriptionFieldSkeleton.inValue(_food.description);
      _priceSkeleton.inAdapterValue(_food.price);
    });

    _buttonSkeleton.onSubmit = () async {

      await foodDc.setModel(DrinkModel(
        title: _titleFieldSkeleton.value,
        description: _descriptionFieldSkeleton.value,
        price: _priceSkeleton.adapterValue,
      ), merge: true);

      _eventController.add(CompletedEvent());
      return ButtonState.disabled;
    };
  }
  factory DrinkEditBloc.init(DrinkEditBloc bloc) => BlocProvider.init<DrinkEditBloc>(bloc);
  factory DrinkEditBloc.of() => BlocProvider.of<DrinkEditBloc>();
  static void close() => BlocProvider.dispose<DrinkEditBloc>();
}