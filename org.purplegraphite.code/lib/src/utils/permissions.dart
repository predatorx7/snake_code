import 'dart:io';

import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Perms {
  static Map<Permission, PermissionStatus> requestedResult;
  static final Permission _storageAccessPerm = Permission.storage;

  // TODO: make a dialog to describe why we need permission
  /// Requests permissions only once. Strictly requires user to accept, on denial will exit the app.
  static Future<bool> askOnce() async {
    WidgetsFlutterBinding.ensureInitialized();
    var status = await _storageAccessPerm.status;
    if (status.isUndetermined) {
      // We didn't ask for permission yet.
      await ask();
    }
    // async completed
    return true;
  }

  static Future<void> ask() async {
    //Requesting multiple permissions at once.
    requestedResult = await [_storageAccessPerm].request();
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

  static Future<void> recheck(Permission perm) async {
    // Re-checking & Re-requesting
    if (!(await perm.request().isGranted)) {
      // Exit App
      await SystemNavigator.pop(animated: true);
      exit(1);
    }
  }
}
