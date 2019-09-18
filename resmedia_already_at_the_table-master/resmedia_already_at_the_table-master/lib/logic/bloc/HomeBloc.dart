import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/RestaurantRepository.dart';
import 'package:resmedia_already_at_the_table/model/dynamicLink/InvitationUriData.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends SkeletonValues<RestaurantModel> {
  UserBloc _userBloc = UserBloc.of();
  RepositoryBloc _repositoryBloc = RepositoryBloc.of();

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }

  Future<void> _onLink(PendingDynamicLinkData linkData) async {
    final data = InvitationData.fromUri(linkData.link);
    _eventController.add(ReceiveInvitationEvent(invitation: data));
    await _repositoryBloc.cloudFunctions.joinInTheTable(
      restaurantId: data.restaurantId,
      tableId: data.tableId,
      userNominative: _userBloc.userBone.user.nominative,
    );
    _eventController.add(JoinInTheTableEvent(invitation: data));
  }

  PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  HomeBloc() : super() {
    pocket.pipeStream(RestaurantCl().outBasilAndMondial());
    _repositoryBloc.dynamicLinks.onLink(_onLink);
//    _pointSubscription = UserBloc.of().outPoint.listen((point) {
//      pocket.pipeStream(RestaurantCl().outerSearchByPosition(point: point));
//    });
  }

  static HomeBloc init(HomeBloc bloc) => BlocProvider.init(bloc);
  factory HomeBloc.of() => BlocProvider.of<HomeBloc>();
  static void close() => BlocProvider.dispose<HomeBloc>();
}

class JoinInTheTableEvent extends Event {
  final InvitationData invitation;

  JoinInTheTableEvent({@required this.invitation});
}

class ReceiveInvitationEvent extends Event {
  final InvitationData invitation;

  ReceiveInvitationEvent({@required this.invitation});
}
