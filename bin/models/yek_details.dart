class YekDetails {
  final int? id;
  final int clanId;
  final String name;
  final String color;     // Hex color code
  final String? flower;
  final String? fruit;
  final String? fish;
  final String? sword;
  final DateTime? createdAt;

  YekDetails({
    this.id,
    required this.clanId,
    required this.name,
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
      'name': name,
      'color': color,
      'flower': flower,
      'fruit': fruit,
      'fish': fish,
      'sword': sword,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // ✅ Create object from JSON
  factory YekDetails.fromJson(Map<String, dynamic> json) {
    return YekDetails(
      id: json['id'] as int?,
      clanId: json['clan_id'] as int,
      name: json['name'] as String,
      color: json['color'] as String,
      flower: json['flower'] as String?,
      fruit: json['fruit'] as String?,
      fish: json['fish'] as String?,
      sword: json['sword'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // ✅ Optional: copyWith
  YekDetails copyWith({
    int? id,
    int? clanId,
    String? name,
    String? color,
    String? flower,
    String? fruit,
    String? fish,
    String? sword,
    DateTime? createdAt,
  }) {
    return YekDetails(
      id: id ?? this.id,
      clanId: clanId ?? this.clanId,
      name: name ?? this.name,
      color: color ?? this.color,
      flower: flower ?? this.flower,
      fruit: fruit ?? this.fruit,
      fish: fish ?? this.fish,
      sword: sword ?? this.sword,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
