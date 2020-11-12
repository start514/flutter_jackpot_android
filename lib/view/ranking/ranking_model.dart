// To parse this JSON data, do
//
//     final topRanker = topRankerFromJson(jsonString);

import 'dart:convert';

TopRanker topRankerFromJson(String str) => TopRanker.fromJson(json.decode(str));

String topRankerToJson(TopRanker data) => json.encode(data.toJson());

class TopRanker {
  TopRanker({
    this.status,
    this.message,
    this.topRankerRecords,
  });

  int status;
  String message;
  List<TopRankerRecord> topRankerRecords;

  factory TopRanker.fromJson(Map<String, dynamic> json) => TopRanker(
        status: json["s"] == null ? null : json["s"],
        message: json["m"] == null ? null : json["m"],
        topRankerRecords: json["records"] == null
            ? null
            : List<TopRankerRecord>.from(
                json["records"].map((x) => TopRankerRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "s": status == null ? null : status,
        "m": message == null ? null : message,
        "records": topRankerRecords == null
            ? null
            : List<dynamic>.from(topRankerRecords.map((x) => x.toJson())),
      };
}

class TopRankerRecord {
  TopRankerRecord({
    this.userId,
    this.totalPoints,
    this.topRankerUserDetails,
  });

  String userId;
  String totalPoints;
  TopRankerUserDetails topRankerUserDetails;
  int rank;

  factory TopRankerRecord.fromJson(Map<String, dynamic> json) =>
      TopRankerRecord(
        userId: json["user_id"] == null ? null : json["user_id"],
        totalPoints: json["total_points"] == null ? null : json["total_points"],
        topRankerUserDetails: json["user_details"] == null
            ? null
            : TopRankerUserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "total_points": totalPoints == null ? null : totalPoints,
        "user_details":
            topRankerUserDetails == null ? null : topRankerUserDetails.toJson(),
      };
}

class TopRankerUserDetails {
  TopRankerUserDetails({
    this.id,
    this.name,
    this.email,
    this.apiKey,
    this.token,
    this.status,
  });

  String id;
  String name;
  String email;
  String apiKey;
  String token;
  String status;

  factory TopRankerUserDetails.fromJson(Map<String, dynamic> json) =>
      TopRankerUserDetails(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        apiKey: json["api_key"] == null ? null : json["api_key"],
        token: json["token"] == null ? null : json["token"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "api_key": apiKey == null ? null : apiKey,
        "token": token == null ? null : token,
        "status": status == null ? null : status,
      };
}
