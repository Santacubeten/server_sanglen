class YelhenModel {
  final int? id;
  final String name;
  final String? description;

  YelhenModel({
     this.id,
    required this.name,
     this.description,
  });

  factory YelhenModel.fromJson(Map<String, dynamic> json) {
    return YelhenModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
  YelhenModel copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return YelhenModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}