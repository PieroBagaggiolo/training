import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/view/TypeOfCuisineView.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/FiltersDialogBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';


class FiltersDialog extends StatefulWidget {
  @override
  _FiltersDialogState createState() => _FiltersDialogState();
}

class _FiltersDialogState extends State<FiltersDialog> {
  final FiltersDialogBloc _bloc = FiltersDialogBloc.of(false);

  static final maxRadiusSearch = 400.0, minRadiusSearch = 100.0;

  @override
  void initState() {
    super.initState();
    _bloc.outEvent.listen(_eventListener);
  }

  @override
  void dispose() {
    FiltersDialogBloc.close();
    super.dispose();
  }

  void _eventListener(event) {
    if (event is CompletedEvent<RestaurantFilters>) {
      PocketRouter().pop(context, event.values.first);
    }
  }

  @override
  Widget build(BuildContext context) {
//    final theme = Theme.of(context);
//    final tt = theme.textTheme;

    return AlertDialog(
      title: Text("Filtri"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ObservableBuilder<int>(builder: (_, priceRating, state) {

            return DropdownButton<int>(
              isExpanded: true,
              value: priceRating,
              onChanged: _bloc.inPriceRating,
              items: List.generate(3, (_priceRating) {
                _priceRating += 1;
                return DropdownMenuItem(
                  value: _priceRating,
                  child: Text(List.generate(_priceRating, (i) => "€").join()),
                );
              }).toList()..add(DropdownMenuItem(
                value: null,
                child: Text("Prezzo"),
              )),
            );
          }, stream: _bloc.outPriceRating,),
          ObservableBuilder<TypeOfCuisine>(builder: (_, typeOfCuisine, state) {
            print(typeOfCuisine);
            return DropdownButton(
              isExpanded: true,
              onChanged: _bloc.inTypeOfCuisine,
              value: typeOfCuisine,
              items: TypeOfCuisine.values.map((_typeOfCuisine) {

                return DropdownMenuItem(
                  value: _typeOfCuisine,
                  child: TypeOfCuisineView(_typeOfCuisine),
                );
              }).toList()..add(DropdownMenuItem(
                value: null,
                child: Text("Cucina"),
              )),
            );
          }, stream: _bloc.outTypeOfCuisine,),
          if (_bloc.enableLocationSearch)
            ObservableBuilder<double>(builder: (_, radiusSearch, state) {

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Slider(
                    label: "$radiusSearch",
                    onChanged: _bloc.inRadiusSearch,
                    value: radiusSearch,
                    min: minRadiusSearch,
                    max: maxRadiusSearch,
                    divisions: ((maxRadiusSearch-minRadiusSearch)~/10).toInt(),
                  ),
                  Text("Km di Ricerca: $radiusSearch")
                ],
              );
            }, stream: _bloc.outRadiusSearch,),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: _bloc.cancel,
          child: Text("Chiudi"),
        ),
        FlatButton(
          onPressed: _bloc.search,
          child: Text("Cerca"),
        )
      ],
    );
  }
}


Future<RestaurantFilters> showFiltersDialog({
  BuildContext context, RestaurantFilters filters: const RestaurantFilters(),
}) {
  FiltersDialogBloc.init(FiltersDialogBloc(filters: filters));
  return showDialog<RestaurantFilters>(context: context, builder: (_) => FiltersDialog());
}
