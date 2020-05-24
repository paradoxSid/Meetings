import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:meetings/models/models.dart';
import 'package:meetings/service/storage/istorage_service.dart';

/// This service maintains file for the stored user
class StoredUserService extends IStorageService<User> {
  StoredUserService() : super('user.json');

  @override
  Future<User> readFile() async {
    try {
      final file = await localFile;
      User user = User.fromJson(json.decode(await file.readAsString()));

      return user;
    } catch (e) {
      // Probably a FileSystemException exception
      print(e);
      return null;
    }
  }

  Future<File> writeToFile(User user) async {
    final file = await localFile;
    return file.writeAsString(json.encode(user));
  }

  Future<bool> deleteFile() async {
    final file = await localFile;
    var fileSystemEntity = await file.delete();
    return await fileSystemEntity.exists();
  }
}
