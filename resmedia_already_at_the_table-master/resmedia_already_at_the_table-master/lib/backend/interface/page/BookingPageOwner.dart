import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';


class BookingPageOwner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListViewSeparated(
      padding: const EdgeInsets.all(SPACE),
      separator: const Divider(color: Colors.grey, height: 32.0,),
      children: <Widget>[
        BookingTableView(
          datetime: "2019-06-21 12:30:00",
          nameTable: "Pietro",
          numSeats: 4,
        ),
        OrderTableView(
          datetime: "2019-06-21 12:45:00",
          nameTable: "Francesca",
          numSeats: 2,
          orders: [
            OrderModel(
              titleProduct: "Ravioli di Pesce",
              moreInfo: null,
            ),
            OrderModel(
              titleProduct: "Spaghetti tutto mare",
              moreInfo: "Ben cotti",
            ),
          ],
        ),
        BookingTableView(
          datetime: "2019-06-21 13:10:00",
          nameTable: "Compleanno Nonna Pietra",
          numSeats: 10,
        ),
        OrderTableView(
          datetime: "2019-06-21 12:30:00",
          nameTable: "Gianluca",
          numSeats: 3,
          orders: [
            OrderModel(
              titleProduct: "Filetto di Manzo",
              moreInfo: "Al sangue",
            ),
            OrderModel(
              titleProduct: "Spaghetti al Ragu",
              moreInfo: null,
            ),
            OrderModel(
              titleProduct: "Verdure Fritte",
              moreInfo: null,
            ),
          ],
        ),
      ],
    );
  }
}


class BookingTableView extends StatelessWidget {
  final String datetime, nameTable;
  final int numSeats;

  const BookingTableView({Key key,
    @required this.datetime, @required this.nameTable, @required this.numSeats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BookingTableVoid(
      datetime: Text(datetime),
      nameTable: Text(nameTable),
      numSeats: Text("$numSeats"),
    );
  }
}



class BookingTableVoid extends StatelessWidget {
  final Widget datetime, nameTable, numSeats;

  const BookingTableVoid({Key key,
    @required this.datetime, @required this.nameTable, @required this.numSeats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: DefaultTextStyle(
            style: tt.subtitle,
            child: datetime,
          ),
        ),
        ListTile(
          title: DefaultTextStyle(
            style: tt.title,
            child: nameTable,
          ),
          trailing: DefaultTextStyle(
            style: tt.headline,
            child: numSeats,
          ),
        ),
      ],
    );
  }
}


class OrderModel {
  final String titleProduct, moreInfo;
  OrderModel({@required this.titleProduct, @required this.moreInfo});
}


class OrderTableView extends StatelessWidget {
  final String datetime, nameTable;
  final int numSeats;
  final List<OrderModel> orders;

  const OrderTableView({Key key,
    @required this.datetime, @required this.nameTable, @required this.numSeats,
    @required this.orders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderTableVoid(
      bookingTable: BookingTableView(
        datetime: datetime, nameTable: nameTable, numSeats: numSeats,
      ),
      children: orders.map<Widget>((order) {
        return ProductOrderingView(model: order,);
      }).toList(),
    );
  }
}


class OrderTableVoid extends StatelessWidget {
  final Widget bookingTable;
  final List<Widget> children;

  const OrderTableVoid({Key key,
    @required this.bookingTable, @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        bookingTable,
        ExpansionTile(
          title: Text("Informazioni sui Piatti", style: tt.body1,),
          children: children.map((child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
              child: child,
            );
          }).toList(),
        ),
      ],
    );
  }
}


class ProductOrderingView extends StatelessWidget {
  final OrderModel model;

  const ProductOrderingView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ProductOrderingVoid(
      titleProduct: Text(model.titleProduct),
      info: model.moreInfo == null ? null : Text(model.moreInfo),
    );
  }
}



class ProductOrderingVoid extends StatelessWidget {
  final Widget titleProduct, info;

  const ProductOrderingVoid({Key key,
    @required this.titleProduct, @required this.info,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    final children = [DefaultTextStyle(
      style: tt.body2,
      child: titleProduct,
    )];
    if (info != null)
      children.add(DefaultTextStyle(
        style: tt.caption,
        child: info,
      ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
