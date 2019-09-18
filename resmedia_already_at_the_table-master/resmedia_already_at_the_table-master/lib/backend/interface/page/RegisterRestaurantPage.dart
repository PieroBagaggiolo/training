import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocket_map/pocket_map.dart';
import 'package:resmedia_already_at_the_table/backend/interface/view/InputParagraph.dart';
import 'package:resmedia_already_at_the_table/backend/logic/blocs/RestaurantEditBloc.dart';
import 'package:resmedia_already_at_the_table/interface/page/restaurant_page.dart';
import 'package:resmedia_already_at_the_table/interface/view/TypeOfCuisineView.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';

class RegisterRestaurantPageOwner extends StatelessWidget {
  final RestaurantEditBloc _editBloc = RestaurantEditBloc.of();

  @override
  Widget build(BuildContext context) {
    //final cls = Theme.of(context).colorScheme;

    return ObservableBuilder<RestaurantModel>(
        builder: (_, restaurant, state) {
          if (state is WaitingState) return state.toWidget();

          return FormProvider(
            child: Layout.vertical(
              children: [
                Layout.vertical(
                  expanded: true,
                  children: [
                    InputParagraph(
                      title: Text('Immagini del Ristorante (Max 20)'),
                      child: AspectRatio(
                        aspectRatio: 2,
                        child: ImageFieldShell(
                          bone: _editBloc.imageFieldBone,
                        ),
                      ),
                    ),
                    InputParagraph(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text("Nome del Ristorante"),
                      child: TranslationsFieldShell(
                        bone: _editBloc.titleFieldBone,
                      ),
                    ),
                    InputParagraph(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text("Descrizione del Ristorante"),
                      child: TranslationsFieldShell(
                        bone: _editBloc.descriptionFieldBone,
                        decoration: const TranslationsDecoration(
                          maxLines: 6,
                        ),
                      ),
                    ),
                    InputParagraph(
                      title: Text("Indirizzo"),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: PlaceFieldShell(
                        bone: _editBloc.addressFieldBone,
                      ),
                    ),
                    InputParagraph(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text('Tipi di Cucina'),
                      child: Card(
                        child: ListEnumSheet<TypeOfCuisine>(
                          bone: _editBloc.typesOfCuisineBone,
                          enumValues: TypeOfCuisine.values,
                          builder: (_, value) => TypeOfCuisineView(value),
                        ),
                      ),
                    ),
                    InputParagraph(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text('Informazioni Generali'),
                      child: Card(
                        child: ListEnumSheet<GeneralInfo>(
                          bone: _editBloc.generalInfoBone,
                          enumValues: GeneralInfo.values,
                          builder: (_, value) => GeneralInfoView(value),
                        ),
                      ),
                    ),
                    InputParagraph(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text('DressCode'),
                      child: Card(
                        child: ListEnumSheet<DressCodeInfo>(
                          bone: _editBloc.dressCodeInfoBone,
                          enumValues: DressCodeInfo.values,
                          builder: (_, value) => DressCodeInfoView(value),
                        ),
                      ),
                    ),
                    InputParagraph(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text('Parcheggio'),
                      child: Column(
                        children: <Widget>[
                          OptionsFieldShell<PropertyParking>(
                            (_, value) => PropertyParkingView(value),
                            bone: _editBloc.propertyParkingBone,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          OptionsFieldShell<DimensionParking>(
                            (_, value) => DimensionParkingView(value),
                            bone: _editBloc.dimensionParkingBone,
                          ),
                        ],
                      ),
                    ),
                    InputParagraph(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text("Numero di Coperti"),
                      child: OptionsFieldShell<int>(
                        (_, value) => Text('$value'),
                        bone: _editBloc.countSeatsBone,
                      ),
                    ),
                  ],
                  scrollPocket: const ScrollPocket(),
                  padding: const EdgeInsets.symmetric(vertical: SPACE),
                  separator: const SizedBox(
                    height: 16.0,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ButtonFieldShell(
                    bone: _editBloc.restaurantButtonBone,
                    shape: ContinuousRectangleBorder(),
                    child: Text("Continua"),
                  ),
                ),
              ],
            ),
          );
        },
        stream: _editBloc.outRestaurant,
        comparator: ObservableSubscriber.dataAndStateComparator,
    );
  }
}

class ListEnumSheet<TypeEnum> extends StatelessWidget {
  final List<TypeEnum> enumValues;
  final ListEnumBone<TypeEnum> bone;
  final ValueBuilder<TypeEnum> builder;

  const ListEnumSheet({
    Key key,
    @required this.bone,
    @required this.enumValues,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObservableBuilder<List<TypeEnum>>(
      builder: (_context, _enumValues, state) {
        return Column(
          children: enumValues.map((enumValue) {
            return SwitchListTile(
              dense: true,
              title: builder(_context, enumValue),
              onChanged: (_) => bone.inEnumValue(enumValue),
              value: _enumValues.contains(enumValue),
            );
          }).toList(),
        );
      },
      stream: bone.outEnumValues,
    );
  }
}
