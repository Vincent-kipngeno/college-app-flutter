class MyUser{

  MyUser();

  MyUser.construct({required this.username, required this.email, required this.phone, required this.password});

  late String uid, email, username, phone, confirmPassword, password;

  void setEmail(String? value) {
    email = value?? "";
  }

  void setUid(String? value) {
    uid = value?? "";
  }

  void setUserName(String? value) {
    username = value?? "";
  }

  void setPhone(String? value) {
    phone = value?? "";
  }

  void setPassword(String? value){
    password = value?? "";
  }
}