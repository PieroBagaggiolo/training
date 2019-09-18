import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';
import 'package:resmedia_already_at_the_table/simulation.dart';

class ProductView extends StatelessWidget {
  final ProductModel model;

  final Widget counter;

  ProductView({Key key, @required this.model, this.counter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return SizedBox(
      height: 128.0,
      child: Layout.horizontal(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 8.0),
        children: [
          Layout.vertical(
            expanded: true,
            children: [
              Text(
                '${model.title}',
                style: tt.subhead,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (model.description != null)
                Text(
                  '${model.description}',
                  style: tt.body1.copyWith(color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              PriceView(
                model.price,
                style: tt.body2,
              ),
            ],
            padding: const EdgeInsets.only(right: 16.0),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Sm().isSimulation
                ? Image.asset(
                    model.img,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: model.img,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: const CircularProgressIndicator(),
                    ),
                    cacheManager: CacheManager.twoDay(),
                  ),
          ),
        ],
      ),
    );
  }
}
