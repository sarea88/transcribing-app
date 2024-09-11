class archive {
  int? id;
  String? fileName;
  String? fileLocation;
  String? createdAt;
  String? updatedAt;

  archive(
      {this.id,
      this.fileName,
      this.fileLocation,
      this.createdAt,
      this.updatedAt});

  archive.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['file_name'];
    fileLocation = json['file_location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_name'] = this.fileName;
    data['file_location'] = this.fileLocation;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
