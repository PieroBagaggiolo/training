import 'package:flutter/material.dart';


class NewProductVoidOwner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Premi per aggiungere un nuvo prodotto alla categoria",
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                Icons.image,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
