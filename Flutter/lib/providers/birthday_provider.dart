import 'package:flutter/material.dart';
import 'package:helpbuddy/data/birthday_storage.dart';
import 'package:helpbuddy/models/birthday.dart';
import 'package:helpbuddy/services/notification_service.dart';
import 'package:uuid/uuid.dart';

class BirthdayProvider extends ChangeNotifier {
  final _storage = BirthdayStorage();
  final List<Birthday> _items = [];
  final _uuid = const Uuid();

  List<Birthday> get items => List.unmodifiable(_items);

  BirthdayProvider() {
    load();
  }

  Future<void> load() async {
    final loaded = await _storage.loadBirthdays();
    _items.clear();
    _items.addAll(loaded);
    notifyListeners();
  }

  Future<void> addBirthday(
    String name,
    DateTime date, {
    String? note,
    int remindDaysBefore = 0,
  }) async {
    final b = Birthday(
      id: _uuid.v4(),
      name: name,
      date: date,
      note: note,
      remindDaysBefore: remindDaysBefore,
    );
    _items.add(b);
    await _storage.saveBirthdays(_items);

    // schedule notification
    final scheduled = _calculateNotificationDate(b);
    await NotificationService.scheduleNotification(
      id: b.id.hashCode,
      title: '🎉 Birthday Reminder',
      body: "It's ${b.name}'s birthday!",
      scheduledDate: scheduled,
    );

    notifyListeners();
  }

  Future<void> deleteBirthday(String id) async {
    _items.removeWhere((b) => b.id == id);
    await _storage.saveBirthdays(_items);
    await NotificationService.cancelNotification(id.hashCode);
    notifyListeners();
  }

  DateTime _calculateNotificationDate(Birthday b) {
    final now = DateTime.now();
    // birthday's next instance (this year or next year)
    var year = now.year;
    var candidate = DateTime(year, b.date.month, b.date.day, 8, 0); // 8:00 AM
    if (candidate.isBefore(now)) {
      candidate = DateTime(year + 1, b.date.month, b.date.day, 8, 0);
    }
    if (b.remindDaysBefore > 0) {
      candidate = candidate.subtract(Duration(days: b.remindDaysBefore));
    }
    return candidate;
  }
}
