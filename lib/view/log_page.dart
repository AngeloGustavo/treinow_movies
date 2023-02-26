import 'package:flutter/material.dart';

import '../model/usuario.dart';
import 'feed_page.dart';

enum EstadoDaPagina {
  login,
  cadastro,
}

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  TextEditingController usuarioController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  String mensagemDeErro = '';
  bool hidePassword = true;
  EstadoDaPagina estado = EstadoDaPagina.login;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Center(child: Image.asset('asset/logoAppBar.png', fit: BoxFit.cover)),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: const EdgeInsets.only(left: 35, top: 125),
              child: Text(
                (estado == EstadoDaPagina.login) ?'Login':'Cadastro',
                style: const TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          TextField(
                            controller: usuarioController,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(25), 
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                fillColor: Colors.grey.shade600,
                                filled: true,
                                labelText: "Usuário",
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: senhaController,
                            style: const TextStyle(color: Colors.white),
                            obscureText: hidePassword,
                            decoration: InputDecoration(     
                                contentPadding: const EdgeInsets.all(25),                         
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                fillColor: Colors.grey.shade600,
                                filled: true,
                                labelText: "Senha",
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  child: Icon(
                                    hidePassword ? Icons.visibility : Icons
                                          .visibility_off, color: Colors.grey,
                                  ),
                                )
                              ),
                                
                          ),
                          Row(
                            children: [
                              Text((estado == EstadoDaPagina.login) ? 'Não tem cadastro?':'Já tem cadastro?', style: TextStyle(color: Colors.white),),
                              TextButton(
                                onPressed: () { 
                                  setState(() {
                                    if(estado == EstadoDaPagina.login){
                                      estado = EstadoDaPagina.cadastro;
                                    }
                                    else{
                                      estado = EstadoDaPagina.login;
                                    }
                                    mensagemDeErro="";
                                  });
                                },
                                child: Text((estado == EstadoDaPagina.login) ? 'Cadastre-se':'Faça Login', style: const TextStyle(color: Colors.blue),textAlign: TextAlign.left,),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(child: Text(mensagemDeErro, style: TextStyle(fontSize: 20, color: Colors.white),),),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.red,
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      setState(() {
                                        mensagemDeErro = 'Carregando...';
                                      });
                                      bool logBool;
                                      if(estado == EstadoDaPagina.login){
                                        logBool = await Usuario.autenticarUsuario(usuarioController.text, senhaController.text);
                                      }
                                      else{
                                        logBool = await Usuario.registrarUsuario(usuarioController.text, senhaController.text);
                                      }
                                      if(logBool == false){
                                        setState(() {
                                          if(estado == EstadoDaPagina.login) {
                                            mensagemDeErro="Login ou senha invalidos!";
                                          }
                                          else{
                                            mensagemDeErro="Login ja usado!";
                                          }
                                        });
                                      }else{
                                        setState(() {
                                          mensagemDeErro="";
                                          Usuario.logado = true;
                                          Usuario.login = usuarioController.text;
                                          Usuario.senha = senhaController.text;
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                            FeedPage()), (Route<dynamic> route) => false);                                   
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),                 
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}