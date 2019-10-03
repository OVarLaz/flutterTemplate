import 'package:template/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:flutter/painting.dart';


class DatabaseHelper {
    static final DatabaseHelper _instance = new DatabaseHelper.internal();
    factory DatabaseHelper() => _instance;

    static Database _db;
    var directory_img;

    String usersTable = "usuarios";//users
    String productsTable = "products";
    String projectsTable = "projects";
    String companiesTable = "companies";
    String dosetypeTable = "dosetype";
    String recepplacesTable = "recepplaces";
    String stretchsTable = "stretchs";
    String surfacetypeTable = "surfacetype";
    String unitsTable = "units";
    String operatorsTable = "operators";

    String repInventarioTable = "repInventario";
    String repRecorridoCombustibleTable = "repRecorridoCombustible";
    String repRecorridoTable = "repRecorrido";
    String repAplicacionOperadorTable = "repAplicacionOperador";
    String repAplicacionSupervisorTable = "repAplicacionSupervisor";

    String colId = 'id';

    Future<Database> get db async{
       
        if(_db != null){
            return _db;
        }
        _db = await initDB();
        return _db;
    }

    DatabaseHelper.internal();

    Future<Database> initDB() async{
        io.Directory documentDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentDirectory.path, "template3.db");
  
        var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
       
        return ourDB;
    }

    void _onCreate(Database db, int version) async{

      await db.execute(
      "CREATE TABLE $usersTable (codigo TEXT, user_id INTEGER, username TEXT, password TEXT, token TEXT, nombre TEXT, apellido TEXT, dni TEXT PRIMARY KEY, email TEXT, telefono TEXT, rol TEXT, imagen TEXT DEFAULT NULL, fechaCreacion TEXT, fechaEdicion TEXT)");
      //print("tabla usuario creada");

     
    }

    Future<int> saveUser(User user) async {
      var dbClient = await db;
      int res;

      // if(user.imagen!=null || user.imagen!="")
      // {
      //   print('en el if.....');
      //   String pathDirectory;

      //   io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      //   directory_img = new io.Directory(documentDirectory.path +"/usuarios").create(recursive: true)
      //   .then((io.Directory directory) async{
      //     pathDirectory = directory.path;

      //       var nameImage = user.imagen;
      //       nameImage = user.imagen.substring(nameImage.lastIndexOf('/'), nameImage.length);
      //       // //print(user.imagen);
      //       // //print('user imagen');
      //       var pathImage = pathDirectory + nameImage;
      //       download(user.imagen, pathImage);
      //       user.imagen = pathImage;
      //       res = await dbClient.insert("$usersTable", user.toMap());

      //   });
      // }
      // else{
        res = await dbClient.insert("$usersTable", user.toMap());
        print('saveuser..... $res');
      // }
      
      return 1;
    }

    Future<dynamic> updateUser(User user) async{
      var dbClient = await db;
      dynamic result = await dbClient.update("$usersTable", user.toMap(), where: 'dni = ?', whereArgs: [user.dni]);
      
      return result;
    }

    Future<User> getFirstUser() async {
      var dbClient = await db;
      List<Map> list = await dbClient.rawQuery('SELECT * FROM $usersTable');
      if (list.isNotEmpty) {
        var element = list.elementAt(0);
        return new User(
           element["user_id"]
          , element["username"]
          , element["password"]
          , element["token"]
          , element["nombre"]
          , element["apellido"]
          , element["dni"]
          , element["email"]
          , element["telefono"]
          , element["rol"]
          , element["imagen"]
          , element["fechaCreacion"]
          , element["fechaEdicion"]
          );
      } else {
        return null;
      }
    }
    getUser(var dni) async {
      print('soy dni............$dni');
      final dbClient = await db;
      var res = await  dbClient.query("$usersTable", where: "dni = ?", whereArgs: [dni]);
      print('res....$res');
      return res.isNotEmpty ? User.fromJson(res.first) : null ;
    }

    getAll() async {
      final dbClient = await db;
      var res = await dbClient.rawQuery('SELECT * FROM $usersTable');
      print('res....$res');
      return res;
    }

    deleteUser(var dni) async {
      final dbClient = await db;
      dbClient.delete("$usersTable", where: "dni = ?", whereArgs: [dni]);
    }

    Future<dynamic> deleteUsers() async {
      var dbClient = await db;
      dynamic res = await dbClient.delete("$usersTable");
      return res;
    }

    Future<bool> isLoggedIn() async {
      var dbClient = await db;
      var res = await dbClient.query("$usersTable");
      return res.length > 0? true: false;
    }

    void download(String url, String path)
    {
        var data = http.readBytes(url);
        data.then((buffer){
          io.File f = new io.File(path);
          io.RandomAccessFile rf = f.openSync(mode: io.FileMode.WRITE);
          rf.writeFromSync(buffer);
          rf.flushSync();
          rf.closeSync();

      });
      
    }
    // void downloadResize(String url, String path)
    // {
    //     var data = http.readBytes(url);
    //     data.then((buffer){
    //       io.File f = new io.File(path);
    //       io.RandomAccessFile rf = f.openSync(mode: io.FileMode.WRITE);
    //       rf.writeFromSync(buffer);
    //       rf.flushSync();
    //       rf.closeSync();

    //       //Load the image
    //       Image image = decodeImage(new io.File(path).readAsBytesSync());

    //       // //resize the image
    //       // Image thumbnail = copyResize(image, 200);

    //       // new io.File(path)
    //       // ..writeAsBytesSync(encodePng(thumbnail));
    //   });
      
    // }

    void deleteImage(String path){
      var file = io.File(path);
      file.delete();
      // imageCache.clear();
    }

    void listarArchivos(String path) async {
      var dir = io.Directory(path);

      try {
        var dirList = dir.list();
        await for (io.FileSystemEntity f in dirList) {
          // //print(f);
          if (f is io.File) {
            // //print('Found file ${f.path}');
          } else if (f is io.Directory) {
            // //print('Found dir ${f.path}');
          }
        }
      } catch (e) {
        // //print(e.toString());
      }
    }

      


}