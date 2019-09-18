import 'package:easy_blocs/easy_blocs.dart';
import 'package:rational/rational.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/r.dart';



final foodModel = FoodModel(
  title: TranslationsConst(it: "Salmone con Ananas"), img: R.assetsImgPromoPromo2, price: Rational.fromInt(12),
  description: TranslationsConst(it: "Il sapore dolce e leggermente aspro dell’ananas si sposa benissimo con il gusto deciso del salmone affumicato e con il limone. Provate a grattugiarne la scorza sul salmone! Vedrete che freschezza!"),
  recipe: TranslationsConst(it: "Tritate il salmone affumicato con la scorza del limone, quindi aggiungete i cubetti d’ananas già preparati.Ora viene la parte creativa."
    "Su ognuna di queste, riponete un cucchiaio abbondante di trito di salmone e ananas. A questo punto, alternate una mezza fetta del frutto ad ogni porzione di salmone."),
  sommelier: TranslationsConst(it: "Consigliato vino rosso"),
);


/*final menu = MenuModel(
  titleFood: "Menu",
  foods: {
    "Menu Mare": [
      FoodModel(title: Translations(it: "Carpaccio di Tonno o pesce spada o baccalà"), img: Mn.CARPACCIO),
    ],
  },
  titleDrink: "Bevande",
  drinks: {
    "Vino": [
      DrinkModel(title: Translations(it: "Vino bianco 0,75 lt"), img: Mn.CALICE_BIANCO),
    ],
  }
);*/


/*final menu = MenuModel(
  titleFood: "Menu",
  foods: {
    "Menu Mare": [
      FoodModel(
        title: TranslationsConst(it: "Carpaccio di Tonno o pesce spada o baccalà"),
        img: Mn.CARPACCIO,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Cozze alla “Basilico”"),
        img: Mn.COZZE_ALLA_BASILICO,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Cozze e calamari farciti"),
        img: Mn.COZZE_CALAMARI_FARCITI,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Acciughe alla povera"),
        img: Mn.ACCIUGHE_ALLA_POVERA,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Insalatina imperiale di mare"),
        img: Mn.INSALATINA_IMPERIALE_DI_MARE,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Ostriche ½ dozzina (6)"),
        img: Mn.OSTRICHE,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Crudità del Mediterraneo"),
        img: Mn.CRUDITA_DEL_MEDITERRANEO,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Crudità del mediterraneo con ostriche"),
        img: Mn.CRUDITA_DEL_MEDITERRANEO_CON_OSTRICHE,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Spaghetti tutto mare"),
        img: Mn.SPAGHETTI_TUTTO_MARE,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Ravioli di pesce"),
        img: Mn.RAVIOLI_DI_PESCE,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Paccheri alla Basilico"),
        img: Mn.PACCHERI_ALLA_BASILICO,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Tagliatelle alla proibita"),
        img: Mn.TAGLIATELLE_ALLA_PROIBITA,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Pasta fresca con ragù di pesce"),
        img: Mn.PASTA_FRESCA_RAGU_PESCE,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
    ],
    "Menu Terra": [
      FoodModel(
        title: TranslationsConst(it: "Tagliere di salumi misti"),
        img: Mn.TAGLIERE_DI_SALUMI_MISTO,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Tagliere di salumi, formaggi e mozzarella di bufala"),
        img: Mn.TAGLIERE_DI_SALUMI_E_FORMAGGI,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Linguine con pesto alla Genovese “Casa Lombardi"),
        img: Mn.LINGUINE_COL_PESTO,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Filetto di manzo"),
        img: Mn.FILETTO_DI_MANZO,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
    ],
    "Contorni": [
      FoodModel(
        title: TranslationsConst(it: "Insalata mista"),
        img: Mn.INSALATA_MISTA,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Verdure Grigliate"),
        img: Mn.VERDURE_GRIGLIATE,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      FoodModel(
        title: TranslationsConst(it: "Verdure Fritte"),
        img: Mn.VERDURE_FRITTE,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
    ],
    "Desert": [
      FoodModel(
        title: TranslationsConst(it: "Specchio frutta e dolci in bella vista"),
        img: Mn.SPECCHIO_FRUTTA_E_DOLCI_BELLAVISTA,
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
    ],
  },
  titleDrink: "Bevande",
  drinks: {
    "Vino": [
      DrinkModel(
        title: TranslationsConst(it: "Vino bianco 0,75 lt"),
        imgs: Array([Mn.CALICE_BIANCO]),
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      DrinkModel(
        title: TranslationsConst(it: "calice di Vino bianco frizzante 0,16 lt."),
        imgs: Array([Mn.CALICE_BIANCO_FRIZZANTE]),
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      DrinkModel(
        title: TranslationsConst(it: "Calice di Vino bianco/rosso 0,16 lt."),
        imgs: Array([Mn.BICCHIERE_ROSSO]),
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
    ],
    "Bevande": [
      DrinkModel(
        title: TranslationsConst(it: "Acqua 0,75/1,00 lt"),
        imgs: Array([Mn.ACQUALISCIA]),
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      DrinkModel(
        title: TranslationsConst(it: "Acqua minerale/oligominerale 0,65/0,75 lt"),
        imgs: Array([Mn.ACQUAGASSATA]),
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
    ],
    "Caffetteria": [
      DrinkModel(
        title: TranslationsConst(it: "Caffè"),
        imgs: Array([Mn.CAFFE]),
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
      DrinkModel(
        title: TranslationsConst(it: "Liquori e Amari Nazionali"),
        imgs: Array([Mn.AMARO]),
        price: 12,
        description: TranslationsConst(it: "Sono molto buono"),
      ),
    ],
  },
);*/

/*final menuFoods = <SubCategoryMenuModel> [
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Antipasti'),
    values: ArrayDocObj([]),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Primi Piatti'),
    values: ArrayDocObj([]),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Secondi Piatti'),
    values: ArrayDocObj([]),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Menu Mare'),
    values: ArrayDocObj(menu.foods['Menu Mare']),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Menu Terra'),
    values: ArrayDocObj(menu.foods['Menu Terra']),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Contorni'),
    values: ArrayDocObj(menu.foods['Contorni']),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Desert'),
    values: ArrayDocObj(menu.foods['Desert']),
  ),
];

final menuDrinks =  <SubCategoryMenuModel> [
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Bevande'),
    values: ArrayDocObj(menu.drinks['Bevande']),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Vini'),
    values: ArrayDocObj(menu.drinks['Vino']),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Alcolici'),
    values: ArrayDocObj([]),
  ),
  SubCategoryMenuModel(
    title: TranslationsConst(it: 'Caffetteria'),
    values: ArrayDocObj(menu.drinks['Caffetteria']),
  ),
];*/