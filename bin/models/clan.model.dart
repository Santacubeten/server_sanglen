import 'surname.model.dart';

// class ClanModel {
//   final int? id;
//   final String name;
//   final DateTime? createdAt;
//   final String? createdBy;
//   final int? origin;
//   final List<SurnameModel>? surnames;

//   ClanModel({
//     this.id,
//     required this.name,
//     this.createdAt,
//     this.createdBy,
//     this.origin,
//     this.surnames,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'created_at': createdAt?.toIso8601String(),
//       'created_by': createdBy,
//       'surnames': surnames?.map((s) => s.toJson()).toList(),
//     };
//   }

//   factory ClanModel.fromJson(Map<String, dynamic> map) {
//     return ClanModel(
//       id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
//       name: map['name'] ?? '',
//       createdAt: map['created_at'] != null
//           ? DateTime.tryParse(map['created_at'])
//           : null,
//       createdBy: map['created_by'],
//       surnames: map['surnames'] != null
//           ? (map['surnames'] as List)
//               .map((s) => SurnameModel.fromJson(s))
//               .toList()
//           : null,
//     );
//   }

//   ClanModel copyWith({
//     int? id,
//     String? name,
//     DateTime? createdAt,
//     String? createdBy,
//     List<SurnameModel>? surnames,
//   }) {
//     return ClanModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       createdAt: createdAt ?? this.createdAt,
//       createdBy: createdBy ?? this.createdBy,
//       surnames: surnames ?? this.surnames,
//     );
//   }
// }


// import 'surname.model.dart';

class ClanModel {
  final int? id;
  final String name;
  final DateTime? createdAt;
  final String? createdBy;
  final int? originId;
  final List<SurnameModel>? surnames;

  ClanModel({
    this.id,
    required this.name,
    this.createdAt,
    this.createdBy,
    this.originId,
    this.surnames,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
      'origin_id': originId,
      'surnames': surnames?.map((s) => s.toJson()).toList(),
    };
  }

  factory ClanModel.fromJson(Map<String, dynamic> map) {
    return ClanModel(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      name: map['name'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      createdBy: map['created_by'],
      originId: map['origin_id'] != null
          ? int.tryParse(map['origin_id'].toString())
          : null,
      surnames: map['surnames'] != null
          ? (map['surnames'] as List)
              .map((s) => SurnameModel.fromJson(s))
              .toList()
          : null,
    );
  }

  ClanModel copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    String? createdBy,
    int? originId,
    List<SurnameModel>? surnames,
  }) {
    return ClanModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      originId: originId ?? this.originId,
      surnames: surnames ?? this.surnames,
    );
  }
}
