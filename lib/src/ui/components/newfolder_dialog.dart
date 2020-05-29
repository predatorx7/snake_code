import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class _Consts {
  _Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 40.0;
}

Future<dynamic> newFolderDialog(BuildContext context,
    void Function(TextEditingController controller) onButtonPress) {
  return showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) => CustomDialog(
      title: "Enter folder name",
      buttonText: "Create",
      onPressed: onButtonPress,
    ),
  );
}

class CustomDialog extends StatelessWidget {
  final String title, buttonText;
  final Image image;
  final void Function(TextEditingController controller) onPressed;
  final TextEditingController controller = TextEditingController();
  Widget dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: EdgeInsets.only(
            top: _Consts.avatarRadius + _Consts.padding,
            bottom: _Consts.padding,
            left: _Consts.padding,
            right: _Consts.padding,
          ),
          margin: EdgeInsets.only(top: _Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(_Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    onPressed(controller);
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        //...top circlular image part,
        Positioned(
          left: _Consts.padding,
          right: _Consts.padding,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            radius: _Consts.avatarRadius,
            child: Icon(
              EvaIcons.folderAddOutline,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  CustomDialog({
    @required this.title,
    @required this.onPressed,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
