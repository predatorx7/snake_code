import 'dart:async';
import 'dart:io';

import 'package:code/src/models/plain_model/entity.dart';
import 'package:code/src/utils/permissions.dart';

class FileUtils {
  static const String _emulatedSdcardRoot = '/storage/emulated/0';

  static Uri _sdcardRootURI = Uri.file(_emulatedSdcardRoot);

  static Directory primaryRoot = Directory.fromUri(_sdcardRootURI);

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
