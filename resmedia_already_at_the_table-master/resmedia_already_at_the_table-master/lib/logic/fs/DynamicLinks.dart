import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FbDynamicLinks {
  FirebaseDynamicLinks get fbDl => FirebaseDynamicLinks.instance;

  AsyncValueSetter<PendingDynamicLinkData> _onLink;

  Future<void> _linkListener(PendingDynamicLinkData dynamicLink) async {
    if (dynamicLink == null) return;
    if (_onLink != null) await _onLink(dynamicLink);
  }

  void onLink(ValueChanged<PendingDynamicLinkData> onLink) {
    print("...........................................................");
    if (_onLink == null) {
      print("...........................................................");
      fbDl.getInitialLink().then(_linkListener);

      fbDl.onLink(
        onSuccess: _linkListener,
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        },
      );
    }
    _onLink = onLink;
  }
}
