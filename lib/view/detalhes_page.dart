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
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 240, right: 20),
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: nota((filme.voteAverage*10).round(), 2)),
                  // )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(filme.title, style: const TextStyle(color: Colors.white, fontSize: 40),  textAlign: TextAlign.center,),
              ),
              Text(filme.releaseDate, style: const TextStyle(color: Colors.white, fontSize: 20)),
              Text(filme.genre, style: const TextStyle(color: Colors.white, fontSize: 15)),
              Padding(
                padding: const EdgeInsets.all(10.0),
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

  return Container(
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
// Widget nota(int nota, int pagina){
//   if(pagina == 2) {
//     return Column(
//       children: [
//         Container(
//           height: 65,
//           width: 65,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('images/fundo_nota.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Center(
//             child: RichText(
//               text: TextSpan(
//                 children: <TextSpan>[
//                   TextSpan(text: ' $nota', style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
//                   const TextSpan(text: '%', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold))
//                 ],
//               ),
//             ),
//           )
//         ),        
//         const Padding(
//           padding: EdgeInsets.only(top: 2),
//           child: Text('Avaliação\ndos usuários', style: TextStyle(color: Colors.white, fontSize: 7.5),textAlign: TextAlign.center,),
//         ),
//       ],
//     );
//   }

//   return Container(
//     height: 40,
//     width: 40,
//     decoration: const BoxDecoration(
//       image: DecorationImage(
//         image: AssetImage('images/fundo_nota.png',),
//         fit: BoxFit.cover,
//       ),
//     ),
//     child: Center(
//       child: RichText(
//         text: TextSpan(
//           children: <TextSpan>[
//             TextSpan(text: ' $nota', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
//             const TextSpan(text: '%', style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold))
//           ],
//         ),
//       ),
//     )
//   );
// }