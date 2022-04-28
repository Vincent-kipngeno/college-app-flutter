import 'dart:collection';

class MyUser{

  MyUser();

  MyUser.construct({required this.username, required this.email, required this.phone, required this.password});
  MyUser.fromMap(Map user)
      : uid = user["uid"],
        email = user["email"],
        username = user["username"],
        phone = user["phone"];

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

  Map<String, dynamic> userMap(){
    Map<String,dynamic> user = HashMap();
    user["uid"] = uid;
    user["email"] = email;
    user["username"] = username;
    user["phone"] = phone;
    return user;
  }
}