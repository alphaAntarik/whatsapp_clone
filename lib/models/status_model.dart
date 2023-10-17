class StatusModel {
  String? id;
  String? userId;
  String? status;
  String? dateonly;
  String? timestamp;
  String? name;

  StatusModel(
      {this.id,
      this.userId,
      this.status,
      this.dateonly,
      this.timestamp,
      this.name});

  StatusModel.fromJson(Map<String, dynamic> json) {
    if (json["_id"] is String) {
      id = json["_id"];
    }
    if (json["user_id"] is String) {
      userId = json["user_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["dateonly"] is String) {
      dateonly = json["dateonly"];
    }
    if (json["timestamp"] is String) {
      timestamp = json["timestamp"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["user_id"] = userId;
    _data["status"] = status;
    _data["dateonly"] = dateonly;
    _data["timestamp"] = timestamp;
    _data["name"] = name;
    return _data;
  }
}
