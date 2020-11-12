// To parse this JSON data, do
//
//     final jackpotTriviaCategories = jackpotTriviaCategoriesFromJson(jsonString);

import 'dart:convert';

JackpotTriviaCategories jackpotTriviaCategoriesFromJson(String str) =>
    JackpotTriviaCategories.fromJson(json.decode(str));

String jackpotTriviaCategoriesToJson(JackpotTriviaCategories data) =>
    json.encode(data.toJson());

class JackpotTriviaCategories {
  int status;
  String message;
  List<Categories> categories;

  JackpotTriviaCategories({
    this.status,
    this.message,
    this.categories,
  });

  factory JackpotTriviaCategories.fromJson(Map<String, dynamic> json) =>
      JackpotTriviaCategories(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        categories: json["records"] == null
            ? null
            : List<Categories>.from(
                json["records"].map((x) => Categories.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "records": categories == null
            ? null
            : List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Categories {
  String id;
  String name;

  Categories({
    this.id,
    this.name,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
