// To parse this JSON data, do
//
//     final topRanker = topRankerFromJson(jsonString);

import 'dart:convert';

TopRankerScore topRankerFromJson(String str) => TopRankerScore.fromJson(json.decode(str));

String topRankerToJson(TopRankerScore data) => json.encode(data.toJson());

class TopRankerScore {
  TopRankerScore({
    this.s,
    this.m,
    this.rankerRecords,
  });

  int s;
  String m;
  List<RankerRecord> rankerRecords;

  factory TopRankerScore.fromJson(Map<String, dynamic> json) => TopRankerScore(
        s: json["s"] == null ? null : json["s"],
        m: json["m"] == null ? null : json["m"],
        rankerRecords: json["records"] == null
            ? null
            : List<RankerRecord>.from(json["records"].map((x) => RankerRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "s": s == null ? null : s,
        "m": m == null ? null : m,
        "records": rankerRecords == null
            ? null
            : List<dynamic>.from(rankerRecords.map((x) => x.toJson())),
      };
}

class RankerRecord {
  RankerRecord({
    this.userId,
    this.totalPoints,
    this.userDetails,
  });

  String userId;
  String totalPoints;
  UserDetails userDetails;

  factory RankerRecord.fromJson(Map<String, dynamic> json) => RankerRecord(
        userId: json["user_id"] == null ? null : json["user_id"],
        totalPoints: json["total_points"] == null ? null : json["total_points"],
        userDetails: json["user_details"] == null
            ? null
            : UserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "total_points": totalPoints == null ? null : totalPoints,
        "user_details": userDetails == null ? null : userDetails.toJson(),
      };
}

class UserDetails {
  UserDetails({
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

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
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
