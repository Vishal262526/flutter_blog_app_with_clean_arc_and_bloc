import 'package:blog_app/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.uid,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['id'] ?? "",
        name: json['name'] ?? "",
        email: json['email'] ?? "",
      );

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
      );
}
