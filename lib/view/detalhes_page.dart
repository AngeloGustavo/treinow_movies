import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:treinow_movies/view/ator_page.dart';
import '../model/filme.dart';
import '../model/ator.dart';
import '../model/usuario.dart';
import 'feed_page.dart';

class DetalhesPage extends StatefulWidget {
  bool veioDoFeed;
  Filme filme;
  DetalhesPage(this.filme, this.veioDoFeed);

  @override
  State<DetalhesPage> createState() => _DetalhesPageState(filme, veioDoFeed);
}

class _DetalhesPageState extends State<DetalhesPage> {
  _DetalhesPageState(this.filme, this.veioDoFeed);
  Filme filme;
  bool veioDoFeed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){       
        if(veioDoFeed == true) {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => FeedPage(),
            ),
          );
        }
        else{
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor:Colors.transparent,
          leading: IconButton(onPressed: ()=> { 
            if(veioDoFeed == true)            
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => FeedPage(),
                ),
              ) 
            else
              Navigator.pop(context)
          }, icon: const Icon(Icons.arrow_back)),
        ),      
        body: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: CustomScrollView(slivers: [SliverFillRemaining(
            hasScrollBody: false,
            child: Column(children: [
              Stack(
                children: [
                  Container(
                    height: 450,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(filme.backdropPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Center(child: Image.network(filme.posterPath,height: 250,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 340,right: 40),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(height:60,width:60,child: Stack(children: [const Align(alignment:Alignment.center,child: Icon(Icons.circle, color: Color.fromARGB(201, 255, 255, 255), size: 60,)), Align(alignment:Alignment.center,child: Text(filme.nota.toStringAsFixed(1),style: const TextStyle(color: Color.fromARGB(220,0,0,0), fontSize: 20, fontWeight: FontWeight.w700),))],)),
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(filme.titulo, style: const TextStyle(color: Colors.white, fontSize: 40),  textAlign: TextAlign.center,),
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Center(
                            child: Column(
                              children: [
                                Text(filme.ano, style: const TextStyle(color: Colors.white, fontSize: 20)),
                                Text(filme.genero, style: const TextStyle(color: Colors.white, fontSize: 15)),    
                              ],
                            ),
                          ),
                        ),
                        if(Usuario.logado == true)
                          Container(
                            padding: const EdgeInsets.only( right: 40, ),
                            child: Align(alignment: Alignment.topRight,child: Column(
                              children: [
                                Filme.filmeTaFavoritado(filme) ? 
                                (IconButton(icon: const Icon(Icons.check, size: 50, color: Color.fromARGB(174, 255, 255, 255),),  onPressed: () { 
                                  setState(() {
                                    Filme.removerDeFavorito(filme);
                                    Usuario.escreverNoArquivo();
                                  }); 
                                },)):
                                (IconButton(icon: const Icon(Icons.add, size: 50,color: Color.fromARGB(174, 255, 255, 255),),  onPressed: () { 
                                  setState(() {
                                    Usuario.minhaLista.add(filme);
                                    Usuario.escreverNoArquivo();
                                  });
                                },)),
                                const Padding(
                                  padding: EdgeInsets.only(left: 17, top: 5),
                                  child: Text('Minha Lista', style: TextStyle(color: Colors.white, fontSize: 10),),
                                )
                              ],
                            ),),
                          ),
                      ],
                    ),          
                  ],
                ),
              ),Padding(
                padding: const EdgeInsets.only(left: 10, right: 10,),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Sinopse', style: TextStyle(color: Colors.white, fontSize: 30))
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(filme.sinopse, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),  textAlign: TextAlign.justify,),
                    )  
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Onde assistir', style: TextStyle(color: Colors.white, fontSize: 30))
                  ),
                  FutureBuilder(
                    future: Filme.carregarStreamings(filme),
                    builder: (context, snapshot) {
                      if(filme.streamings.isEmpty){
                        return Container();
                      }
                      else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            for(int i=0; i<filme.streamings.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect( borderRadius: BorderRadius.circular(10),child: Image.network('https://image.tmdb.org/t/p/original${filme.streamings[i]}', width: 50,)),
                              ),
                          ],),
                        );
                      }
                    }
                  )
                ],),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Elenco', style: TextStyle(color: Colors.white, fontSize: 30))
                  ),
                  FutureBuilder(
                    future: Filme.carregarElenco(filme),
                    builder: (context, snapshot) {
                      if(filme.elenco.isEmpty){
                        return Container();
                      }
                      else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            for(int i=0; i<filme.elenco.length; i++)
                              atorBox(filme.elenco[i], context),
                          ],),
                        );
                      }
                    }
                  )
                ],),
              ),
              Expanded(child: Container(color: Colors.black)),
            ]),
          )],
          ),
        ),
      ),
    );
  }
}
Widget atorBox(Ator ator, BuildContext context){
  return InkWell(
    onTap:() {
       Navigator.push(context,
        MaterialPageRoute(builder: (context) => 
          AtorPage(ator)
        ));
    },
    child: SizedBox(
      height: 200,
      width: 110,
      child: Column(
        children: [
          (ator.imagemPath != null) ? Image.network('https://image.tmdb.org/t/p/w500/${ator.imagemPath!}', height: 135, width: 100, fit: BoxFit.fitWidth,) : Container(height: 135, width: 100, color: Colors.grey, child: Icon(Icons.person),),
          Column(
            children: [
              Text(ator.nome, style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center,),
              Text(ator.personagem, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center,)
            ],
          ),
        ],
      ),
    ),
  );
}