import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/HomeOwner.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/RegisterOwnerScreen.dart';
import 'package:resmedia_already_at_the_table/generated/i18n.dart';
import 'package:resmedia_already_at_the_table/interface/screen/HomeScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/SigUpMoreScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/SignUpScreen.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/logic/repository/SignRepository.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';
import 'package:resmedia_already_at_the_table/r.dart';
import 'package:resmedia_already_at_the_table/route.dart';

const PRIMARY = const Color(0xFF86BC25), // green
    PRIMARY_VARIANT = const Color(0xFF9AA09B), // grey
    SECONDARY = const Color(0xFFC83206), // orange
    SECONDARY_VARIANT = const Color(0xFF548c00); // dark_green 334213 225e00

void main() {
  registerFromJson<PartialChairModel>(PartialChairModel, PartialChairModel.fromJson);
  registerFromJson<ProductCartFirebase>(ProductCartFirebase, ProductCartFirebase.fromJson);

  route();

  runApp(RepositoryBuilder<RepositoryBloc>(
    splashWidget: Container(color: Colors.white, child: Image.asset(R.assetsImgLaunchImage)),
    creator: (data) {
      return RepositoryBloc(
        sharedPreferences: data.sharedPreferences,
        translatorSkeleton: data.translatorSkeleton,
        spSkeleton: data.spSkeleton,
      );
    },
    worker: (context, sharedPreferences) async {
      final signRepository = SignRepository.init(SignRepository());

      await AssetHandler.init(context).then((assetHandler) {
        [
          PaymentCard.ASSET_FOLDER,
          FlagView.ASSET_FOLDER,
          "assets/imgs/restaurant/type_of_cuisine/",
        ].forEach((path) => assetHandler.getFolder(path).cacheImages());
        return assetHandler.getFolder('assets/img/').cacheImages();
      });

      return calculatePage(await signRepository.getCurrentUser(), signRepository: signRepository);
    },
    builder: (_, data) => MyApp(
      data: data,
    ),
  ));
}

Future<String> calculatePage(
  FirebaseUser firebaseUser, {
  SignRepository signRepository,
  UserModel user,
}) async {
  signRepository = signRepository ?? SignRepository.of();

  if (firebaseUser == null) {
    SignUpBloc.init(SignUpBloc(signRepository: signRepository));
    return SignUpScreen.ROUTE;
  }
  user = user ?? (await (UserBloc.init(UserBloc(firebaseUser: firebaseUser))).outUser.first);
  if (user.registrationLv == 0) {
    SignUpMoreBloc.init(SignUpMoreBloc());
    return SignUpMoreScreen.ROUTE;
  } else {
    if (RepositoryBloc.of().flavour == Flavour.client) {
      return HomeScreen.ROUTE;
    } else {
      if (user.yourRestaurants == null || user.yourRestaurants.isEmpty) {
        return RegisterOwnerScreen.ROUTE;
      } else {
        return HomeOwnerScreen.ROUTE;
      }
    }
  }
}

class MyApp extends StatelessWidget {
  final RepositoryData data;

  MyApp({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    final sp = data.sp;
    final locale = data.locale;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      //localeResolutionCallback: S.delegate.resolution(fallback: Locale('it')),
      onGenerateTitle: (context) => S.of(context).title,
      theme: ThemeData(
        //za<brightness: Brightness.dark,
        primaryColor: PRIMARY,
        accentColor: SECONDARY,
        buttonColor: SECONDARY,
        indicatorColor: PRIMARY,
        dividerColor: PRIMARY_VARIANT,
        colorScheme: const ColorScheme.light(
          primary: PRIMARY,
          primaryVariant: PRIMARY_VARIANT,
          secondary: SECONDARY,
          secondaryVariant: SECONDARY_VARIANT,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: PRIMARY_VARIANT,
        ),
        iconTheme: const IconThemeData(
          color: PRIMARY_VARIANT,
        ),
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          buttonColor: SECONDARY,
          height: 48,
          shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          errorStyle: const TextStyle(
            color: SECONDARY,
          ),
          border: const OutlineInputBorder(
            borderSide: const BorderSide(color: PRIMARY_VARIANT),
            borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
          ),
        ),
        textTheme: TextThemeSp(
          sp: sp,
          adv: true,
          title: TextStyle(
            color: PRIMARY,
          ),
        ),
      ),
      initialRoute: data.screen,
      onGenerateRoute: PocketRouter().onGenerateRouteBuilder(),
    );
  }
}

/*class Repository<T> extends StatelessWidget {
  final _RepositoryBuilder builder;

  final _BackgroundTask<T> backgroundTask;

  final Widget splashWidget;

  Repository({Key key,
    @required this.builder,
    @required this.backgroundTask,
    this.splashWidget,
  }) : assert(builder != null), assert(backgroundTask != null), super(key: key);

  Future<RepositoryData<T>> _future(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    RepositoryBloc.init(sharedPreferences: sharedPreferences);
    final data = await backgroundTask(context, sharedPreferences);
    return RepositoryData<T>(sharedPreferences: sharedPreferences, data: data);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<RepositoryData<T>>(
        initialData: null,
        future: _future(context),
        builder: (_, snapshot) {

          if (!snapshot.hasData) {
            return splashWidget??Container(
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          final _bloc = RepositoryBloc.of();

          return StreamBuilder<RepositoryData<T>>(
            initialData: snapshot.data.copyWith(sp: Sp()),
            stream: Observable.combineLatest2(_bloc.outLocale, _bloc.outSp, (locale, sp) {
              return snapshot.data.copyWith(locale: locale, sp: sp);
            }),
            builder: (context, snap) {
              return BlocProvider.fromBloc(
                bloc: _bloc,
                child: builder(snap.data),
              );
            },
          );
        }
    );
  }
}*/
