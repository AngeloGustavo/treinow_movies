import 'dart:io';

import 'Filme.dart';
import 'package:path_provider/path_provider.dart';

class Usuario {
  static bool logado = false;
  static String login = '';
  static String senha = '';
  static List<Filme> minhaLista = [];

  static Future<String> diretorioUsuarios() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/usuarios/';
  }

  static Future<bool> checarSeJaExisteUsuario(String _login) async{
    var diretorioDeUsuarios = Directory(await diretorioUsuarios());
    diretorioDeUsuarios.createSync(recursive: true);
    List<FileSystemEntity> diretorios = diretorioDeUsuarios.listSync();
    for(int i = 0; i < diretorios.length; i++) {
      if(diretorios[i].path.substring(61, diretorios[i].path.length-4) == _login) {
        return true;
      }
    }
    return false;
  }
  
  static Future<bool> autenticarUsuario(String _login, String _senha) async {
    bool resultado = await checarSeJaExisteUsuario(_login);
    if(resultado == true){
      File file = File('${await diretorioUsuarios()}$_login.txt');
      String a = await file.readAsString();
      var senha = a.split(';');
      if(senha[1] == _senha){
        for(int i=2; i<senha.length-1; i++){
          Usuario.minhaLista.add(await Filme.getFilmeByID(senha[i]));
        }
        return true;
      }
    }
    return false;
  }

  static Future<bool> registrarUsuario(String _login, String _senha) async {
    bool resultado = await checarSeJaExisteUsuario(_login);
    if(resultado == false){
      String texto = '$_login;$_senha;';
      File file = File('${await diretorioUsuarios()}$_login.txt');
      file.writeAsString(texto);
      return true;
    }
    return false;
  }

  static void escreverNoArquivo()async{
    String texto = '${Usuario.login};${Usuario.senha};';
    for(int i=0; i<Usuario.minhaLista.length; i++){
      texto += '${Usuario.minhaLista[i].id};';
    }
    File file = File('${await diretorioUsuarios()}${Usuario.login}.txt');
    file.writeAsString(texto);
  }
}