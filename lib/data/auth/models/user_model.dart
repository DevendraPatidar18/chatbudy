import 'dart:convert';

import 'package:chatbudy/domain/auth/entity/entity.dart';

class UserModel{
  final String name;
  final String email;
  final String uid;
  final String profileImageUri;
  final String bio;

  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.profileImageUri,
    required this.bio
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'uid' : this.uid,
      'profileImageUri' : this.profileImageUri,
      'bio' : this.bio
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
        profileImageUri: map['profileImageUri'] ?? '',
        bio: map['bio'] ?? "Add About you"

    );
  }
  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        name: name,
        email: email,
        uid : uid,
        profileImageUri: profileImageUri,
        bio:bio
    );
  }
}