import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_already_at_the_table/backend/interface/view/InputParagraph.dart';
import 'package:resmedia_already_at_the_table/backend/interface/widget/FakeWidgets.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';


class DishDayPageOwner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;

    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Promozione visibile all'utente"),
          trailing: FakeSwitch(
            color: cls.secondary,
          ),
        ),
        Container(height: 2, color: cls.primary,),
        Expanded(
          child: ListViewSeparated(
            padding: const EdgeInsets.all(SPACE),
            children: <Widget>[
              InputParagraph(
                title: Text("Immagine"),
                child: AspectRatio(
                  aspectRatio: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FakeImageInputField(),
                  ),
                ),
              ),
              InputParagraph(
                title: Text("Nome del Piatto"),
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    suffixIcon: const Icon(Icons.text_fields),
                    border: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
                    ),
                  ),
                ),
              ),
              InputParagraph(
                title: Text("Prezzo"),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    suffixIcon: const Icon(FontAwesomeIcons.moneyBill),
                    border: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
                    ),
                  ),
                ),
              ),
            ],
            separator: const SizedBox(height: 16.0,),
          ),
        ),
      ],
    );
  }
}
