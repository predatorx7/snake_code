import 'package:flutter/material.dart';

class _Consts {
  _Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

Future<dynamic> showMessage(BuildContext context) {
  return showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) => CustomDialog(
      title: "Success",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      buttonText: "Okay",
    ),
  );
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

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
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
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
            backgroundColor: Colors.blueAccent,
            radius: _Consts.avatarRadius,
          ),
        ),
      ],
    );
  }

  CustomDialog({
    @required this.title,
    @required this.description,
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
