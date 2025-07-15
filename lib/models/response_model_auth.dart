import 'dart:convert';

class ResponseModelAuth {
  final String? accessToken;
  final String? tokenType;
  final User? user;

  ResponseModelAuth({this.accessToken, this.tokenType, this.user});

  factory ResponseModelAuth.fromRawJson(String str) =>
      ResponseModelAuth.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseModelAuth.fromJson(Map<String, dynamic> json) =>
      ResponseModelAuth(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "user": user?.toJson(),
  };
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
