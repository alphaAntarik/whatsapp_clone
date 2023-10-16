class UserModel {
  String? name;
  String? email;
  String? password;
  String? phonenumber;
  String? profileImage;
  String? id;
  // String? lastmessage;
  // String? lastmessageuserid;
  int? v;

  UserModel(
      {this.name,
      this.email,
      // this.lastmessage,
      // this.lastmessageuserid,
      this.password,
      this.phonenumber,
      this.profileImage,
      this.id,
      this.v});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["password"] is String) {
      password = json["password"];
    }
    if (json["phonenumber"] is String) {
      phonenumber = json["phonenumber"];
    }
    // if (json["lastmessageuserid"] is String) {
    //   lastmessageuserid = json["lastmessageuserid"];
    // }
    // if (json["lastmessage"] is String) {
    //   lastmessage = json["lastmessage"];
    //  }
    if (json["profileImage"] is String) {
      profileImage = json["profileImage"];
    }
    if (json["_id"] is String) {
      id = json["_id"];
    }
    if (json["__v"] is int) {
      v = json["__v"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["email"] = email;
    _data["password"] = password;
    _data["phonenumber"] = phonenumber;
    _data["profileImage"] = profileImage;
    // _data["lastmessage"] = lastmessage;
    // _data["lastmessageuserid"] = lastmessageuserid;
    _data["_id"] = id;
    _data["__v"] = v;
    return _data;
  }
}
