import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

typedef void ImageResult(File file);


void showInputImageDialog({
  @required BuildContext context,
  @required ImageResult outImageFile,
}) => showDialog(
  context: context,
  builder: (_context) {
    return AlertDialog(
      title: Text('Acquisisci una foto'),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            outImageFile(await ImagePicker.pickImage(source: ImageSource.camera));
          },
          child: Text('Fotocamera'),
        ),
        FlatButton(
          onPressed: () async {
            outImageFile(await ImagePicker.pickImage(source: ImageSource.gallery));
          },
          child: Text('Galleria'),
        ),
      ],
    );
  }
);


class ImageInputField extends StatelessWidget {
  final ImageResult outImageFile;
  final Widget child;

  const ImageInputField({Key key,
    @required this.outImageFile,
    @required this.child,
  }) : assert(outImageFile != null), assert(child != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showInputImageDialog(
          context: context,
          outImageFile: outImageFile,
        );
      },
      child: child,
    );
  }
}



class ImageInputFieldBlank extends StatelessWidget {
  final ImageResult outImageFile;

  const ImageInputFieldBlank({Key key, @required this.outImageFile}) : super(key: key);

  void _imagePicking(ImageSource source) async {
    outImageFile(await ImagePicker.pickImage(source: source));
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      padding: const EdgeInsets.all(0.0),
      strokeWidth: 2.0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    iconSize: 36,
                    onPressed: () => _imagePicking(ImageSource.camera),
                    icon: Icon(Icons.add_a_photo),
                  ),
                  IconButton(
                    iconSize: 36,
                    onPressed: () => _imagePicking(ImageSource.gallery),
                    icon: Icon(Icons.add_photo_alternate),
                  ),
                ],
              ),
              Text("Scatta una foto oppure prendila dalla galleria", textAlign: TextAlign.center,),
            ],
          ),
      ),
    );
  }
}

class ImageFieldBe extends StatefulWidget {
  final ImageResult outImageFile;

  const ImageFieldBe({Key key, @required this.outImageFile}) : super(key: key);
  @override
  _ImageFieldBeState createState() => _ImageFieldBeState();
}

class _ImageFieldBeState extends State<ImageFieldBe> {
  File image;

  imageFile(File file) {
    setState(() {
      image = file;
    });
    widget.outImageFile(file);
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return ImageInputFieldBlank(
        outImageFile: imageFile,
      );
    }
    return Image.file(image);
  }
}

final onlyText = WhitelistingTextInputFormatter(RegExp('[a-zA-Z ]'));

final onlyNumber = WhitelistingTextInputFormatter(RegExp('[0-9]'));

final onlyEmail = WhitelistingTextInputFormatter(RegExp('[a-zA-Z.@]'));

class TextFormatterControl extends TextEditingController {
  TextFormatterControl({String num, List<TextInputFormatter> formatters}) : super(
      text: num != null ? '$num' : null,
  ) {
    this.addListener(() {
      var textVal = this.value;
      formatters.forEach((formatter) => textVal = formatter.formatEditUpdate(null, textVal));
      if (textVal.text != text) {
        this.value = textVal;
      }
    });
  }
}



typedef Widget InputFieldBuilder(bool isEnable, TextEditingController textControl);

class InputFieldBackEnd extends StatefulWidget {
  final Widget title;
  final InputFieldBuilder inputFieldBuilder;
  final ValueChanged<String> onSave;

  const InputFieldBackEnd({Key key,
    @required this.title, @required this.inputFieldBuilder, this.onSave,
  }) : super(key: key);

  @override
  _InputFieldBackEndState createState() => _InputFieldBackEndState();
}

class _InputFieldBackEndState extends State<InputFieldBackEnd> {
  bool _isDisplayMode;
  TextEditingController _textControl;
  String _initText;

  @override
  void dispose() {
    _textControl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDisplayMode = true;
    _textControl?.dispose();
    _textControl = null;
    _textControl = TextEditingController();
  }

  void _enableEditMode() => setState(() {
    _isDisplayMode = false;
    _initText = _textControl.text;
  });

  void _cancelEditMode() => setState(() {
    _isDisplayMode = true;
    _textControl.text = _initText;
  });

  void _onSave() {
    setState(() {
      _isDisplayMode = true;
    });
    widget.onSave(_textControl.text);
  }

  @override
  Widget build(BuildContext context) {
    Widget suffixIcon;
    if (_isDisplayMode) {
      suffixIcon = InkWell(
        child: Icon(Icons.edit),
        onTap: _enableEditMode,
      );
    } else {
      suffixIcon = IconButton(
        icon: Icon(Icons.save),
        onPressed: _onSave,
      );
    }
    final List<Widget> titleAndButtons = <Widget> [
      Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.title,
      )),
      suffixIcon,
    ];
    if (!_isDisplayMode) titleAndButtons.insert(0,
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: _cancelEditMode,
      ),
    );

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleAndButtons,
        ),
        widget.inputFieldBuilder(!_isDisplayMode, _textControl),
      ],
    );
  }
}

/*TextField(
          enabled: !_isDisplayMode,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          textInputAction: TextInputAction.newline,
          controller: _textControl,
          decoration: InputDecoration(
            errorText: widget.errorText,
            border: OutlineInputBorder(),
          ),
        ),*/