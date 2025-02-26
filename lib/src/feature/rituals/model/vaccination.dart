// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Vaccination {
  final String name;
  final String date;
  final String description;

  Vaccination({
    required this.name,
    required this.date,
    required this.description,
  });


  Vaccination copyWith({
    String? name,
    String? date,
    String? description,
  }) {
    return Vaccination(
      name: name ?? this.name,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'date': date,
      'description': description,
    };
  }

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    return Vaccination(
      name: map['name'] as String,
      date: map['date'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vaccination.fromJson(String source) => Vaccination.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Vaccination(name: $name, date: $date, description: $description)';

  @override
  bool operator ==(covariant Vaccination other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.date == date &&
      other.description == description;
  }

  @override
  int get hashCode => name.hashCode ^ date.hashCode ^ description.hashCode;
}
