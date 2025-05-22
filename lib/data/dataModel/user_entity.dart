import 'package:flutter/cupertino.dart';

class UserEntity {
  // 本地 SQLite 主键
  final int?id;

  // Firebase UID 或远程唯一标识
  final String uid;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;

  // 可选字段（用于扩展）
  // 登录缓存令牌，离线用
  final String? token;

  //用户是否处于活动状态
  final bool isActive;

  UserEntity(
      { this.id,
      required this.uid,
      required this.username,
      required this.email,
      this.avatarUrl,
      required this.createdAt,
      this.token,
      this.isActive = true});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "uid": uid,
      "username": username,
      "email": email,
      "avatarUrl": avatarUrl,
      "createdAt": createdAt.toIso8601String(),
      "token": token,
      "isActive": isActive ? 1 : 0,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map["id"],
      uid: map["uid"],
      username: map["username"],
      email: map["email"],
      avatarUrl: map["avatarUrl"],
      createdAt: DateTime.parse(map["createdAt"]),
      token: map["token"],
      isActive: map["isActive"] == 1,
    );
  }
}
