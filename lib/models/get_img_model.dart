
class GetImgModel {
  String? path;

  GetImgModel({this.path});

  GetImgModel.fromJson(Map<String, dynamic> json) {
    if(json["path"] is String) {
      path = json["path"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["path"] = path;
    return _data;
  }
}