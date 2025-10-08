class Birthday {
  final String id;
  final String name;
  final DateTime date; // full date; year can be used for age
  final String? note;
  final int remindDaysBefore; // 0 = on day, 1 = one day before

  Birthday({
    required this.id,
    required this.name,
    required this.date,
    this.note,
    this.remindDaysBefore = 0,
  });

  factory Birthday.fromJson(Map<String, dynamic> json) => Birthday(
    id: json['id'],
    name: json['name'],
    date: DateTime.parse(json['date']),
    note: json['note'],
    remindDaysBefore: json['remindDaysBefore'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date': date.toIso8601String(),
    'note': note,
    'remindDaysBefore': remindDaysBefore,
  };
}
