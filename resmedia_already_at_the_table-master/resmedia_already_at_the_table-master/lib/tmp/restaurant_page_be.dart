
/*import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/widget/backend_input.dart';
import 'package:resmedia_already_at_the_table/backend/logic/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/data/tmp/restaurant_data.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';


class RestaurantPageBe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    return streamBuild<RestaurantModel>(
      initialData: RestaurantBloc.of().restaurant,
      stream: RestaurantBloc.of().outRestaurant,
      builder: (context, snapshot) {
        final model = snapshot.data;
        return SafePage(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 2,
                  child: EasyImage.network(model.imgs[0]),
                ),
                InputFieldBackEnd(
                  title: Text("Nome del ristorante", style: theme.textTheme.subtitle,),
                  onSave: print,
                  inputFieldBuilder: (isEnable, control) {
                    control.text = "Ristorante Basilico Fresco";
                    return TextField(
                      enabled: isEnable,
                      controller: control,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                ),
                Divider(color: Colors.grey,),
                InputFieldBackEnd(
                  title: Text("Descrizione del ristorante", style: theme.textTheme.subtitle,),
                  onSave: print,
                  inputFieldBuilder: (isEnable, control) {
                    control.text = bisilicoDsc;
                    return TextField(
                      enabled: isEnable,
                      controller: control,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    );
                  }
                ),
                Divider(),
                InputFieldBackEnd(
                    title: Text("Altre Informazioni", style: theme.textTheme.subtitle,),
                    onSave: print,
                    inputFieldBuilder: (isEnable, control) {
                      control.text = info;
                      return TextField(
                        enabled: isEnable,
                        controller: control,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      );
                    }
                ),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}






final info = """Locale climatizzato 
Wi-fi 
Cocktail bar 
Parcheggio privato ampio 
Giardino esterno 
Coperti 150 
Adatta ad eventi 
Dress code: consigliato casual elegante. 
Pagamenti accettati: MasterCard, Buoni pasto
Orari di apertura: dal mar a dom 11.30-15/18.30-23.30""";*/
