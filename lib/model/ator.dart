import 'filme.dart';

class Ator{
  Ator(this.nome, this.personagem, this.imagemPath, this.id);
  String nome;
  int id;
  String personagem;
  String? imagemPath;
  List<Filme> filmes = [];
}