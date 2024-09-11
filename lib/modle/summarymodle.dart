class summarymodle {
  String? title;
  String? text;
  String? summary;

  summarymodle({this.title, this.text, this.summary});

  summarymodle.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['text'] = this.text;
    data['summary'] = this.summary;
    return data;
  }
}