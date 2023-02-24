import 'dart:convert';

import 'ator.dart';
import 'requisicao.dart';

class Filme {
  Filme(this.id, this.title, this.voteAverage, this.releaseDate, this.overview, this.posterPath, this.backdropPath, this.backdropOriginalPath, this.genre);

  int id;
  String title;
  double voteAverage;
  String releaseDate;
  String overview;
  String posterPath;
  String backdropPath;
  String backdropOriginalPath;
  String genre;
  List<Ator> elenco = [];
  static List<Filme> filmesPopulares = [];
  static List<Filme> filmesBemAvaliados = [];
  static List<Filme> filmesProximasEstreias = [];
  static List<Filme> filmesPesquisa = [];
  static int paginaAtual = 1;
  static Requisicao requisicao = Requisicao();

  static Future<void> carregarFilmes()async {
    if(paginaAtual == 1) {
      filmesPopulares = [];
      filmesBemAvaliados = [];
      filmesProximasEstreias = [];
    }
    dynamic textoFilme;
    dynamic textoElenco;
    var filler;
    
    textoFilme = await requisicao.getFilmesPopulares();
    filler = json.decode(textoFilme.toString());
    for (var e in filler['results']) {
      Filme filme = Filme(
        (e['id']), 
        (e['title']), 
        (e['vote_average']).toDouble(), 
        ((e['release_date'].length)>4 ? (e['release_date']).substring(0,4):''), 
        (e['overview']), 
        (e['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${e['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['genre_ids'].isNotEmpty? getNomeGenero(e['genre_ids'][0]):''));
      textoElenco = await requisicao.getElenco(filme.id);
      var filler2 = json.decode(textoElenco.toString());
      for (var j in filler2['cast']) {
        filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
      }
      filmesPopulares.add(filme);
    }

    textoFilme = await requisicao.getFilmesBemAvaliados();
    filler = json.decode(textoFilme.toString());
    for (var e in filler['results']) {
      Filme filme = Filme(
        (e['id']), 
        (e['title']), 
        (e['vote_average']).toDouble(), 
        ((e['release_date'].length)>4 ? (e['release_date']).substring(0,4):''), 
        (e['overview']), 
        (e['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${e['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg',
        (e['genre_ids'].isNotEmpty? getNomeGenero(e['genre_ids'][0]):''));
      textoElenco = await requisicao.getElenco(filme.id);
      var filler2 = json.decode(textoElenco.toString());
      for (var j in filler2['cast']) {
        filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
      }
      filmesBemAvaliados.add(filme);
    }

    textoFilme = await requisicao.getFilmesEmBreve();
    filler = json.decode(textoFilme.toString());
    for (var e in filler['results']) {
      Filme filme = Filme(
        (e['id']), 
        (e['title']), 
        (e['vote_average']).toDouble(), 
        ((e['release_date'].length)>4 ? (e['release_date']).substring(0,4):''), 
        (e['overview']), 
        (e['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${e['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg',
        (e['genre_ids'].isNotEmpty? getNomeGenero(e['genre_ids'][0]):''));
      textoElenco = await requisicao.getElenco(filme.id);
      var filler2 = json.decode(textoElenco.toString());
      for (var j in filler2['cast']) {
        filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
      }
      filmesProximasEstreias.add(filme);
    }
  }

  static Future<void> preencherFilmesPesquisa(String pesquisa) async{
    Filme.filmesPesquisa = [];
    Filme.filmesPesquisa.clear();
    dynamic textoFilme = await requisicao.getResultado(pesquisa);
    dynamic textoElenco;
    var filler = json.decode(textoFilme.toString());

    for (var e in filler['results']) {
      Filme filme = Filme(
        (e['id']), 
        (e['title']), 
        (0), 
        ((e['release_date'].length)>4 ? (e['release_date']).substring(0,4):''), 
        (e['overview']), 
        (e['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${e['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['genre_ids'].isNotEmpty? getNomeGenero(e['genre_ids'][0]):''));
      textoElenco = await requisicao.getElenco(filme.id);
      var filler2 = json.decode(textoElenco.toString());
      for (var j in filler2['cast']) {
        filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
      }
      print(filme.title);
      filmesPesquisa.add(filme);
      if(filmesPesquisa.length >= 10) {
        break;
      }
    }
  }

  //Refazer e colocar em Requisicao.dart
  //String getNomeGenero(int IdGenero){ requisicao -> getGenero }
  static String getNomeGenero(int id){
    Map<int,String> listaGenero = {
      12 : "Aventura",
      14 : "Fantasia",
      16 : "Animação",
      18 : "Drama",
      27 : "Horror",
      28 : "Ação",
      35 : "Comédia",
      36 : "Historia",
      37 : "Velho Oeste",
      53 : "Terror",
      80 : "Crime",
      99 : "Documentario",
      878 : "Ficção Científica",
      9648 : "Mysterio",
      10402 : "Musical",
      10749 : "Romance",
      10751 : "Família",
      10752 : "Guerra",
      10770 : "Série",
    };
    if(listaGenero[id] == null) {
      return '';
    }
    return listaGenero[id]!;
  }
}