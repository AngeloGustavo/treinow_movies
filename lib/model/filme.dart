import 'dart:convert';
import 'usuario.dart';
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
    if(filmesPopulares.isEmpty){
      dynamic textoFilme;
      dynamic textoElenco;
      var filler;
      
      for(int i=0; i<3; i++){
        switch (i) {
          case 0:
            textoFilme = await requisicao.getFilmesPopulares();
            break;
          case 1:
            textoFilme = await requisicao.getFilmesBemAvaliados();
            break;
          default:
            textoFilme = await requisicao.getFilmesEmBreve();
        }
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
            (e['genre_ids'].isNotEmpty? await getNomeGenero(e['genre_ids'][0]):''));
          textoElenco = await requisicao.getElenco(filme.id);
          var filler2 = json.decode(textoElenco.toString());
          for (var j in filler2['cast']) {
            filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
          }          
          switch (i) {
            case 0:
              filmesPopulares.add(filme);
              break;
            case 1:
              filmesBemAvaliados.add(filme);
              break;
            default:              
              filmesProximasEstreias.add(filme);
          }
        }
      }
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
        (e['vote_average']), 
        ((e['release_date'].length)>4 ? (e['release_date']).substring(0,4):''), 
        (e['overview']), 
        (e['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${e['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (e['genre_ids'].isNotEmpty? await getNomeGenero(e['genre_ids'][0]):''));
      textoElenco = await requisicao.getElenco(filme.id);
      var filler2 = json.decode(textoElenco.toString());
      for (var j in filler2['cast']) {
        filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
      }
      filmesPesquisa.add(filme);
    }
  }


  static Future<String> getNomeGenero(int id) async {
    Requisicao requisicao = Requisicao();
    dynamic textoGeneros = await requisicao.getGenres();
    var filler = json.decode(textoGeneros.toString());
    for (var e in filler['genres']) {
      if(e['id'] == id){
        return e['name'];
      }
    }
    return '';
  }

  static bool filmeTaFavoritado(Filme filme){
    for(int i=0; i<Usuario.minhaLista.length; i++){
      if(Usuario.minhaLista[i].id == filme.id) {
        return true;
      }
    }
    return false;
  }
  
  static void removerDeFavorito(Filme filme){
    for(int i=0; i<Usuario.minhaLista.length; i++){
      if(Usuario.minhaLista[i].id == filme.id) {
        Usuario.minhaLista.removeAt(i);
      }
    }
  }
  
  static Future<Filme> getFilmeByID(String ID) async {
    Requisicao requisicao = Requisicao();
    dynamic textoFilme = await requisicao.getFilmeByID(ID);
    dynamic textoElenco;
    var e = json.decode(textoFilme.toString());
    Filme filme = Filme(
      int.parse(ID), 
      (e['title']), 
      (0), 
      ((e['release_date'].length)>4 ? (e['release_date']).substring(0,4):''), 
      (e['overview']), 
      (e['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${e['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
      (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
      (e['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${e['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
      (''));
    textoElenco = await requisicao.getElenco(filme.id);
    var filler2 = json.decode(textoElenco.toString());
    for (var j in filler2['cast']) {
      filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
    }
    return filme;
  }
}