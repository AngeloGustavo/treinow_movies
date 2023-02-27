import 'dart:convert';
import 'usuario.dart';
import 'ator.dart';
import 'requisicao.dart';

class Filme {
  Filme(this.id, this.titulo, this.nota, this.ano, this.sinopse, this.posterPath, this.backdropPath, this.backdropOriginalPath, this.genero);

  int id;
  String titulo;
  double nota;
  String ano;
  String sinopse;
  String posterPath;
  String backdropPath;
  String backdropOriginalPath;
  String genero;
  List<Ator> elenco = [];
  static List<Filme> filmesPopulares = [];
  static List<Filme> filmesBemAvaliados = [];
  static List<Filme> filmesProximasEstreias = [];
  static List<Filme> filmesPesquisa = [];
  static int paginaAtual = 1;
  static Requisicao requisicao = Requisicao();

  static Future<void> carregarFilmes()async {
    if(filmesPopulares.isEmpty){
      dynamic textoFilmePopulares = json.decode(await requisicao.getFilmesPopulares());
      dynamic textoFilmeBemAvaliados = json.decode(await requisicao.getFilmesBemAvaliados());
      dynamic textoFilmeEmBreve = json.decode(await requisicao.getFilmesEmBreve());
      var filler;      
      for(int i=0; i<3; i++){
        switch (i) {
          case 0:         
            filler = textoFilmePopulares;
            break;
          case 1:
            filler = textoFilmeBemAvaliados;
            break;
          default:
            filler = textoFilmeEmBreve;
        }
        for (var dados in filler['results']) {
          print(dados['genre']);
          Filme filme = Filme(
            (dados['id']), 
            (dados['title']), 
            (dados['vote_average']).toDouble(), 
            ((dados['release_date'].length)>4 ? (dados['release_date']).substring(0,4):''), 
            (dados['overview']), 
            (dados['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${dados['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
            (dados['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${dados['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
            (dados['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${dados['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
            (getNomeGenero(dados['genre'])));        
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
    var filler = json.decode(textoFilme.toString());

    for (var dados in filler['results']) {
      Filme filme = Filme(
        (dados['id']), 
        (dados['title']), 
        (dados['vote_average']), 
        ((dados['release_date'].length)>4 ? (dados['release_date']).substring(0,4):''), 
        (dados['overview']), 
        (dados['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${dados['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (dados['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${dados['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (dados['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${dados['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
        (dados['genre']!=null && [0]!=null?getNomeGenero(dados['genre'][0]):''));
      filmesPesquisa.add(filme);
    }
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
    var dados = json.decode(textoFilme.toString());
    Filme filme = Filme(
      int.parse(ID), 
      (dados['title']), 
      (dados['vote_average']), 
      ((dados['release_date'].length)>4 ? (dados['release_date']).substring(0,4):''), 
      (dados['overview']), 
      (dados['poster_path'] != null)? "https://image.tmdb.org/t/p/w500${dados['poster_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
      (dados['backdrop_path'] != null)? "https://image.tmdb.org/t/p/w500${dados['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
      (dados['backdrop_path'] != null)? "https://image.tmdb.org/t/p/original${dados['backdrop_path']}" : 'https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', 
      (dados['genre']!=null && [0]!=null?getNomeGenero(dados['genre'][0]):''));
    return filme;
  }

  static Future<void> carregarElenco(Filme filme) async {
    var filler = json.decode((await requisicao.getElenco(filme.id)).toString());
    for (var j in filler['cast']) {
      filme.elenco.add(Ator(j['name'], j['character'], j['profile_path']));
    }      
  }

  //Para agilizar o carregamento das paginas não foi usado a requisição de pegar Genero por Id
  static String getNomeGenero(int? genreId){
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
    if(genreId == null || listaGenero[genreId]![0] == null) {
      return '-';
    }
    return listaGenero[genreId]!;
  }
}