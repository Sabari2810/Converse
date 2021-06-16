class UserModel{
  String id;
  String email;
  String displayName;

  UserModel({this.id = "",this.email = "",this.displayName = ""});


  String get userid{
    return this.id;
  }
  
}

