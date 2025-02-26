// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Gallery {
  final String image;
  final String name;
  final String description;

  Gallery({
    required this.image,
    required this.name,
    required this.description,
  });


  Gallery copyWith({
    String? image,
    String? name,
    String? description,
  }) {
    return Gallery(
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'name': name,
      'description': description,
    };
  }

  factory Gallery.fromMap(Map<String, dynamic> map) {
    return Gallery(
      image: map['image'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Gallery.fromJson(String source) => Gallery.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Gallery(image: $image, name: $name, description: $description)';

  @override
  bool operator ==(covariant Gallery other) {
    if (identical(this, other)) return true;
  
    return 
      other.image == image &&
      other.name == name &&
      other.description == description;
  }

  @override
  int get hashCode => image.hashCode ^ name.hashCode ^ description.hashCode;
}
