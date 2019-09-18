import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/view/InputParagraph.dart';
import 'package:resmedia_already_at_the_table/backend/interface/widget/FakeWidgets.dart';
import 'package:resmedia_already_at_the_table/backend/logic/blocs/DrinkEditBloc.dart';
import 'package:resmedia_already_at_the_table/backend/logic/blocs/FoodEditBloc.dart';
import 'package:resmedia_already_at_the_table/generated/i18nMethod.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/simulation.dart';

class FoodScreenOwner extends StatefulWidget {
  static const ROUTE = 'FoodScreenOwner';

  @override
  _FoodScreenOwnerState createState() => _FoodScreenOwnerState();
}

class _FoodScreenOwnerState extends State<FoodScreenOwner> {
  final _editBloc = FoodEditBloc.of();

  @override
  void initState() {
    _editBloc.outEvent.listen(_eventListener);
    super.initState();
  }

  @override
  void dispose() {
    FoodEditBloc.close();
    super.dispose();
  }

  void _eventListener(event) {
    if (event is CompletedEvent) {
      PocketRouter().pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    //final cls = theme.colorScheme;

    return BoneProvider(
      bone: _editBloc.formBone,
      child: ObservableBuilder<FoodModel>(
          builder: (_, food, state) {
            if (state is WaitingState) return state.toWidget();

            return Scaffold(
              appBar: AppBar(
                title: Text(SS.foodCategoryToMenuTitle(_editBloc.category)),
              ),
              body: Layout.horizontal(
                children: [
                  InputParagraph(
                    title: Text("Immagine"),
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: ImageFieldShell(
                        bone: _editBloc.imageFieldBone,
                      ),
                    ),
                  ),
                  InputParagraph(
                    title: Text("Nome del Piatto"),
                    child: TranslationsFieldShell(
                      bone: _editBloc.titleFieldBone,
                    ),
                  ),
                  InputParagraph(
                    title: Text("Descrizione del Piatto"),
                    child: TranslationsFieldShell(
                      bone: _editBloc.descriptionFieldBone,
                      decoration: const TranslationsDecoration(
                        maxLines: 5,
                      ),
                    ),
                  ),
                  InputParagraph(
                    title: Text("Prezzo"),
                    child: TextFieldShell(
                      bone: _editBloc.priceFieldBone,
                    ),
                  ),
//          InputParagraph(
//            title: Text('Tipologie di Cucina'),
//            child: Card(
//              child: Column(
//                children: typesCuisine.map((info) {
//                  return ListTile(
//                    title: Text(info),
//                    trailing: FakeSwitch(
//                      color: cls.secondary,
//                      value: Sm().bl,
//                    ),
//                  );
//                }).toList(),
//              ),
//            ),
//          ),
                  /*InputParagraph(
            title: Text('Ingredienti Principali'),
            child: TextField(
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffixIcon: const Icon(Icons.textsms),
                border: const OutlineInputBorder(
                  borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
                ),
              ),
            ),
          ),*/
//          InputParagraph(
//            title: Text('Ricetta'),
//            child: TextField(
//              minLines: 5,
//              maxLines: 10,
//              keyboardType: TextInputType.text,
//            ),
//          ),
                ],
                padding: const EdgeInsets.all(SPACE),
                separator: const SizedBox(height: 16.0),
                scrollPocket: const ScrollPocket(),
              ),
              bottomNavigationBar: ButtonFieldShell(
                bone: _editBloc.submitButtonBone,
                shape: ContinuousRectangleBorder(),
                child: Text("Salva"),
              ),
            );
          },
          stream: _editBloc.outFood,
          comparator: ObservableSubscriber.dataAndStateComparator),
    );
  }
}

class DrinkScreenOwner extends StatefulWidget {
  static const ROUTE = 'DrinkScreenOwner';

  @override
  _DrinkScreenOwnerState createState() => _DrinkScreenOwnerState();
}

class _DrinkScreenOwnerState extends State<DrinkScreenOwner> {
  final _editBloc = DrinkEditBloc.of();

  @override
  void initState() {
    _editBloc.outEvent.listen(_eventListener);
    super.initState();
  }

  @override
  void dispose() {
    DrinkEditBloc.close();
    super.dispose();
  }

  void _eventListener(event) {
    if (event is CompletedEvent) {
      PocketRouter().pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    //final cls = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Piatto"),
      ),
      body: ObservableBuilder<DrinkModel>(
          builder: (_, food, state) {
            if (state is WaitingState) return state.toWidget();

            return BoneProvider(
              bone: _editBloc.formBone,
              child: Layout.vertical(
                children: [
                  InputParagraph(
                    title: Text("Immagine"),
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FakeImageInputField.assets(
                          img: Sm().foodImg,
                        ),
                      ),
                    ),
                  ),
                  InputParagraph(
                    title: Text("Nome del Piatto"),
                    child: TranslationsFieldShell(
                      bone: _editBloc.titleFieldBone,
                    ),
                  ),
                  InputParagraph(
                    title: Text("Descrizione del Piatto"),
                    child: TranslationsFieldShell(
                      bone: _editBloc.descriptionFieldBone,
                      decoration: const TranslationsDecoration(
                        maxLines: 6,
                      ),
                    ),
                  ),
                  InputParagraph(
                    title: Text("Prezzo"),
                    child: TextFieldShell(
                      bone: _editBloc.priceFieldBone,
                    ),
                  ),
//          InputParagraph(
//            title: Text('Tipologie di Cucina'),
//            child: Card(
//              child: Column(
//                children: typesCuisine.map((info) {
//                  return ListTile(
//                    title: Text(info),
//                    trailing: FakeSwitch(
//                      color: cls.secondary,
//                      value: Sm().bl,
//                    ),
//                  );
//                }).toList(),
//              ),
//            ),
//          ),
                  /*InputParagraph(
            title: Text('Ingredienti Principali'),
            child: TextField(
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                suffixIcon: const Icon(Icons.textsms),
                border: const OutlineInputBorder(
                  borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
                ),
              ),
            ),
          ),*/
//          InputParagraph(
//            title: Text('Ricetta'),
//            child: TextField(
//              minLines: 5,
//              maxLines: 10,
//              keyboardType: TextInputType.text,
//            ),
//          ),
                  ButtonFieldShell(
                    bone: _editBloc.submitButtonBone,
                    child: Text("Salva"),
                  ),
                ],
                padding: const EdgeInsets.all(SPACE),
                separator: const SizedBox(height: 16.0),
                scrollPocket: const ScrollPocket(),
              ),
            );
          },
          stream: _editBloc.outDrink,
          comparator: ObservableSubscriber.dataAndStateComparator),
    );
  }
}
