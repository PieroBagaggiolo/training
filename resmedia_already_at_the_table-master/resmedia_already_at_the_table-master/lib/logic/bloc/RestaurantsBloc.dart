import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantsBloc extends BlocBase {
  final RepositoryBloc repository;

  final _pocket = Pocket();

  RestaurantFilters _filters;
  RestaurantFilters get filters => _filters;

  @override
  void dispose() {
    _restaurantsController.close();
    _typeOfCuisineController.close();
    _pointSubscription.cancel();
    super.dispose();
  }

  BehaviorSubject<List<RestaurantModel>> _restaurantsController = BehaviorSubject();
  Stream get outRestaurants => _restaurantsController;

  BehaviorSubject<TypeOfCuisine> _typeOfCuisineController = BehaviorSubject();
  Stream<TypeOfCuisine> get outTypeOfCuisine => _typeOfCuisineController.stream;

  StreamSubscription _pointSubscription;
  Future<void> inFilters(RestaurantFilters filters) async {
    _filters = filters;
    _pointSubscription?.cancel();
    _pointSubscription = UserBloc.of().outPoint.listen((point) {
      _pocket.putOrGet(_restaurantsController).pipeStream(RestaurantCl().outerSearchByPosition(
            point: point,
            filters: _filters,
          ));
    });
    _typeOfCuisineController.add(_filters.typeOfCuisine);
  }

  RestaurantsBloc({
    @required this.repository,
    RestaurantFilters filters: const RestaurantFilters(),
  }) : _filters = filters {
    inFilters(filters);
  }
  factory RestaurantsBloc.init(RestaurantsBloc bloc) => BlocProvider.init(bloc);
  factory RestaurantsBloc.of() => BlocProvider.of<RestaurantsBloc>();
  static void close() => BlocProvider.dispose<RestaurantsBloc>();

  Future<void> inQuery(String query) async {
    _pocket.putOrGet(_restaurantsController).pipeStream(RestaurantCl().outerSearchByText(
          text: query,
          filters: _filters,
        ));
  }
}
