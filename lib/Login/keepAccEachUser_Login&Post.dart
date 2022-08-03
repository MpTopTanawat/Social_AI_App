// ignore_for_file: file_names

class AccountUserLogin {
  String? name;
  String? email;
  String? password;

  AccountUserLogin({this.name, this.email, this.password});
}

class KeepDataFromPost {
  String? keepPostText = '1';

  KeepDataFromPost({this.keepPostText});
}
