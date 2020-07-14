import 'dart:io';
import 'package:crypto/crypto.dart';

/// This can be used to compute a sha256 hash checksum function on bytes & files.
class Checksum {
  /// This class must not have an instance
  Checksum._();

  static String getBytesDigest(List<int> bytes) {
    Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Asynchronously returns file's checksum digest as String
  static Future<String> getDigest(File file) async {
    return getBytesDigest(await file.readAsBytes());
  }

  /// Synchronously returns file's checksum digest as String
  static String getDigestSync(File file) {
    return getBytesDigest(file.readAsBytesSync());
  }
}
