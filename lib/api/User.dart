class UserLogin {
  String name;
  String email;
  // String eToken;

  UserLogin(this.name, this.email);
  UserLogin.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];
  //  eToken = json['eToken'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        //  'eToken': eToken
      };
}
