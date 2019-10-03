import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;



class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, String token) {
    // print ('printtttt $url, $token');
    print('get.......!!');
    print ('printtttt $url');
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
        HttpHeaders.contentTypeHeader: 'application/json',
    }).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      // print('res...S $res');
      if (statusCode < 200 || statusCode > 400 || json == null) {
        switch(statusCode){
          case 401 : throw new Exception("Credenciales Inválidas");
            break;
          case 403 : throw new Exception("Acceso Denegado");
            break;
          default : throw new Exception(_decoder.convert(res)["message"]);
        }
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> getimg(String url, String token) {
    print('getimg.......!!');
    print('url $url');
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'image/jpeg',
    }).then((http.Response response) {
      // final String res = response.body;
      // final int statusCode = response.statusCode;
      //print('res $response');
      // return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, String token, {Map headers, body, encoding}) {
    print('url: $url .... body: $body');
    return http.post(url,
      body: json.encode(body), headers: {
        HttpHeaders.authorizationHeader: "Bearer " + token,
        HttpHeaders.contentTypeHeader: 'application/json'
      },
        encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      //print(statusCode);
      //print(res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        //print('entro a  listado errores');
        switch(statusCode){
          case 401 : throw new Exception("Credenciales Inválidas");
            break;
          case 403 : throw new Exception("Acceso Denegado");
            break;
          default : throw new Exception(_decoder.convert(res)["message"]);
        }
                
      }
      return _decoder.convert(res);
    });
  }

  

}