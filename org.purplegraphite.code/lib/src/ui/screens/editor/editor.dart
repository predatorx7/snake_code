import 'dart:io';

import 'package:creamy_field/creamy_field.dart';
import 'package:flutter/material.dart';

import '../../../models/plain_model/entity.dart';
import '../../../utils/logman.dart';

class EditorScreen extends StatefulWidget {
  

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  RestorableCreamyEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = RestorableCreamyEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreamyField(),
    );
  }
}
