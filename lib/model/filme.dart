import 'dart:convert';

import 'ator.dart';
import 'requisicao.dart';

class Filme {
  Filme(this.id, this.title, this.voteAverage, this.releaseDate, this.overview, this.posterPath, this.backdropPath, this.genreId);

  int id;
  String title;
  double voteAverage;
  String releaseDate;
  String overview;
  String posterPath;
  String backdropPath;
  int genreId;
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
      Filme filme = Filme(e['id'], e['title'], (e['vote_average']).toDouble(), e['release_date'], e['overview'], 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2'+e['poster_path'], 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2'+e['backdrop_path'],e['genre_ids'][0]);
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
      Filme filme = Filme(e['id'], e['title'], (e['vote_average']).toDouble(), e['release_date'], e['overview'], 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2'+e['poster_path'], 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2'+e['backdrop_path'],e['genre_ids'][0]);
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
      Filme filme = Filme(e['id'], e['title'], 0, e['release_date'], e['overview'], 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2'+e['poster_path'], 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2'+e['backdrop_path'],e['genre_ids'][0]);
      textoElenco = await requisicao.getElenco(filme.id);
      var filler2 = json.decode(textoElenco.toString());
      for (var j in filler2['cast']) {
        filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
      }
      filmesProximasEstreias.add(filme);
    }
  }

  static Future<void> preencherFilmesPesquisa(String pesquisa) async{
    Filme.filmesPesquisa.clear();
    dynamic textoFilme = await requisicao.getResultado(pesquisa);
    dynamic textoElenco;
    var filler = json.decode(textoFilme.toString());

    for (var e in filler['results']) {
      Filme filme = Filme(e['id'], e['title'], 0, e['release_date'], e['overview'], (e['poster_path'] != null)? "https://image.tmdb.org/t/p/original${e['poster_path']}" : '', (e['backdrop_path'] != null)? 'https://image.tmdb.org/t/p/w500'+e['backdrop_path'] : '',e['genre_ids'].length > 0? e['genre_ids'][0] : 12);
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
  String? getNomeGenero(){
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
    
    return listaGenero[genreId];
  }
}