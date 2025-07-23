class User {
  String? id;
  String? username;
  String? email;
  String? role;
  String? password;
  int? status;
  DateTime? createdAt;
  String? createdBy;
  String? jwtToken;

  User({
    this.id,
    this.username,
    this.email,
    this.role,
    this.password,
    this.status,
    this.createdAt,
    this.createdBy,
    this.jwtToken,
  });

  // create factory method to create a User object from a JSON map
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    // id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
    id: json['id']?.toString(),
    username: json['username']?.toString(),
    email: json['email']?.toString(),
    role: json['role']?.toString(),
    password: json['password']?.toString(),
    status: json['status'] != null ? int.tryParse(json['status'].toString()) : null,
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null,
    createdBy: json['created_by']?.toString(),
    jwtToken: json['jwt_token']?.toString(),
  );
}

  // Convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'password': password,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
      'jwt_token': jwtToken,
    };
  }

//copyWith method to create a new User object with some fields modified
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? role,
    String? password,
    int? status,
    DateTime? createdAt,
    String? createdBy,
    String? jwtToken,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      password: password ?? this.password,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      jwtToken: jwtToken ?? this.jwtToken,
    );
  }
}
