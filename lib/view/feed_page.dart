import 'package:flutter/material.dart';
import 'package:treinow_movies/model/usuario.dart';
import 'package:treinow_movies/view/pesquisa_page.dart';
import 'detalhes_page.dart';
import 'log_page.dart';
import '../model/filme.dart';

class FeedPage extends StatefulWidget {
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>{
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
                title: Image.asset('asset/logoAppBar.png', fit: BoxFit.cover),
                backgroundColor: Colors.transparent,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => PesquisaPage(null),
                          ),
                        );
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
                        if(Usuario.logado == false) {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => 
                            const LogPage()
                          ));
                        }
                        else{
                          setState(() {
                            Usuario.logado = false;
                            Usuario.login = '';
                            Usuario.senha = '';
                            Usuario.minhaLista = [];
                          });
                        }
                      },
                      child: Icon(
                        (Usuario.logado == false) ? Icons.account_box_rounded : Icons.exit_to_app,
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
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => 
                                DetalhesPage(Filme.filmesProximasEstreias[0], true)
                              ));
                            },
                            child: SizedBox(
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
                                        fit: BoxFit.fitHeight,
                                        image: NetworkImage(Filme.filmesProximasEstreias[0].backdropOriginalPath),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                   padding: const EdgeInsets.only(top: 300),
                                   child: Column(
                                     children: [
                                       Text(
                                         Filme.filmesProximasEstreias[0].titulo, 
                                         textAlign: TextAlign.center,
                                         style: const TextStyle(color: Colors.white, fontSize: 30),
                                       ),
                                       const Text(
                                        'Recomendação', 
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Color.fromARGB(169, 255, 255, 255), fontSize: 15, fontStyle: FontStyle.italic),
                                      ),
                                     ],
                                   ),
                                  ),
                                ),
                              ],),
                            ),
                          ),
                          if(Usuario.logado == true && Usuario.minhaLista.isNotEmpty)
                            listaDeFilmes(context,'Minha Lista', Usuario.minhaLista),
                          listaDeFilmes(context,'Populares', Filme.filmesPopulares),
                          listaDeFilmes(context,'Mais bem avaliados', Filme.filmesBemAvaliados),
                          listaDeFilmes(context,'Próximas Estreias', Filme.filmesProximasEstreias),
                        ],
                      ),
                    ),);
          } else {
            return Scaffold(
              body: Container(
                color: const Color.fromARGB(255, 239, 52, 30), 
                child: Center(
                  child: Image.asset('asset/logo.png', width: 300,),
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
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => DetalhesPage(filmeSelecionado, true),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
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
        Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(height:40,width:40,child: Stack(children: [const Align(alignment:Alignment.center,child: Icon(Icons.circle, color: Color.fromARGB(201, 0, 0, 0), size: 35,)), Align(alignment:Alignment.center,child: Text(filme.nota.toStringAsFixed(1),style: const TextStyle(color: Color.fromARGB(220, 255, 255, 255), fontSize: 15),))],)),
        ),
      ],
    ),
  );
}