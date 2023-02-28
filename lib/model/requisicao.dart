import 'package:dio/dio.dart';

class Requisicao {
  final dio = Dio();
      
  Future<dynamic> getFilmesPopulares() async {
    try{
      var response = await dio.get("https://api.themoviedb.org/3/movie/popular?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR&page=1");      
      return response.toString(); 
    }
    on Exception{
      return false; 
    }
  }

  Future<dynamic> getFilmesBemAvaliados() async {
    try{
      var response = await dio.get("https://api.themoviedb.org/3/movie/top_rated?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR&page=1");      
      return response.toString(); 
    }
    on Exception{
      return false; 
    }
  }

  Future<dynamic> getFilmesEmBreve() async {
    try{
      var response = await dio.get("https://api.themoviedb.org/3/movie/upcoming?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR&page=1");      
      return response.toString(); 
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


  Future<dynamic> getStreamings(int ID) async {
    try{
      var response = await dio.get("https://api.themoviedb.org/3/movie/$ID/watch/providers?api_key=e98cff13f2cac177711c2e10f817d147&watch_region=BR");      
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

  Future<dynamic> getFilmeByID(String ID) async{
    try {
      var response = await dio.get('https://api.themoviedb.org/3/movie/$ID?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR');
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getGenres() async{
    try {
      var response = await dio.get('https://api.themoviedb.org/3/genre/movie/list?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR');
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> getFilmesAtor(String ID) async{
    try {
      var response = await dio.get('https://api.themoviedb.org/3/person/$ID/movie_credits?api_key=e98cff13f2cac177711c2e10f817d147&language=pt-BR');
      return response;
    } catch (e) {
      return false;
    }
  }
}