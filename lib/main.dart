import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _toDolist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child:  Row(
              children: <Widget>[
                const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.pink ),
                      ),
                    ),),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                  ),
                  child: Text("ADD"),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async{
    String data = json.encode(_toDolist);
    final file = await _getFile();
    return file.writeAsString(data);

  }
  Future<String> _readData() async{
    try{
        final file = await _getFile();
        return file.readAsString();
      }catch (e){
      print('Error reading data: $e');
      return '';
    }finally{
    }
  }
}






