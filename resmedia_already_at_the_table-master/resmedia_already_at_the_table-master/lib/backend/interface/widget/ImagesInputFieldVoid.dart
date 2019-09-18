import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/widget/backend_input.dart';


class ImagesInputFieldVoid extends StatelessWidget {
  final double space;
  final int itemCount;
  final ImageResult outImageFile;
  final IndexedWidgetBuilder builder;

  const ImagesInputFieldVoid({Key key,
    this.space: 8.0,
    @required this.itemCount,
    @required this.outImageFile,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (itemCount == 0)
      return Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: ImageInputFieldBlank(
            outImageFile: outImageFile,
          ),
        ),
      );

    return ListViewSeparated.builder(
      separator: SizedBox(width: space,),
      padding: const EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (_context, index) {
        if (index < itemCount)
          return builder(_context, index);
        return AspectRatio(
          aspectRatio: 1,
          child: ImageInputFieldBlank(
            outImageFile: outImageFile,
          ),
        );
      },
    );
  }
}
