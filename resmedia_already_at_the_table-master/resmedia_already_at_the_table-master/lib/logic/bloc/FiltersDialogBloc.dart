import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';


class FiltersDialogBloc extends BlocBase {
  //final _pocket = Pocket();

  @override
  void dispose() {
    _priceRatingController.close();
    _typeOfCuisineController.close();
    _eventController.close();
    super.dispose();
  }

  final bool enableLocationSearch;

  BehaviorSubject<int> _priceRatingController = BehaviorSubject();
  Stream<int> get outPriceRating => _priceRatingController;
  Future<void> inPriceRating(int priceRating) async =>
      _priceRatingController.add(priceRating);

  BehaviorSubject<TypeOfCuisine> _typeOfCuisineController = BehaviorSubject();
  Stream<TypeOfCuisine> get outTypeOfCuisine => _typeOfCuisineController;
  Future<void> inTypeOfCuisine(TypeOfCuisine typeOfCuisine) async =>
      _typeOfCuisineController.add(typeOfCuisine);

  BehaviorSubject<double> _radiusSearchController = BehaviorSubject.seeded(200.0);
  Stream<double> get outRadiusSearch => _radiusSearchController;
  Future<void> inRadiusSearch(double radiusSearch) async =>
      _radiusSearchController.add(radiusSearch);

  BehaviorSubject _eventController = BehaviorSubject();
  Stream get outEvent => _eventController;

  Future<void> cancel() async {
    _submit();
  }
  Future<void> search() async {
    _submit(RestaurantFilters(
      priceRating: _priceRatingController.value,
      typeOfCuisine: _typeOfCuisineController.value,
    ));
  }

  void _submit([RestaurantFilters filters]) {
    _eventController.add(CompletedEvent<RestaurantFilters>([filters]));
  }

  FiltersDialogBloc({
    RestaurantFilters filters: const RestaurantFilters(),
  }) : this.enableLocationSearch = false{
    _typeOfCuisineController.add(filters.typeOfCuisine);
    _priceRatingController.add(filters.priceRating);
    _radiusSearchController.add(filters.radiusSearch);
  }
  factory FiltersDialogBloc.init(FiltersDialogBloc bloc) => BlocProvider.init(bloc);
  factory FiltersDialogBloc.of([allowNull=false]) => BlocProvider.of<FiltersDialogBloc>(allowNull);
  static void close() => BlocProvider.dispose<FiltersDialogBloc>();
}

