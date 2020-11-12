// To parse this JSON data, do
//
//     final loginSignUpModel = loginSignUpModelFromJson(jsonString);

import 'dart:convert';

LoginSignUpModel loginSignUpModelFromJson(String str) =>
    LoginSignUpModel.fromJson(json.decode(str));

String loginSignUpModelToJson(LoginSignUpModel data) =>
    json.encode(data.toJson());

class LoginSignUpModel {
  int status;
  String message;
  UserRecord userRecord;

  LoginSignUpModel({
    this.status,
    this.message,
    this.userRecord,
  });

  factory LoginSignUpModel.fromJson(Map<String, dynamic> json) =>
      LoginSignUpModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        userRecord:
        json["record"] == null ? null : UserRecord.fromJson(json["record"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "record": userRecord == null ? null : userRecord.toJson(),
      };
}

class UserRecord {
  String userID;
  String name;
  String email;
  String apiKey;
  String token;
  String status;
  LoginSpinDetails loginSpinDetails;

  UserRecord({
    this.userID,
    this.name,
    this.email,
    this.apiKey,
    this.token,
    this.status,
    this.loginSpinDetails,
  });

  factory UserRecord.fromJson(Map<String, dynamic> json) =>
      UserRecord(
        userID: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        apiKey: json["api_key"] == null ? null : json["api_key"],
        token: json["token"] == null ? null : json["token"],
        status: json["status"] == null ? null : json["status"],
        loginSpinDetails: json["spin_details"] == null
            ? null
            : LoginSpinDetails.fromJson(json["spin_details"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": userID == null ? null : userID,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "api_key": apiKey == null ? null : apiKey,
        "token": token == null ? null : token,
        "status": status == null ? null : status,
        "spin_details": loginSpinDetails == null ? null : loginSpinDetails
            .toJson(),
      };
}

class LoginSpinDetails {
  LoginSpinDetails({
    this.id,
    this.userId,
    this.theBomb,
    this.theHeart,
    this.theTime,
    this.thePlayer,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String userId;
  String theBomb;
  String theHeart;
  String theTime;
  String thePlayer;
  DateTime createdAt;
  DateTime updatedAt;

  factory LoginSpinDetails.fromJson(Map<String, dynamic> json) =>
      LoginSpinDetails(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        theBomb: json["type_1"] == null ? null : json["type_1"],
        theHeart: json["type_2"] == null ? null : json["type_2"],
        theTime: json["type_3"] == null ? null : json["type_3"],
        thePlayer: json["type_4"] == null ? null : json["type_4"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "type_1": theBomb == null ? null : theBomb,
        "type_2": theHeart == null ? null : theHeart,
        "type_3": theTime == null ? null : theTime,
        "type_4": thePlayer == null ? null : thePlayer,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
