import 'package:code/src/models/provider/theme.dart';
import 'package:code/src/models/view_model/terminal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TerminalScreen extends StatefulWidget {
  @override
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  TerminalController controller;
  TextEditingController _commandController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commandController = TextEditingController();
    Provider.of<TerminalController>(context, listen: false).start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<TerminalController>(context);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle consoleText = ThemeProvider.monospaceTextStyle.merge(
      TextStyle(color: Colors.white),
    );

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('Terminal'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            // fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              // To make child scrollable
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(width: 1500),
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: controller.outputs.length,
                    itemBuilder: (context, i) {
                      var result =
                          controller.outputs[controller.outputs.length - 1 - i];
                      return Text(
                        result.toString(),
                        style: consoleText,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          TextField(
            controller: _commandController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: consoleText,
            decoration: InputDecoration(
                hintText: 'Enter commands here',
                hintStyle: consoleText.apply(color: Colors.white70)),
            onSubmitted: (_) async {
              await controller.execute(_);
              _commandController.clear();
            },
          ),
        ],
      ),
    );
  }
}
