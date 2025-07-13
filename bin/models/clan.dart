import 'surname.dart';

class Clan {
  final int? id;
  final String name;
  final DateTime? createdAt;
  final String? createdBy;
  final List<Surname>? surnames;

  Clan({
    this.id,
    required this.name,
    this.createdAt,
    this.createdBy,
    this.surnames,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
      'surnames': surnames?.map((s) => s.toJson()).toList(),
    };
  }

  factory Clan.fromJson(Map<String, dynamic> map) {
    return Clan(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      name: map['name'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      createdBy: map['created_by'],
      surnames: map['surnames'] != null
          ? (map['surnames'] as List)
              .map((s) => Surname.fromJson(s))
              .toList()
          : null,
    );
  }

  Clan copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    String? createdBy,
    List<Surname>? surnames,
  }) {
    return Clan(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      surnames: surnames ?? this.surnames,
    );
  }
}
