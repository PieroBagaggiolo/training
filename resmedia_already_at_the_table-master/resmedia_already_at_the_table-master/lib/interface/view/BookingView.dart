import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';

class BookingCardView extends StatelessWidget {
  final TableModel model;

  const BookingCardView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Layout.vertical(
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: const EdgeInsets.all(12.0),
        separator: const SizedBox(height: 12.0),
        children: [
          Text(
            model.titleRestaurant.text,
            style: theme.textTheme.title,
          ),
          Text(
            model.title,
            style: theme.textTheme.body2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 6.0),
                  Text(
                    DateTimeUtility.toDate(model.dateTime, separator: '/'),
                    style: theme.textTheme.subtitle,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.access_time),
                  const SizedBox(width: 6.0),
                  Text(
                    DateTimeUtility.toTime(model.dateTime, second: false),
                    style: theme.textTheme.subtitle,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.people),
                  const SizedBox(width: 6.0),
                  Text(
                    "${model.countChairs}",
                    style: theme.textTheme.subtitle,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
