import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> _recuperarPreco() async {
    http.Response response;
    response = await http.get(Uri.parse("https://blockchain.info/ticker"));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot) {
        String resultado;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:

          case ConnectionState.waiting:
            resultado = "Carregando...";
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              resultado = "Erro ao carregar os dados.";
            } else {
              double valor = snapshot.data!["BRL"]["buy"];
              resultado = "R\$ $valor";
            }
            break;
        }

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("imagens/bitcoin.png"),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Text(
                      resultado,
                      style: const TextStyle(
                        fontSize: 35,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black12,
                      backgroundColor: Colors.orange, // foreground
                    ),
                    onPressed: () => setState(() {
                      double valor = snapshot.data!["BRL"]["buy"];
                      resultado = "R\$ $valor";
                    }),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        "Atualizar",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
