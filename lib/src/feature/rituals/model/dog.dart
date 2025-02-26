// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:happy_dog_house/src/feature/rituals/model/gallery.dart';

import 'package:happy_dog_house/src/feature/rituals/model/tasks.dart';
import 'package:happy_dog_house/src/feature/rituals/model/vaccination.dart';

class Dog {
  final String id;
  final String name;
  final double size;
  final double weight;
  final int age;
  final String gender;
  final String breed;
  final String photo;
  final List<Gallery> gallery;
  final List<Vaccination> vaccinations;
  final List<TaskCatalog> tasks; // Текущие задания
  final List<TaskCatalog> taskHistory; // История заданий

  Dog({
    required this.id,
    required this.name,
    required this.size,
    required this.weight,
    required this.age,
    required this.gender,
    required this.breed,
    required this.photo,
    required this.gallery,
    required this.vaccinations,
    required this.tasks,
    required this.taskHistory,
  });

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'] as String,
      name: map['name'] as String,
      size: map['size'] as double,
      weight: map['weight'] as double,
      age: map['age'] as int,
      gender: map['gender'] as String,
      breed: map['breed'] as String,
      photo: map['photo'] as String,
      gallery: List<Gallery>.from(
        (map['gallery'] as List<dynamic>).map<Gallery>(
          (x) => Gallery.fromMap(x as Map<String, dynamic>),
        ),
      ),
      vaccinations: List<Vaccination>.from(
        (map['vaccinations'] as List<dynamic>).map<Vaccination>(
          (x) => Vaccination.fromMap(x as Map<String, dynamic>),
        ),
      ),
      tasks: List<TaskCatalog>.from(
        (map['tasks'] as List<dynamic>).map<TaskCatalog>(
          (x) => TaskCatalog.fromMap(x as Map<String, dynamic>),
        ),
      ),
      taskHistory: List<TaskCatalog>.from(
        (map['taskHistory'] as List<dynamic>).map<TaskCatalog>(
          (x) => TaskCatalog.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'size': size,
      'weight': weight,
      'age': age,
      'gender': gender,
      'breed': breed,
      'photo': photo,
      'gallery': gallery.map((x) => x.toMap()).toList(),
      'vaccinations': vaccinations.map((x) => x.toMap()).toList(),
      'tasks': tasks.map((x) => x.toMap()).toList(),
      'taskHistory': taskHistory.map((x) => x.toMap()).toList(),
    };
  }

  Dog copyWith({
    String? id,
    String? name,
    double? size,
    double? weight,
    int? age,
    String? gender,
    String? breed,
    String? photo,
    List<Gallery>? gallery,
    List<Vaccination>? vaccinations,
    List<TaskCatalog>? tasks,
    List<TaskCatalog>? taskHistory,
  }) {
    return Dog(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      breed: breed ?? this.breed,
      photo: photo ?? this.photo,
      gallery: gallery ?? this.gallery,
      vaccinations: vaccinations ?? this.vaccinations,
      tasks: tasks ?? this.tasks,
      taskHistory: taskHistory ?? this.taskHistory,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dog.fromJson(String source) =>
      Dog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Dog(id: $id, name: $name, size: $size, weight: $weight, age: $age, gender: $gender, breed: $breed, photo: $photo, gallery: $gallery, vaccinations: $vaccinations, tasks: $tasks, taskHistory: $taskHistory)';
  }

  @override
  bool operator ==(covariant Dog other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.size == size &&
        other.weight == weight &&
        other.age == age &&
        other.gender == gender &&
        other.breed == breed &&
        other.photo == photo &&
        listEquals(other.gallery, gallery) &&
        listEquals(other.vaccinations, vaccinations) &&
        listEquals(other.tasks, tasks) &&
        listEquals(other.taskHistory, taskHistory);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        size.hashCode ^
        weight.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        breed.hashCode ^
        photo.hashCode ^
        gallery.hashCode ^
        vaccinations.hashCode ^
        tasks.hashCode ^
        taskHistory.hashCode;
  }

  Dog completeTask(String taskId) {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index < 0) return this; // не нашли

    final updatedTask = tasks[index].completeTask();

    final updatedTasks = List<TaskCatalog>.from(tasks);
    updatedTasks.removeAt(index);

    final updatedHistory = List<TaskCatalog>.from(taskHistory)
      ..add(updatedTask);

    return copyWith(tasks: updatedTasks, taskHistory: updatedHistory);
  }

  Dog checkTask(String taskId) {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index < 0) {
      // Не нашли задачу - вернём текущий объект без изменений
      return this;
    }

    final oldTask = tasks[index];

    // Удалим её из текущего списка
    final updatedTasks = List<TaskCatalog>.from(tasks);
    updatedTasks.removeAt(index);

    // Создадим "завершённую" задачу для taskHistory:
    final completedTask = oldTask.copyWith(
      finishDate: DateTime.now(),
    );

    // Если задача периодическая, сгенерируем ей новый dueDate
    // и вернём в текущие tasks уже как "новый цикл".
    if (oldTask.isPeriodic) {
      if (oldTask.dueDate != null) {
        // Прибавим periodicityDays к старому dueDate
        final newDueDate = oldTask.dueDate!.add(
          Duration(days: oldTask.periodicityDays),
        );

        // "Возрождённая" задача без finishDate, но с обновлённым dueDate
        final nextIteration = oldTask.copyWith(
          // Можно изменить id, если хотите уникальный,
          // но зачастую достаточно оставить тот же id
          // (или завести поле cycleCount и т.п.).
          dueDate: newDueDate,
          finishDate: null,
        );
        updatedTasks.add(nextIteration);
      }
    }

    // Добавим "completedTask" в историю
    final updatedHistory = List<TaskCatalog>.from(taskHistory)
      ..add(completedTask);

    // Вернём обновлённый курятник
    return copyWith(
      tasks: updatedTasks,
      taskHistory: updatedHistory,
    );
  }
}
