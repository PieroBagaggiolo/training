import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:resmedia_already_at_the_table/logic/fs/DynamicLinks.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Functions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const STRIPE_PUBLIC_KEY = "pk_test_J9uE6wOePFdsTkKNjVdCcExz00IKKbX2NN";

class RepositoryBloc extends RepositoryBlocBase {
  final _pocket = Pocket();
  final FbCloudFunctions cloudFunctions = FbCloudFunctions();
  final FbDynamicLinks dynamicLinks = FbDynamicLinks();

  void dispose() {
    _locationController.close();
    super.dispose();
  }

  final Flavour flavour = Flavour.client;
  final googleMapsApiKey = "AIzaSyBv2O9sx_5_z9RvInGYcp-ClkjhLFxrnEM";

  final location = Location()
    ..changeSettings(
      accuracy: LocationAccuracy.BALANCED,
      interval: Duration(minutes: 1).inMilliseconds,
      distanceFilter: 1000,
    );

  Future<bool> _checkPermissions() async {
    if (!await location.hasPermission()) if (!await location.requestPermission()) return false;

    if (!await location.serviceEnabled()) if (!await location.requestService()) return false;

    return true;
  }

  Future<LocationData> getLocation() async {
    if (!await _checkPermissions()) return null;

    return await location.getLocation();
  }

  BehaviorSubject<LocationData> _locationController = BehaviorSubject();
  ValueObservable<LocationData> get outLocation => _locationController;
  Stream<LocationData> _outerLocation() {
    return Observable.fromFuture(_checkPermissions()).asyncExpand((result) {
      if (!result) return null;
      return location.onLocationChanged();
    });
  }

  RepositoryBloc({
    @required SharedPreferences sharedPreferences,
    @required TranslatorSkeleton translatorSkeleton,
    @required SpSkeleton spSkeleton,
  }) : super(
          sharedPreferences: sharedPreferences,
          translatorSkeleton: translatorSkeleton,
          spSkeleton: spSkeleton,
        ) {
    _pocket.putAndGet(_locationController).pipeSource(_outerLocation);
  }
  factory RepositoryBloc.init(RepositoryBloc bloc) => BlocProvider.init<RepositoryBloc>(bloc);
  factory RepositoryBloc.of() => BlocProvider.of<RepositoryBloc>();
}

enum Flavour { client, restaurateur }
