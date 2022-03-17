// To parse this JSON data, do
//
//     final usersInfo = usersInfoFromJson(jsonString);

import 'dart:convert';

UsersInfo usersInfoFromJson(String str) => UsersInfo.fromJson(json.decode(str));

String usersInfoToJson(UsersInfo data) => json.encode(data.toJson());

class UsersInfo {
  UsersInfo({
    this.id,
    this.email,
    this.password,
    this.fullname,
    this.mobile,
    this.status,
    this.gender,
    this.paymenttype,
    this.expirydate,
    this.amount,
    this.profilepicture,
  });

  String id;
  String email;
  String password;
  String fullname;
  String mobile;
  String status;
  String gender;
  String paymenttype;
  String expirydate;
  String amount;
  String profilepicture;

  factory UsersInfo.fromJson(Map<String, dynamic> json) => UsersInfo(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        fullname: json["fullname"],
        mobile: json["mobile"],
        status: json["status"],
        gender: json["gender"],
        paymenttype: json["paymenttype"],
        expirydate: json["expirydate"],
        amount: json["amount"],
        profilepicture: json["profilepicture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "fullname": fullname,
        "mobile": mobile,
        "status": status,
        "gender": gender,
        "paymenttype": paymenttype,
        "expirydate": expirydate,
        "amount": amount,
        "profilepicture": profilepicture,
      };
}
