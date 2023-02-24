import 'package:flutter/material.dart';
import 'package:treinow_movies/view/pesquisa_page.dart';
import 'detalhes_page.dart';
import '../model/Filme.dart';
import '../model/requisicao.dart';

class FeedPage extends StatefulWidget {
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Filme.carregarFilmes(),
        builder: (context, snapshot) {
          if (Filme.filmesPopulares.isNotEmpty) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => 
                            PesquisaPage(null)
                          ));
                      },
                      child: const Icon(
                        Icons.search_rounded,
                        size: 26.0,
                        color: Colors.white,
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        
                      },
                      child: const Icon(
                        Icons.account_box_rounded,
                        size: 26.0,
                        color: Colors.white,
                      ),
                    )
                  ),
                ]
              ),
              body:  SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            child: Stack(children: [
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.white, Color.fromARGB(0, 22, 22, 22)],
                                      ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                                },
                                blendMode: BlendMode.dstIn,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: NetworkImage(Filme.filmesPopulares[0].backdropPath),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Image.asset('lib/assets/recomendacao.png', height: 100,)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(35),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    Filme.filmesPopulares[0].title, 
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 30),
                                  )
                                ),
                              ),
                            ],),
                          ),
                          listaDeFilmes(context,'Populares', Filme.filmesPopulares),
                          listaDeFilmes(context,'Mais bem avaliados', Filme.filmesBemAvaliados),
                          listaDeFilmes(context,'Próximas Estreias', Filme.filmesProximasEstreias),
                        ],
                      ),
                    ),);
          } else {
            return Scaffold(
              body: Container(
                color: Color.fromARGB(255, 239, 52, 30), 
                child: Center(
                  child: Image.asset('lib/assets/logo.png', width: 300,),
                ),
              )
            );
          }
        }
    );
  }
}

Widget listaDeFilmes(BuildContext context, String titulo, List<Filme> listaFilmes){
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(color: Colors.black),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 20, left: 10),
          height: 50,
          child: Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 20),)
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[     
            for(Filme filmeSelecionado in listaFilmes)
              InkWell(
                child: filmeBox(filmeSelecionado),
                onTap:() {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => 
                    DetalhesPage(filmeSelecionado)
                  ));
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
Future<void> caregarFilmes() async {
  Requisicao requisicoes = Requisicao();
  // String? filmes = await requisicoes.getFilmes();
}
Widget filmeBox(Filme filme){
  return Container(  
    height: 180, 
    width: 120, 
    margin: const EdgeInsets.all(5), 
    decoration: const BoxDecoration(
        color: Color.fromARGB(255, 50, 50, 50),
    ),
    child: Stack(
      children: [
        Image.network(filme.posterPath, width: 120, height: 180,),
        // Padding(
        //   padding: const EdgeInsets.only(left: 100, top: 190),
        //   child: nota((filme.voteAverage*10).round(), 1),
        // )
      ],
    ),
  );
}