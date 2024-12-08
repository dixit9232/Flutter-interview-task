import 'dart:convert';

import 'package:equatable/equatable.dart';

List<PostModel> postModelFromJson(String str) => List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String postModelToJson(List<PostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel extends Equatable {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;
  final bool isUnread;

  PostModel({
    this.userId,
    this.id,
    this.title,
    this.body,
    this.isUnread = true,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
        isUnread: json["isUnread"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
        "isUnread": isUnread,
      };

  PostModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    bool? isUnread,
  }) {
    return PostModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isUnread: isUnread ?? this.isUnread,
    );
  }

  @override
  List<Object?> get props => [userId, id, title, body, isUnread];
}
