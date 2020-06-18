import 'dart:io';

import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Pint {
  Map<Permission, PermissionStatus> requestedResult;
  var storageAccessPerm = Permission.storage;

// TODO: make a dialog to describe why we need permission
  /// Asking permissions
  Future<bool> askOnce() async {
    WidgetsFlutterBinding.ensureInitialized();
    var status = await storageAccessPerm.status;
    if (status.isUndetermined) {
      // We didn't ask for permission yet.
      await ask();
    }
    // async completed
    return true;
  }

  Future<void> ask() async {
    //Requesting multiple permissions at once.
    requestedResult = await [storageAccessPerm].request();
    // Iterating map to check permissions
    requestedResult.forEach((perm, permStatus) async {
      if (await perm.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      } else {
        // Not granted, so opening settings
        openAppSettings();
      }
      await recheck(perm);
    });
  }

  Future<void> recheck(Permission perm) async {
    // Re-checking & Re-requesting
    if (!(await perm.request().isGranted)) {
      // Exit App
      await SystemNavigator.pop(animated: true);
      exit(1);
    }
  }
}
