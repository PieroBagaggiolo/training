import 'dart:math';

import 'package:rxdart/rxdart.dart';

import 'model/products/DrinkModel.dart';
import 'model/products/FoodModel.dart';

class Sm {
  final isSimulation;
  final rd = Random();

  static Sm _instance;

  Sm._({bool isSimulation: false}) : this.isSimulation = isSimulation;

  factory Sm.configure({bool isSimulation: false}) {
    return _instance = Sm._(isSimulation: isSimulation);
  }

  factory Sm() {
    return _instance??(_instance = Sm._());
  }

  bool get bl => isSimulation ? rd.nextInt(2) == 0 : false;

  String get ownerName => isSimulation ? """Gianfranco Luca""" : "";
  String get ownerAddress => isSimulation ? """Viale John Fitzgerald Kennedy 26/28, Marina di Torre Del Lago, Viareggio (LU) 55049""" : "";
  String get ownerVatNum => isSimulation ? """35535839275""" : "";
  String get ownerMail => isSimulation ? """basilicofresco@gmail.com""" : "";
  String get ownerPassword => isSimulation ? """sadsadfsafsada""" : "";

  List<String> get restaurantImgs => [];
  String get restaurantName => isSimulation ? """Ristorante Basilico Fresco""" : "";
  String get restaurantDescription => isSimulation ?
    """Non lontano dal Lago che ispiro` il grande maestro Puccini e a due passi dal mare, immerso nel verde del Parco "Migliarino San Rossore", dal 2012 il Ristorante Basilico Fresco fa da trait d’union tra il gusto della cucina mediterranea e quello della tradizione locale. Punto di riferimento per gli amanti del gusto in Versilia, il locale nasce dal sodalizio tra Giacomo, Bruno e Mariella, dalla loro esperienza e dalla loro passione.
      Concependo il sapore come un percorso di emozioni, estetiche e gustative, Basilico Fresco propone un viaggio attraverso la creativita`, l’immagine e la sostanza, al giusto prezzo.
      Creativita` nella tradizione e attenzione alla materia prima sono gli ingredienti dei menu` che Giacomo Pezzini compone e aggiorna secondo il mercato e le stagioni.""" :
    "";
  int get restaurantNumSeats => isSimulation ? 50 : 0;

  // ignore: close_sinks
  BehaviorSubject<Map<FoodCategory, List<FoodModel>>> _foodsController = BehaviorSubject.seeded(
    toMap<FoodCategory, FoodModel>(FoodCategory.values),
  );
  Stream<Map<FoodCategory, List<FoodModel>>> get outFoods => isSimulation
      ? null // RestaurantBloc.of().foodMenuBone.menu
      : _foodsController.stream;

  static Map<C, List<V>> toMap<C, V>(List<C> categories) {
    return categories.asMap().map((index, category) {
      return MapEntry(
          category,
          [],
      );
    });
  }

  // ignore: close_sinks
  BehaviorSubject<Map<DrinkCategory, List<DrinkModel>>> _drinksController = BehaviorSubject.seeded(
    toMap<DrinkCategory, DrinkModel>(DrinkCategory.values),
  );
  Stream<Map<DrinkCategory, List<DrinkModel>>> get outDrinks => isSimulation
      ? null//RestaurantBloc.of().drinkBone.outValue
      : _drinksController.stream;
  /*List<SubCategoryMenuModel> get menuFood => isSimulation ? menuFoods : <SubCategoryMenuModel> [
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
      values: ArrayDocObj([]),
    ),
    SubCategoryMenuModel(
      title: TranslationsConst(it: 'Menu Terra'),
      values: ArrayDocObj([]),
    ),
    SubCategoryMenuModel(
      title: TranslationsConst(it: 'Contorni'),
      values: ArrayDocObj([]),
    ),
    SubCategoryMenuModel(
      title: TranslationsConst(it: 'Desert'),
      values: ArrayDocObj([]),
    ),
  ];

  List<SubCategoryMenuModel> get menuDrink => isSimulation ? menuDrinks : <SubCategoryMenuModel> [
    SubCategoryMenuModel(
      title: TranslationsConst(it: 'Bevande'),
      values: ArrayDocObj([]),
    ),
    SubCategoryMenuModel(
      title: TranslationsConst(it: 'Vini'),
      values: ArrayDocObj([]),
    ),
    SubCategoryMenuModel(
      title: TranslationsConst(it: 'Alcolici'),
      values: ArrayDocObj([]),
    ),
    SubCategoryMenuModel(
      title: TranslationsConst(it: 'Caffetteria'),
      values: ArrayDocObj([]),
    ),
  ];*/

  String get foodImg => null;
  String get foodName => isSimulation ? """Carpaccio di Tonno o pesce spada o baccalà""" : "";
  String get foodPrice => isSimulation ? """12.50""" : "";
  String get foodDescription => isSimulation ? """Il carpaccio di tonno è un antipasto fresco e semplice da preparare, una ricetta mediterranea ideale per un pranzo estivo, anche come secondo piatto.""" : "";
  String get foodRecipe => isSimulation ? """Per prepararlo è importante che il pesce sia freschissimo: quando lo acquistate chiedete il trancio di tonno adatto per il carpaccio, magari tagliato già a fette sottili. Il carpaccio è una preparazione che avviene facendo marinare in un'emulsione di olio, succo di limone ed erbette, delle fettine di carne o di pesce, da condire in tanti modi diversi, a seconda dei gusti e delle esigenze. Ma ecco come prepare un perfetto carpaccio di tonno in poco tempo!""" : "";

  List<String> get drinkImages => null;
  String get drinkName => isSimulation ? """Vino bianco 0,75 lt""" : "";
  String get drinkPrice => isSimulation ? """8.50""" : "";
  String get drinkDescription => isSimulation ? """Il vino bianco esiste da millenni. Questa bevanda alcolica ha accompagnato lo sviluppo economico di continenti come l'Europa, l'America, l'Oceania i cui abitanti sono consumatori di vino. In Africa e in Asia la cultura vinicola ha avuto un impatto inferiore dovuto a ragioni climatiche e religiose.""" : "";
}