import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicationTitle extends StatelessWidget {
  final bool showDark;

  const ApplicationTitle({Key key, @required this.showDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Snake code',
      style: GoogleFonts.openSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: showDark ? Colors.black : Colors.white,
        letterSpacing: 0.15,
      ),
    );
  }
}
