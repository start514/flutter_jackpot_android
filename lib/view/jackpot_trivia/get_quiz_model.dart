// To parse this JSON data, do
//
//     final getQuiz = getQuizFromJson(jsonString);

import 'dart:convert';

GetQuiz getQuizFromJson(String str) => GetQuiz.fromJson(json.decode(str));

String getQuizToJson(GetQuiz data) => json.encode(data.toJson());

class GetQuiz {
  int? status;
  String? message;
  List<Quiz>? quiz;

  GetQuiz({
    this.status,
    this.message,
    this.quiz,
  });

  factory GetQuiz.fromJson(Map<String, dynamic> json) => GetQuiz(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        quiz: json["records"] == null
            ? null
            : List<Quiz>.from(json["records"].map((x) => Quiz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "records": quiz == null
            ? null
            : List<dynamic>.from(quiz!.map((x) => x.toJson())),
      };
}

class Quiz {
  String? id;
  String? title;
  String? photoThumb;
  String? amount;
  String? end_date;

  Quiz({
    this.id,
    this.title,
    this.photoThumb,
    this.amount,
    this.end_date,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        photoThumb: json["photo_thumb"] == null ? null : json["photo_thumb"],
        amount: json["amount"] == null ? null : json["amount"],
        end_date: json["end_date"] == null ? null : json["end_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "photo_thumb": photoThumb == null ? null : photoThumb,
        "amount": amount == null ? null : amount,
        "end_date": end_date == null ? null : end_date,
      };
}
