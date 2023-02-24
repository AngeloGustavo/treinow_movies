import 'package:flutter/material.dart';
import '../model/Filme.dart';
import 'detalhes_page.dart';

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
    Filme.filmesPesquisa.clear();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(children: [
        Container(
          color: Color.fromARGB(73, 158, 158, 158),
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
                    Navigator.pop(context);
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => 
                      PesquisaPage(pesquisaController.text)
                    ));
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
    );
  }
}

Widget filmesEncontrados(BuildContext context,List<Filme> filmesPesquisa){
  return Expanded(
    child: SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top:15, left: 10, bottom: 10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: const Text('Resultados', style: TextStyle(color: Colors.white, fontSize: 20),)
          ),
        ),
        for(int i=0; i<filmesPesquisa.length; i++)
          Row(
            children: [
              filmeBox(context, filmesPesquisa[i])
            ],
          )
      ],),
    ),
  );
}

Widget filmeBox(BuildContext context, Filme filme){
  return InkWell(
    onTap: () {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => 
          DetalhesPage(filme)
        ));
    },
    child: Container(
      margin: EdgeInsets.all(2),
      color: Color.fromARGB(40, 158, 158, 158),
      child: Row(
        children: [
          Container(  
            height: 67.5, 
            width: 120, 
            margin: const EdgeInsets.all(5), 
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 50, 50, 50),
            ),
            child: Stack(
              children: [
                filme.backdropPath != '' ? Image.network(filme.backdropPath) : Image.network('https://i.pinimg.com/736x/3a/11/3f/3a113fe16e48d077df4cdef57a82adea.jpg', width: 140,),
                // Padding(
                //   padding: const EdgeInsets.only(left: 100, top: 190),
                //   child: nota((filme.voteAverage*10).round(), 1),
                // )
              ],
            ),
          ),
          Column(
            children: [
              Text(filme.title, style: const TextStyle(color: Colors.white, fontSize: 15),),
              Text((filme.releaseDate).substring(0,4), style: const TextStyle(color: Color.fromARGB(143, 255, 255, 255), fontSize: 10),),
            ],
          )
        ],
      ),
    ),
  );
}