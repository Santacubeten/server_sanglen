class ApokpaKhoirambaNumitModel {
  final int? id;
  final String numit;
  final int clanId;

  ApokpaKhoirambaNumitModel(
      {this.id, required this.numit, required this.clanId});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numit': numit,
      'clan_id': clanId,
    };
  }

  factory ApokpaKhoirambaNumitModel.fromJson(Map<String, dynamic> json) {
    return ApokpaKhoirambaNumitModel(
        id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
        numit: json['numit'] ?? '',
        clanId: int.parse(json['clan_id'].toString()));
  }
}
