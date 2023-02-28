import 'package:flutter/material.dart';
import '../model/filme.dart';
import '../model/ator.dart';
import 'detalhes_page.dart';

class AtorPage extends StatefulWidget {
  Ator ator;
  AtorPage(this.ator, {super.key});

  @override
  State<AtorPage> createState() => _AtorPageState(ator);
}

class _AtorPageState extends State<AtorPage> {
  _AtorPageState(this.ator);
  Ator ator;  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(        
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Image.asset('asset/logoAppBar.png', fit: BoxFit.cover)),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder( 
          future: Filme.carregarFilmesAtor(ator),
          builder: (context, snapshot) {
            if(ator.filmes.isEmpty) {
              return Container();
            }
            else{
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50, left: 50, top: 150),
                        child: Align(alignment:Alignment.centerLeft, child: Row(
                          children: [
                            (ator.imagemPath != null) ? Image.network('https://image.tmdb.org/t/p/w500/${ator.imagemPath!}', height: 135, width: 100, fit: BoxFit.fitWidth,) : Container(height: 135, width: 100, color: Colors.grey, child: Icon(Icons.person),),
                            Flexible(child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(ator.nome, style: const TextStyle(color: Colors.white, fontSize: 40),),
                            )),
                          ],
                        )),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        child:  Align(alignment: Alignment.bottomLeft,child: Text('Filmes', style: TextStyle(color: Colors.white, fontSize: 25),),),
                      ),
                      SingleChildScrollView(
                        child: Wrap(children: [
                          for(int i=0; i<ator.filmes.length; i++)
                            filmeBox(ator.filmes[i], context)
                        ],),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
      ),);
  }
}

Widget filmeBox(Filme filme, BuildContext context){
  return InkWell(
    onTap:() {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => 
          DetalhesPage(filme, false)
        ));
    },
    child: Container(  
      height: 160, 
      width: 106.6, 
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
    ),
  );
}