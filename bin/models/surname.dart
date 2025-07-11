class Surname {
  final int? id;
  final String name;
  final int clanId;

  Surname({
    this.id,
    required this.name,
    required this.clanId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'clan_id': clanId,
    };
  }

  factory Surname.fromJson(Map<String, dynamic> map) {
    return Surname(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      name: map['name'] ?? '',
      clanId: int.parse(map['clan_id'].toString()),
    );
  }
}
