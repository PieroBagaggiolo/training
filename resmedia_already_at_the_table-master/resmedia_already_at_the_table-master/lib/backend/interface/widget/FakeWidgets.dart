import 'dart:io';

import 'package:flutter/material.dart';

import 'ImagesInputFieldVoid.dart';
import 'backend_input.dart';


class FakeStore<V> {
  V value;
  FakeStore(this.value);
}


class FakeImagesInputField extends StatefulWidget {
  final List<ImageProvider> images;

  FakeImagesInputField._({Key key, @required this.images}) : assert(images != null), super(key: key);

  factory FakeImagesInputField({Key key, List<ImageProvider> images}) {
    return FakeImagesInputField._(key: key, images: images??[]);
  }

  factory FakeImagesInputField.assets({Key key, List<String> images}) {
    final List<ImageProvider> files = images == null ? [] : images.map((img) => AssetImage(img)).toList();
    return FakeImagesInputField._(key: key, images: files);
  }

  @override
  _FakeImagesInputFieldState createState() => _FakeImagesInputFieldState();
}

class _FakeImagesInputFieldState extends State<FakeImagesInputField> {
  void _addImageFile(File image) => setState(() {
    widget.images.add(FileImage(image));
  });

  @override
  Widget build(BuildContext context) {
    return ImagesInputFieldVoid(
      itemCount: widget.images.length,
      outImageFile: _addImageFile,
      builder: (_context, index) {
        return Image(image: widget.images[index], fit: BoxFit.fitHeight,);
      },
    );
  }
}


class FakeStoreFile extends FakeStore<ImageProvider> {
  FakeStoreFile({ImageProvider img}) : super(img);
}


class FakeImageInputField extends StatefulWidget {
  final FakeStoreFile store;

  FakeImageInputField._({Key key, @required this.store}) :
        assert(store != null), super(key: key);

  factory FakeImageInputField({Key key, ImageProvider img}) {
    return FakeImageInputField._(key: key, store: FakeStoreFile(img: img));
  }

  factory FakeImageInputField.assets({Key key, String img}) {
    return FakeImageInputField(key: key, img: img == null ? null : AssetImage(img));
  }

  @override
  _FakeImageInputFieldState createState() => _FakeImageInputFieldState();
}

class _FakeImageInputFieldState extends State<FakeImageInputField> {
  void _setImageFile(File image) => setState(() {
    widget.store.value = FileImage(image);
  });

  @override
  Widget build(BuildContext context) {
    if (widget.store.value == null)
      return ImageInputFieldBlank(
        outImageFile: _setImageFile,
      );
    return ImageInputField(
      outImageFile: _setImageFile,
      child: Image(image: widget.store.value),
    );
  }
}


class FakeStoreBool extends FakeStore<bool> {
  FakeStoreBool({bool value: false}) : super(value??false);
}

class FakeSwitch extends StatefulWidget {
  final Color color;
  final FakeStoreBool store;

  FakeSwitch._({Key key, @required this.store, this.color,}) :
        assert(store != null), super(key: key);

  factory FakeSwitch({Key key, bool value, Color color}) {
    return FakeSwitch._(key: key, store: FakeStoreBool(value: value), color: color,);
  }

  @override
  _FakeSwitchState createState() => _FakeSwitchState();
}

class _FakeSwitchState extends State<FakeSwitch> {
  void _updateValue(bool value) => setState(() {
    widget.store.value = value;
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: widget.color,
      onChanged: _updateValue,
      value: widget.store.value,
    );
  }
}
