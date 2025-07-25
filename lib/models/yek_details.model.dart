class YekDetailsModel {
  final int? id;
  final int clanId;
  final String firewood;
  final String color;     // Hex color code
  final String? flower;
  final String? fruit;
  final String? fish;
  final String? sword;
  final DateTime? createdAt;

  YekDetailsModel({
    this.id,
    required this.clanId,
    required this.firewood,
    required this.color,
    this.flower,
    this.fruit,
    this.fish,
    this.sword,
    this.createdAt,
  });

  // ✅ Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clan_id': clanId,
      'firewood': firewood,
      'color': color,
      'flower': flower,
      'fruit': fruit,
      'fish': fish,
      'sword': sword,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // ✅ Create object from JSON
  factory YekDetailsModel.fromJson(Map<String, dynamic> json) {
    return YekDetailsModel(
      id: json['id'] as int?,
      clanId: json['clan_id'] as int,
      firewood: json['firewood'] as String,
      color: json['color'] as String,
      flower: json['flower'] as String?,
      fruit: json['fruit'] as String?,
      fish: json['fish'] as String?,
      sword: json['sword'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  // ✅ Optional: copyWith
  YekDetailsModel copyWith({
    int? id,
    int? clanId,
    String? firewood,
    String? color,
    String? flower,
    String? fruit,
    String? fish,
    String? sword,
    DateTime? createdAt,
  }) {
    return YekDetailsModel(
      id: id ?? this.id,
      clanId: clanId ?? this.clanId,
      firewood: firewood ?? this.firewood,
      color: color ?? this.color,
      flower: flower ?? this.flower,
      fruit: fruit ?? this.fruit,
      fish: fish ?? this.fish,
      sword: sword ?? this.sword,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
