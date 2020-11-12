// To parse this JSON data, do
//
//     final questionModelClass = questionModelClassFromJson(jsonString);

import 'dart:convert';

QuestionModelClass questionModelClassFromJson(String str) =>
    QuestionModelClass.fromJson(json.decode(str));

String questionModelClassToJson(QuestionModelClass data) =>
    json.encode(data.toJson());

class QuestionModelClass {
  int status;
  String message;
  List<Record> records;

  QuestionModelClass({
    this.status,
    this.message,
    this.records,
  });

  factory QuestionModelClass.fromJson(Map<String, dynamic> json) =>
      QuestionModelClass(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        records: json["records"] == null
            ? null
            : List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "records": records == null
            ? null
            : List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Record {
  String id;
  String question;
  List<Option> options;
  bool isEnable = true;
  bool nextButton = false;
  bool finalSelectAnswerIsTrue = false;
  int points;
  int bonus;

  Record({
    this.id,
    this.question,
    this.options,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"] == null ? null : json["id"],
        question: json["question"] == null ? null : json["question"],
        options: json["options"] == null
            ? null
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "question": question == null ? null : question,
        "options": options == null
            ? null
            : List<dynamic>.from(options.map((x) => x.toJson())),
      };

  Map<String, dynamic> toSubmit() {
    Option option;
    options.forEach((element) {
      if (element.isSelected) {
        option = element;
      }
    });
    return {
      "question_id": id,
      "points": points??0,
      "isAns": option.isAnswer == "1" ? "1" : "0",
      "option_id": option.id,
    };
  }
}

class Option {
  String id;
  String options;
  String isAnswer;
  bool isSelected = false;

  Option({
    this.id,
    this.options,
    this.isAnswer,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"] == null ? null : json["id"],
        options: json["options"] == null ? null : json["options"],
        isAnswer: json["isAnswer"] == null ? null : json["isAnswer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "options": options == null ? null : options,
        "isAnswer": isAnswer == null ? null : isAnswer,
      };
}
