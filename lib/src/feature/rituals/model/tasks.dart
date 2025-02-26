// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskCatalog {
  final String id;
  final String title;
  final DateTime? dueDate; 
  final DateTime? finishDate;
  final bool isPeriodic;
  final int periodicityDays;
  final int daysToComplete;

  // Чтобы сохранить исходное "кол-во дней", можно хранить его отдельно, если нужно
  // Но обычно достаточно вычислить dueDate при создании объекта
  TaskCatalog({
    required this.id,
    required this.title,
    this.dueDate,
    this.finishDate,
    required this.isPeriodic,
    required this.periodicityDays,
    required this.daysToComplete,
  });

  factory TaskCatalog.fromMap(Map<String, dynamic> map) {
    return TaskCatalog(
      id: map['id'] as String,
      title: map['title'] as String,
      daysToComplete: map['daysToComplete'] as int,
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int)
          : DateTime.now().add(Duration(days: map['daysToComplete'] as int)),
      finishDate: map['finishDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['finishDate'] as int)
          : null,
      isPeriodic: map['isPeriodic'] as bool,
      periodicityDays: map['periodicityDays'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'finishDate': finishDate?.millisecondsSinceEpoch,
      'daysToComplete': daysToComplete,
      'isPeriodic': isPeriodic,
      'periodicityDays': periodicityDays,
    };
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    // Если задача уже завершена
    if (finishDate != null) return false;
    // Просрочена ли задача к текущему моменту
    return DateTime.now().isAfter(dueDate!);
  }

  TaskCatalog completeTask() {
    return copyWith(finishDate: DateTime.now());
  }

  TaskCatalog copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    DateTime? finishDate,
    int? daysToComplete,
    bool? isPeriodic,
    int? periodicityDays,
  }) {
    return TaskCatalog(
      id: id ?? this.id,
      title: title ?? this.title,
      daysToComplete: daysToComplete ?? this.daysToComplete,
      dueDate: dueDate ?? this.dueDate,
      finishDate: finishDate ?? this.finishDate,
      isPeriodic: isPeriodic ?? this.isPeriodic,
      periodicityDays: periodicityDays ?? this.periodicityDays,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskCatalog.fromJson(String source) =>
      TaskCatalog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskCatalog(id: $id, title: $title, dueDate: $dueDate, finishDate: $finishDate, isPeriodic: $isPeriodic, periodicityDays: $periodicityDays)';
  }

  @override
  bool operator ==(covariant TaskCatalog other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.dueDate == dueDate &&
      other.finishDate == finishDate &&
      other.isPeriodic == isPeriodic &&
      other.periodicityDays == periodicityDays &&
      other.daysToComplete == daysToComplete;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      dueDate.hashCode ^
      finishDate.hashCode ^
      isPeriodic.hashCode ^
      periodicityDays.hashCode ^
      daysToComplete.hashCode;
  }
}
