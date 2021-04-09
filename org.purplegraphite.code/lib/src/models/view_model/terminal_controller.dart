import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';

class ConsoleOutput {
  final String command;
  List<String> _outList = [];

  List<String> get outputs => _outList;

  List<String> _errList = [];

  List<String> get errors => _errList;

  Map<String, String> environment = {};
  ConsoleOutput(this.command);
  void addLog(Object object, {bool isError: false}) {
    if (isError) {
      _errList.add(object.toString());
    } else {
      _outList.add(object.toString());
    }
  }

  void updateEnv(Map<String, String> env) {
    environment = env;
  }

  String toString() {
    return '${errors.join()}\n${outputs.join()}';
  }
}

class TerminalController extends ChangeNotifier {
  Map<String, String> environment = {};
  // List<ConsoleOutput> _cache = [];
  List<ConsoleOutput> _outList = [];

  ConsoleOutput get lastConsoleLog {
    if (_outList.isEmpty) {
      return ConsoleOutput('');
    }
    return _outList.last;
  }

  List<ConsoleOutput> get outputs => _outList;
  final String prefix = '/data/data/org.basil.code';
  IOSink ios;
  Process _mainProcess;
  bool initialized = false;
  void ensureInitialized() {
    while (!initialized);
  }

  void start() async {
    var co = ConsoleOutput('sh -lva');
    _outList.add(co);
    _mainProcess = await Process.start(
      '/bin/sh',
      ['-ilva'],
      runInShell: true,
      environment: environment,
    ).then((result) {
      result.stdout.listen(comprehendStdout);
      result.stderr.listen(comprehendStderr);
      // result.stdin.addStream(result.stdout);
      return result;
    });
    ios = _mainProcess.stdin;
    initialized = true;
    co.updateEnv(environment);
    debug();
    notifyListeners();
    execute('cd $prefix');
    execute('clear');
  }

  void execute(String command) {
    if (command.contains('clear')) {
      // _cache = _outList;
      _outList = [];
      notifyListeners();
      return;
    }
    ensureInitialized();
    _outList.add(ConsoleOutput(command));
    ios.writeln(command);
    debug();
  }

  void debug() {
    print('Environment ${environment.keys.toList().join('\n')}');
    // print(_outList);
  }

  String decodeData(List<int> codeUnits) {
    // final lines = utf8.decoder.convert(codeUnits);
    // .bind(File(path).openRead())
    // .transform(const LineSplitter());
    return utf8.decode(codeUnits);
  }

  void comprehendStdout(List<int> data) {
    lastConsoleLog.addLog(decodeData(data));
    lastConsoleLog.updateEnv(environment);
    notifyListeners();
  }

  void comprehendStderr(List<int> error) {
    lastConsoleLog.addLog(decodeData(error), isError: true);
    lastConsoleLog.updateEnv(environment);
    notifyListeners();
  }

  void clean() {
    ensureInitialized();
    ios.flush();
    ios.close();
    _mainProcess.kill();
  }

  @override
  void dispose() {
    super.dispose();
    clean();
  }
}
