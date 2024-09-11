class questionmcq {
  String? question;
  List<String>? choices;

  questionmcq({required this.question, required this.choices});

  questionmcq.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    choices = json['choices'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['choices'] = this.choices;
    return data;
  }
}