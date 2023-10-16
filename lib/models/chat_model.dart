class ChatModel {
  String? from;
  String? to;
  String? message;
  String? dateonly;
  String? timestamp;
  String? typeOfMessage;
  String? id;

  ChatModel(
      {this.from,
      this.to,
      this.message,
      this.dateonly,
      this.timestamp,
      this.typeOfMessage,
      this.id});

  ChatModel.fromJson(Map<String, dynamic> json) {
    if (json["from"] is String) {
      from = json["from"];
    }
    if (json["to"] is String) {
      to = json["to"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["dateonly"] is String) {
      dateonly = json["dateonly"];
    }
    if (json["timestamp"] is String) {
      timestamp = json["timestamp"];
    }
    if (json["typeOfMessage"] is String) {
      typeOfMessage = json["typeOfMessage"];
    }
    if (json["_id"] is String) {
      id = json["_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["from"] = from;
    _data["to"] = to;
    _data["message"] = message;
    _data["dateonly"] = dateonly;
    _data["timestamp"] = timestamp;
    _data["typeOfMessage"] = typeOfMessage;
    _data["_id"] = id;
    return _data;
  }
}
