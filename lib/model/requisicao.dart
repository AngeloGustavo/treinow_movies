import 'dart:convert';

import 'package:dio/dio.dart';

class Requisicao {
  final dio = Dio();
  
  Future<bool> login(String usuario, String senha) async {
    Map data = {
    'username': usuario,
    'password': senha,
    'request_token' : ''
    };
    var body = json.encode(data);

    try{var response = await dio.post("https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=e98cff13f2cac177711c2e10f817d147",
        data: body
      );
      return true;
    }
    on Exception{
      return false;
    }
  }
      
  Future<dynamic> getFilmesPopulares() async {
    try{
      var response = await dio.get("https://api.themoviedb.org/3/movie/popular?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR&page=1");      
      return response; 
    }
    on Exception{
      return false; 
    }
  }

  Future<dynamic> getFilmesBemAvaliados() async {
    try{
      var response = await dio.get("https://api.themoviedb.org/3/movie/top_rated?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR&page=1");      
      return response; 
    }
    on Exception{
      return false; 
    }
  }

  Future<dynamic> getFilmesEmBreve() async {
    try{
      var response = await dio.get("https://api.themoviedb.org/3/movie/upcoming?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR&page=1");      
      return response; 
    }
    on Exception{
      return false; 
    }
  }

  Future<dynamic> getElenco(int ID) async {
    try{
      var response = await dio.get("https://api.themoviedb.org/3/movie/$ID/credits?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR");      
      return response; 
    }
    on Exception{
      return false; 
    }
  }

  Future<dynamic> getResultado(String pesquisa) async {
    try {
      var response = await dio.get('https://api.themoviedb.org/3/search/movie?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR&page=1&include_adult=false&query=$pesquisa');
      return response;
    } catch (e) {
      return false;
    }
  } 
}