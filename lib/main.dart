import 'package:flutter/material.dart';

//Importações para chamada JSON
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//Importação para DateFormat
import 'package:intl/intl.dart';

void main() async {
//recebendo os dados da API
  Map _data = await getQuakes();
  List _features = _data['features'];
//Formatando a DATA
  var date = _features[0]['properties']['time'] * 1000;
  var format = new DateFormat.yMMMd();
  DateTime dateTime = new DateTime.fromMicrosecondsSinceEpoch(date);
  var dateString = format.format(dateTime);

//Analise da JSON tree(Arvore) dica: http://jsonviewer.stack.hu site para analise de arvores JSON
//debugPrint(_features[0]['properties']['place']);

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text("Tremores de terra no Mundo"),
      ),
      //Construindo um List view Controlado para receber os dados
      body: Center(
        child: ListView.builder(
          itemCount: _features.length,
          padding: const EdgeInsets.all(14.5),
          itemBuilder: (BuildContext context, int position) {
            return Column(
              children: <Widget>[
                Divider(
                  height: 5.5,
                ),
                ListTile(
                  title: Text("$dateString Magnitude: ${_features[position]['properties']['mag']}"),
                  subtitle: Text(
                      "Localização : ${_features[position]['properties']['place']} "),
                  leading: CircleAvatar(
                    // Icone em forma de contato da Classe ListTile/
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                        "${_features[position]['properties']['mag']}",style: TextStyle(color: Colors.white),),
                  ),
                  //Quando clicado segurando Cria um diálogo acessando o campo body
                  onTap: () => _showMessage(context,
                      "${_features[position]['properties']['title']} "),
                  onLongPress: () => debugPrint("longpress"),
                )
              ],
            );
          },
        ),
      ),
    ),
  ));
}

//Função pra abrir uma caixa de diálogo
void _showMessage(BuildContext context, String message) {
  var alert = AlertDialog(
    title: Text("Resumo"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Ok"),
      )
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}

//Realizando a requisição JSON o site colocado é uma API gratuita que informa
//Os tremores de terra globais e o horário que aconteceu
Future<Map> getQuakes() async {
  String apiUrl =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Falhou!');
  }
}
