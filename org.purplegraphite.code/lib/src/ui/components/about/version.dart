import 'package:flutter/material.dart';

class Version extends StatelessWidget {
  final String version;
  const Version({Key key, this.version}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color textColor = (Theme.of(context).brightness == Brightness.dark)
        ? Colors.white
        : Colors.black;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'version ',
        style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.green),
        children: [
          TextSpan(
            text: version,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontStyle: FontStyle.italic, color: textColor),
          ),
        ],
      ),
    );
  }
}
