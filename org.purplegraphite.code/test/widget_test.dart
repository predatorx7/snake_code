import 'dart:convert';
import 'dart:io';

import 'package:code/src/utils/checksum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void prepareCollisionTestFiles(File file, String message) {
  if (!file.existsSync()) {
    file.createSync();
  }
  file.writeAsStringSync(
    message,
    mode: FileMode.writeOnly,
    encoding: utf8,
  );
}

void main() {
  group('File tests for collision', () {
    String currentDirectory;
    String test1Path;
    String test2Path;
    File test1, test2;
    setUp(() {
      currentDirectory = Directory.current.path;
      test1Path = path.join(currentDirectory, 'test1.txt');
      test2Path = path.join(currentDirectory, 'test2.txt');
      test1 = File(test1Path);
      test2 = File(test2Path);
      prepareCollisionTestFiles(test1, 'This is message 1');
      prepareCollisionTestFiles(test2, 'It\'s message 2');
    });
    test('by comparing a file\'s checksum with itself', () async {
      final String reason =
          'Checksums of same file (calculated twice) do not match!';
      final String digest1 = await Checksum.getDigest(test1);
      final String digest2 = await Checksum.getDigest(test1);
      expect(digest1, digest2, reason: reason);
      final String digest3 = Checksum.getDigestSync(test1);
      final String digest4 = Checksum.getDigestSync(test1);
      expect(digest3, digest4, reason: reason);
    });
    test('by comparing a file\'s checksum with other file\'s checksum',
        () async {
      final String reason = 'Checksums of both file matches!';
      final String digest1 = await Checksum.getDigest(test1);
      final String digest2 = await Checksum.getDigest(test2);
      expect(digest1 != digest2, true, reason: reason);
      expect(digest1 == digest2, false, reason: reason);
      final String digest3 = Checksum.getDigestSync(test1);
      final String digest4 = Checksum.getDigestSync(test2);
      expect(digest3 != digest4, true, reason: reason);
      expect(digest3 == digest4, false, reason: reason);
    });
    tearDown(() {
      test1.delete();
      test2.delete();
    });
  });
}
