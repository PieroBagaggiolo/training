import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/dialogs/FiltersDialog.dart';
import 'package:resmedia_already_at_the_table/interface/main/MainWidgets.dart';
import 'package:resmedia_already_at_the_table/interface/view/RestaurantView.dart';
import 'package:resmedia_already_at_the_table/interface/view/TypeOfCuisineView.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/FiltersDialogBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';


class RestaurantsScreen extends StatefulWidget {
  static const ROUTE = 'RestaurantsScreen';

  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final _restaurantsBloc = RestaurantsBloc.of();

  @override
  void dispose() {
    RestaurantsBloc.close();
    super.dispose();
  }

  Future<void> onTapFiltersButton() async {
    FiltersDialogBloc.init(FiltersDialogBloc(
      filters: _restaurantsBloc.filters,
    ));
    final filters = await showDialog<RestaurantFilters>(context: context, builder: (_) => FiltersDialog());
    if (filters != null)
      _restaurantsBloc.inFilters(filters);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MainAppBar(
        title: StreamBuilder<TypeOfCuisine>(
          stream: _restaurantsBloc.outTypeOfCuisine,
          builder: (context, snapshot) {
            return TypeOfCuisineView(snapshot.data);
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: onTapFiltersButton,
            icon: const Icon(Icons.filter_list),
          )
        ],
      ),
      body: RestaurantsGridBuilder(),
    );
  }
}




