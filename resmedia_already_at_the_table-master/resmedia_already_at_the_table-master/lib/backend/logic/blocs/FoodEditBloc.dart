import 'dart:async';
import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rational/rational.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';

class FoodEditBloc extends BlocBase {
  final _pocket = Pocket();

  @override
  void dispose() {
    _foodControl.close();
    _imageFieldSkeleton.dispose();
    _titleFieldSkeleton.dispose();
    _descriptionFieldSkeleton.dispose();
    _priceSkeleton.dispose();
    _buttonSkeleton.dispose();
    _eventController.close();
    super.dispose();
  }

  final FoodCategory category;

  final FormBone formBone = FormSkeleton();

  final BehaviorSubject<FoodModel> _foodControl = BehaviorSubject();
  Stream<FoodModel> get outFood => _foodControl.stream;

  final ImageFieldSkeleton _imageFieldSkeleton = ImageFieldSkeleton();
  ImageFieldBone get imageFieldBone => _imageFieldSkeleton;

  final TranslationsFieldSkeleton _titleFieldSkeleton = TranslationsFieldSkeleton();
  TranslationsFieldBone get titleFieldBone => _titleFieldSkeleton;

  final TranslationsFieldSkeleton _descriptionFieldSkeleton = TranslationsFieldSkeleton();
  TranslationsFieldBone get descriptionFieldBone => _descriptionFieldSkeleton;

  final TextFieldAdapter<Rational> _priceSkeleton = TextFieldAdapter.price();
  TextFieldAdapter get priceFieldBone => _priceSkeleton;

  final ButtonFieldSkeleton _buttonSkeleton = ButtonFieldSkeleton();
  ButtonBone get submitButtonBone => _buttonSkeleton;

  final PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  FoodEditBloc({
    FoodModel food,
    RestaurantModel restaurant,
    @required this.category,
  }) : assert(food != null || (restaurant != null && category != null)) {
    final foodDc = food != null
        ? FoodDc(food.reference)
        : RestaurantDc(restaurant.reference).foods().document();

    _pocket.putAndGet(_foodControl).pipeSource(() => foodDc.outer());
    _foodControl.listen((_food) {
      if (food == null) return;
      if (food.img != null)
        _imageFieldSkeleton.inValue(UnmodifiableListView([ImageFieldData.link(food.img)]));
      _titleFieldSkeleton.inValue(_food.title);
      _descriptionFieldSkeleton.inValue(_food.description);
      _priceSkeleton.inAdapterValue(_food.price);
    });

    _buttonSkeleton.onSubmit = () async {
      final imagesData = _imageFieldSkeleton.value.toList();
      final links = List();
      final fs = FirebaseStorage.instance;
      await Future.forEach<ImageFieldData>(imagesData, (imageData) async {
        // flutter_native_image

        if (imageData.link != null && imageData.file != null) {
          final ref = await fs.getReferenceFromUrl(imageData.link);
          await ref.delete();
        }
        if (imageData.file != null) {
          final newRef = fs
              .ref()
              .child(foodDc.reference.parent().path)
              .child(imageData.file.path.split("/").last);
          final task = newRef.putFile(imageData.file);
          links.add(await (await task.onComplete).ref.getDownloadURL());
        } else {
          links.add(imageData.link);
        }
      });

      await foodDc.setModel(
          FoodModel(
            title: _titleFieldSkeleton.value,
            description: _descriptionFieldSkeleton.value,
            price: _priceSkeleton.adapterValue,
            img: links.first,
            category: food?.category ?? category,
          ),
          merge: true);

      _eventController.add(CompletedEvent());
      return ButtonState.disabled;
    };
  }
  factory FoodEditBloc.init(FoodEditBloc bloc) => BlocProvider.init<FoodEditBloc>(bloc);
  factory FoodEditBloc.of() => BlocProvider.of<FoodEditBloc>();
  static void close() => BlocProvider.dispose<FoodEditBloc>();
}
