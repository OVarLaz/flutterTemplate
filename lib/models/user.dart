import 'dart:convert';

class User {
  var user_id;
  dynamic username;
  String password;
  String token;
  String nombre;
  String apellido;
  String dni;
  String email;
  String telefono;
  var rol;
  String imagen;
  String fechaCreacion;
  String fechaEdicion;
  
  User(this.user_id, this.username, this.password, this.token, this.nombre, this.apellido, this.dni, this.email, this.telefono, this.rol, this.imagen, this.fechaCreacion, this.fechaEdicion);

  User.map(dynamic obj) {
    this.user_id = obj["user_id"];
    this.username = obj["username"];
    this.password = obj["password"];
    this.token = obj["token"];
    this.nombre = obj["nombre"];
    this.apellido = obj["apellido"];
    this.dni = obj["dni"];
    this.email = obj["email"];
    this.telefono = obj["telefono"];
    this.rol = obj["rol"];
    this.imagen = obj["imagen"];
    this.fechaCreacion = obj["fechaCreacion"];
    this.fechaEdicion = obj["fechaEdicion"];
  }

  dynamic get _user_id => user_id;
  dynamic get _username => username;
  String get _password => password;
  String get _token => token;
  String get _nombre => nombre;
  String get _apellido => apellido;
  String get _dni => dni;
  String get _email => email;
  String get _telefono => telefono;
  dynamic get _rol => rol;
  String get _imagen => imagen;
  String get _fechaCreacion => fechaCreacion;
  String get _fechaEdicion => fechaEdicion;

  // set nombre(String name) => _nombre = name;
  // set dni(String lastname) => _dni = lastname;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["user_id"] = _user_id;
    map["username"] = _username;
    map["password"] = _password;
    map["token"] = _token;
    map["nombre"] = _nombre;
    map["apellido"] = _apellido;
    map["dni"] = _dni;
    map["email"] = _email;
    map["telefono"] = _telefono;
    map["rol"] = _rol;
    map["imagen"] = _imagen;
    map["fechaCreacion"] = _fechaCreacion;
    map["fechaEdicion"] = _fechaEdicion;

    return map;
  }

  Map<String, dynamic> toJson() => {
      "username": username,
      "nombre": nombre,
      "dni": dni,
  };

  factory User.fromJson(Map<String, dynamic> json) => new User(
        json["user_id"],
        json["username"],
        json["password"],
        json["token"],
        json["nombre"],
        json["apellido"],
        json["dni"],
        json["email"],
        json["telefono"],
        json["rol"],
        json["imagen"],
        json["fechaCreacion"],
        json["fechaEdicion"],

    );

  User userFromJson(String str) {
      final jsonData = json.decode(str);
      return User.fromJson(jsonData);
  }

  String userToJson(User data) {
      final dyn = data.toJson();
      return json.encode(dyn);
  }
}