import 'dart:async';
import 'dart:io';

import 'package:code/src/models/plain_model/entity.dart';
import 'package:code/src/utils/logman.dart';
import 'package:code/src/utils/permissions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static const String _prb = '/storage/emulated/0';
  static Uri _pru = Uri.file(_prb);
  static Directory primaryRoot = Directory.fromUri(_pru);

  static Future<List<Entity>> _dirContents(Directory dir) {
    var files = <Entity>[];
    var completer = new Completer<List<Entity>>();
    var lister = dir.list(recursive: false);
    lister.listen(
      (file) async {
        var x = Entity(file);
        await x.updateStatus();
        files.add(x);
      },
      // should also register onError
      onDone: () => completer.complete(files),
    );
    return completer.future;
  }

  /// Get a new temporary workspace. This does not create the temporary directory.
  ///
  /// Create the directory with [createDirectory].
  static Future<Directory> getTemporaryWorkspace() async {
    var _docdir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> _docdirls = _docdir.listSync();
    String tempPath =
        p.join(_docdir.path, 'workspace', 'workspace_${_docdirls.length}');
    logman.d('A possible temporary workspace path can be $tempPath');
    var _tempWDir = Directory(tempPath);
    return _tempWDir;
  }

  static Future<Directory> createDirectory(Directory directory) async {
    return await directory.create(recursive: true);
  }

  static Future<List<Entity>> listEntities(Directory path) async {
    var _c = await _dirContents(path);
    _c.sort();
    return _c;
  }

  static void checkPerms() async {
    await Perms.ask();
  }
}
