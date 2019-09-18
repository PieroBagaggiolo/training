import 'package:flutter/foundation.dart';

class InvitationData {
  static const String _restaurantId = 'restaurantId', _tableId = 'tableId';

  final String restaurantId;
  final String tableId;

  InvitationData({
    @required this.restaurantId,
    @required this.tableId,
  })  : assert(restaurantId != null),
        assert(tableId != null);

  Uri toUri() {
    return Uri.https(
      "giaatavola.it",
      "invitation",
      toQueryData(),
    );
  }

  factory InvitationData.fromUri(Uri uri) {
    return InvitationData.fromQueryData(uri.queryParameters);
  }

  factory InvitationData.fromQueryData(Map<String, String> json) {
    return InvitationData(
      restaurantId: json[_restaurantId],
      tableId: json[_tableId],
    );
  }
  Map<String, String> toQueryData() {
    return {
      _restaurantId: restaurantId,
      _tableId: tableId,
    };
  }

  @override
  String toString() => "InvitationUriData(${toQueryData()})";
}
