class YelhenModel {
  final int? id;
  final String name;
  final String? description;
  final int clanId;

  YelhenModel({
    this.id,
    required this.name,
    this.description,
    required this.clanId,
  });

  factory YelhenModel.fromJson(Map<String, dynamic> json) {
    return YelhenModel(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] as String,
      description: json['description'] as String?,
      clanId: json['clan_id'] ?? json['clanId'], // Support both keys
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'clan_id': clanId,
    };
  }

  YelhenModel copyWith({

    int? id,
    String? name,
    String? description,
    int? clanId,
  }) {
    return YelhenModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      clanId: clanId ?? this.clanId,
    );
  }
}
