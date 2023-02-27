import 'dart:ui';
import 'package:flutter/material.dart';
import '../model/Filme.dart';
import '../model/ator.dart';
import '../model/usuario.dart';
import 'feed_page.dart';
bool teste = false;
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
                  if(Usuario.logado == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 340, right: 40),
                      child: Align(alignment: Alignment.bottomRight,child: Filme.filmeTaFavoritado(filme) ? 
                      (IconButton(icon: const Icon(Icons.check_circle, size: 50, color: Color.fromARGB(174, 255, 255, 255),),  onPressed: () { 
                        setState(() {
                          Filme.removerDeFavorito(filme);
                          Usuario.escreverNoArquivo();
                        }); 
                      },)):
                      (IconButton(icon: const Icon(Icons.add_circle, size: 50,color: Color.fromARGB(174, 255, 255, 255),),  onPressed: () { 
                        setState(() {
                          Usuario.minhaLista.add(filme);
                          Usuario.escreverNoArquivo();
                        });
                      },)),),
                    ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(filme.title, style: const TextStyle(color: Colors.white, fontSize: 40),  textAlign: TextAlign.center,),
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: Column(
                              children: [
                                Text(filme.releaseDate, style: const TextStyle(color: Colors.white, fontSize: 20)),
                                Text(filme.genre, style: const TextStyle(color: Colors.white, fontSize: 15)),    
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(height:60,width:60,child: Stack(children: [const Align(alignment:Alignment.center,child: Icon(Icons.circle, color: Color.fromARGB(201, 255, 255, 255), size: 60,)), Align(alignment:Alignment.center,child: Text('${filme.voteAverage.toStringAsFixed(1)}',style: const TextStyle(color: Color.fromARGB(220,0,0,0), fontSize: 20, fontWeight: FontWeight.w700),))],)),
                          ),
                        ),
                      ],
                    ),          
                  ],
                ),
              ),Padding(
                padding: const EdgeInsets.only(left: 15, right: 15,),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Sinopse', style: TextStyle(color: Colors.white, fontSize: 30))
                      ),
                    ),
                    Text(filme.overview, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),  textAlign: TextAlign.justify,)  
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Elenco', style: TextStyle(color: Colors.white, fontSize: 30))
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      for(int i=0; i<filme.elenco.length; i++)
                        atorBox(filme.elenco[i]),
                    ],),
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
Widget atorBox(Ator ator){
  return SizedBox(
    height: 200,
    width: 110,
    child: Column(
      children: [
        (ator.imagemPath != null) ? Image.network('https://image.tmdb.org/t/p/w500/'+ator.imagemPath!, height: 135, width: 100, fit: BoxFit.fitWidth,) : Container(height: 135, width: 100, color: Colors.grey, child: Icon(Icons.person),),
        Column(
          children: [
            Text(ator.nome, style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center,),
            Text(ator.personagem, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center,)
          ],
        ),
      ],
    ),
  );
}