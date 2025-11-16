
class Utilisateur {
  int? id;
  String username;
  String? password;

  Utilisateur({this.id, required this.username, this.password});
  Utilisateur.sansId({required this.username, this.password}) : id = null;

  Map<String?, dynamic> toMap() {
    final map = {
      null: id,
      'username': username,
      'password': password,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map; 
  } 

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }


}