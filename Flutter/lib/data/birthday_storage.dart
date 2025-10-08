import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/birthday.dart';

class BirthdayStorage {
  static const _fileName = 'birthdays.json';

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!await file.exists()) await file.create(recursive: true);
    return file;
  }

  Future<List<Birthday>> loadBirthdays() async {
    try {
      final file = await _getLocalFile();
      final contents = await file.readAsString();
      if (contents.isEmpty) return [];
      final List data = jsonDecode(contents);
      return data.map((e) => Birthday.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveBirthdays(List<Birthday> birthdays) async {
    final file = await _getLocalFile();
    final jsonData = birthdays.map((b) => b.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }
}
