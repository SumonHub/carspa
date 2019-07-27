class UserReg {
  String fstName;
  String lstName;
  String email;
  String cnfEmail;
  String phone;
  String address;
  String pass;
  String cnfPass;
// String eToken;

  UserReg(this.fstName, this.lstName, this.email, this.cnfEmail, this.phone,
      this.address, this.pass, this.cnfPass);
//first_name, last_name, email, confirm_email, phone, address, password, confirm_password
  UserReg.fromJson(Map<String, dynamic> json)
      : fstName = json['first_name'],
        lstName = json['last_name'],
        email = json['email'],
        cnfEmail = json['confirm_email'],
        phone = json['phone'],
        address = json['address'],
        pass = json['password'],
        cnfPass = json['confirm_password'];

  /* Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        //  'eToken': eToken
      };*/

}
