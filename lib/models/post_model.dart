class PostModel {
  String? title;
  String? body;
  String? id;

  PostModel({this.body, this.title});

  PostModel.fromJson(Map<String, dynamic> map, String i) {
    title = map["title"];
    body = map["body"];
    id = i;
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}
