// To parse this JSON data, do
//
//     final getUsers = getUsersFromJson(jsonString);

import 'dart:convert';

GetUsers getUsersFromJson(String str) => GetUsers.fromJson(json.decode(str));

String getUsersToJson(GetUsers data) => json.encode(data.toJson());

class GetUsers {
  GetUsers({
    this.data,
  });

  Data data;

  factory GetUsers.fromJson(Map<String, dynamic> json) => GetUsers(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.email,
    this.password,
    this.fullname,
    this.mobile,
    this.status,
    this.gender,
  });

  String id;
  String email;
  String password;
  dynamic fullname;
  dynamic mobile;
  String status;
  dynamic gender;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        fullname: json["fullname"],
        mobile: json["mobile"],
        status: json["status"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "fullname": fullname,
        "mobile": mobile,
        "status": status,
        "gender": gender,
      };
}
