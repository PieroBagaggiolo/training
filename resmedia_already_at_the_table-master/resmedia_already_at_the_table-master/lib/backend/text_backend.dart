import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/backend.dart';


class TextBackEnd extends StatelessWidget {
  final String title;
  final ValueChanged<String> onSave;
  final Text child;

  const TextBackEnd({Key key, this.title, @required this.onSave, @required this.child}) : super(key: key);

  void _openEditScreen(BuildContext context) {
    //EasyRouter.push(context, _TextEditScreen(title: title, onSave: onSave, text: child, ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () => _openEditScreen(context),
      child: child,
    );
  }
}

class _TextEditScreen extends StatefulWidget {
  final String title;
  final ValueChanged<String> onSave;
  final Text text;

  const _TextEditScreen({Key key, this.title, @required this.onSave, @required this.text, }) : super(key: key);

  @override
  __TextEditScreenState createState() => __TextEditScreenState();
}

class __TextEditScreenState extends State<_TextEditScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text.data);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSave() {
    widget.onSave(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return EditScreen(
      title: widget.title,
      onSave: onSave,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: 10,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Please enter new Text'
          ),
        ),
      ),
    );
  }
}



