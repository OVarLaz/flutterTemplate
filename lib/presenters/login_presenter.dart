import 'package:template/database/rest_datasource.dart';
import 'package:template/models/user.dart';
import 'package:template/database/database_helper.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onDownloading(int descargando);
  void onLoginError(String errorTxt);
  void onInmobiliariaSuccess(int response);
  void onInmobiliariaError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

   

  doLogin(dynamic username, String password) async{
    try {
        var user = await api.login(username, password);
        processLoginSuccess(user);
    }
     on Exception catch(error){
        _view.onLoginError(error.toString().replaceAll('Exception: ', ''));
    }
  
  }   


  void processLoginSuccess(User user) async {
      print(user.dni);

      var db = new DatabaseHelper();
      var existe = await db.getUser(user.dni);
      print('existe....$existe');

      if(existe==null){
        await db.saveUser(user);
      }
      
      if(user!=null){
        // _view.onDownloading(1);
        getProductos(user,db);

        // getProyectos(user, db).then((idsProyectos){
        //   for(int idProyecto in idsProyectos){
        //     getEtapas(idProyecto, user, db).then((idsetapas){
        //       for(int idEtapa in idsetapas){
        //         subagrupaciones(idEtapa, user, db);
        //       }
        //     });
        //     getMediosLlegada(idProyecto, user, db);
        //     getAdicionales(idProyecto, user, db);
        //     getPSec(idProyecto, user, db);
        //   }  
        //   _view.onLoginSuccess(user);
              
        // });
        _view.onLoginSuccess(user);
      }
      
  }
  Future<List<int>> getProductos(User user, DatabaseHelper db) async{
    // var productos = await api.productos(user.token);
    // List<int> ids = await db.fetchProductos(productos);
    // // _view.onProductosSuccess(ids);
    // return ids;  
  }

 
  
}