import 'package:flutter/material.dart';

class PopupMenuTile extends PopupMenuEntry<dynamic> {
  final String value;
  final IconData leading;
  final Widget title;
  final Color color;
  final void Function() onTap;

  const PopupMenuTile({
    Key key,
    this.value,
    this.leading,
    this.title,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  _PopupMenuTileState createState() => _PopupMenuTileState();

  @override
  // TODO: implement height
  double get height => throw UnimplementedError();

  @override
  bool represents(dynamic value) {
    return true;
  }
}

class _PopupMenuTileState extends State<PopupMenuTile> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuItem<String>(
      key: ValueKey(widget.value),
      value: widget.value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8, left: 8),
            child: Icon(
              widget.leading,
              color: widget.color,
            ),
          ),
          widget.title,
        ],
      ),
    );
  }
}
