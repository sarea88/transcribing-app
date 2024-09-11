class Usermodleres {
  int? id;
  String? name;
  String? email;
  String? apiToken;
  String? message;
  String? phoneNumber;

  Usermodleres({this.id, this.name, this.email, this.apiToken});

  Usermodleres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    message = json['message'];
    apiToken = json['token'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['message'] = this.message;
    data['token'] = this.apiToken;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

class loginreqmod {
  String? email;
  String? password;

  loginreqmod({required this.email, required this.password});

  loginreqmod.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['email'] = this.email;
    data['pasword'] = this.password;
    return data;
  }
}

class signupreqmod {
  String? name;
  String? email;
  String? password;
  String? passwordConfirmation;
  String? phoneNumber;

  signupreqmod(
      {this.name,
      this.email,
      this.password,
      this.passwordConfirmation,
      this.phoneNumber});

  signupreqmod.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}