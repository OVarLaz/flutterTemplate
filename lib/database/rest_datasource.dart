import 'dart:async';
import 'dart:io' as io;
import 'dart:convert';
import 'package:template/utils/network_util.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:template/models/user.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  // static final BASE_URL = "http://192.168.1.4:8000/";
  static final BASE_URL = "http://18.223.210.170:8000/";
  // static final BASE_URL = "https://apitest.integracionplanok.io/";
  static final LOGIN_URL = BASE_URL + "users/login/";  
  // static final LOGIN_URL = BASE_URL + "api/login"; 
  static final LOGOUT_URL = BASE_URL + "users/logout/";

  static final PRODUCTOS_URL = BASE_URL + "products/";
  static final TRAMOS_URL = BASE_URL + "stretchs/";
  static final EMPRESAS_URL = BASE_URL + "companies/";
  static final TIPODOSIS_URL = BASE_URL + "dosetype/";
  static final PROYECTOS_URL = BASE_URL + "projects/";
  static final LUGARESRECEPCION_URL = BASE_URL + "recepplaces/";
  static final TIPOSSUPERFICIE_URL = BASE_URL + "surfacetype/";
  static final UNIDADES_URL = BASE_URL + "units/";
  static final OPERADORES_URL = BASE_URL + "users/";

  static final RECORRIDO_URL = BASE_URL + "repRecorrido/";
  static final COMBUSTIBLE_URL = RECORRIDO_URL + "combustible/";

  static final APLICACION_URL = BASE_URL + "repAplicacion/";
  static final OPE_URL = APLICACION_URL + "operador/";
  static final SUP_URL = APLICACION_URL + "supervisor/";

  static final INVENTARIO_URL = BASE_URL + "repInventario/";
  
  static final _API_KEY = "efdab7c6957a5dbba5949361ebeb2513";

  
  Future<User> login(dynamic username, String password) {
    return _netUtil.post(LOGIN_URL, "",
     body: {
        "username": username,
        "password": password
      },
      
    ).then((dynamic res) {
      print(res.toString());
      var token = parseJwt(res['access'].toString());
      // print('get tokeeeeen');
      print(token['user_id'].toString());
      print(token["rol"]);
      
      return new User(token["id"]
          , username
          , password
          , res["access"]
          , token["nombre"]
          , token["apellidos"]
          , token["dni"]
          , token["email"]
          , ""
          , token["rol"]
          , ""
          , token["fechaCreacion"]
          , token["fechaEdicion"]
        );
    });
  }

  Future<dynamic> logout(String token) {
    //print('log out post');
    return _netUtil.post(LOGOUT_URL, token,
     body: {
        "token": token,
      },
      
    ).then((dynamic res) {
      //print(res.toString());
      if(res["error"]!=null) throw new Exception(res["error"]);
      return res;
    });
  } 

 
  
  //desencriptar token 
  Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }
  print(payloadMap);
  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}
   
}