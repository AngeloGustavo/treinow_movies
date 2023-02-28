import 'package:flutter/material.dart';
import '../model/filme.dart';
import 'detalhes_page.dart';
import 'feed_page.dart';

class PesquisaPage extends StatefulWidget {
  String? pesquisa;
  PesquisaPage(this.pesquisa, {super.key});

  @override
  State<PesquisaPage> createState() => _PesquisaPageState(pesquisa);
}

class _PesquisaPageState extends State<PesquisaPage> {
  String? pesquisa;
  _PesquisaPageState(this.pesquisa);
  TextEditingController pesquisaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Filme.filmesPesquisa = [];
    Filme.filmesPesquisa.clear();
    return WillPopScope(
      onWillPop: () { 
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => FeedPage(),
          ),
        );
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(onPressed: ()=> {             
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => FeedPage(),
              ),
            )          
          }, icon: const Icon(Icons.arrow_back)),
        ),
        body: Column(children: [
          Container(
            color: const Color.fromARGB(73, 158, 158, 158),
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Busque um filme com alguma palavra chave.',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(155, 255, 255, 255),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    controller: pesquisaController,
                  ),
                ),
                InkWell(
                  child: Container( margin: const EdgeInsets.all(15),child: const Icon(Icons.search, color: Colors.white,)),
                  onTap: () {                      
                    setState(() {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => PesquisaPage(pesquisaController.text),
                        ),
                      );
                    });
                  },
                )
              ],
            ),
          ),
          FutureBuilder(
            future: Filme.preencherFilmesPesquisa(pesquisa != null ? pesquisa! : ''),
            builder: (context, snapshot){
              if(Filme.filmesPesquisa.isNotEmpty) {
                return filmesEncontrados(context, Filme.filmesPesquisa);
              } else if(pesquisa == null) {
                return Container();
              } else {
                return const Expanded(child: Center(child: Text('Pesquisando...', style: TextStyle(color: Colors.white),),));
              }
            }            
          )
        ]),
      ),
    );
  }
}

Widget filmesEncontrados(BuildContext context,List<Filme> filmesPesquisa){
  return Expanded(
    child: SingleChildScrollView(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.only(top:15, left: 10, bottom: 10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text('Principais Resultados', style: TextStyle(color: Colors.white, fontSize: 20),)
          ),
        ),
        for(int i=0; i<filmesPesquisa.length; i++)
          filmeBox(context, filmesPesquisa[i])
      ],),
    ),
  );
}

Widget filmeBox(BuildContext context, Filme filme){
  return InkWell(
    onTap: () {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => 
          DetalhesPage(filme, false)
        ));
    },
    child: Container(
      margin: const EdgeInsets.all(2),
      color: const Color.fromARGB(40, 158, 158, 158),
      child: Row(
        children: [
          Container(  
            height: 67.5, 
            width: 120, 
            margin: const EdgeInsets.all(5), 
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 50, 50, 50),
            ),
            child: Image.network(filme.backdropPath),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(filme.titulo, style: const TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,),
                  Text(filme.ano, style: const TextStyle(color: Color.fromARGB(143, 255, 255, 255), fontSize: 10),),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}