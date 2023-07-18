import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();

  List _toDolist = [];


  @override
  void initState() {
    super.initState();
    _readData().then((data){
      setState(() {
        _toDolist = json.decode(data);
      });
    });
  }

  void _addTodo(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDolist.add(newToDo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de Tarefas"),
          backgroundColor: Color(0xFF123d70),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: <Widget>[
                 Expanded(
                    child: TextField(
                      controller: _toDoController,
                      decoration: const InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color:Color(0xFF123d70)),
                      ),
                    ),),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF123d70),
                    ),
                    child: Text("ADD"),
                    onPressed: _addTodo,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: _toDolist.length,
                itemBuilder: buildItem),
            ),
          ],
        )
    );
  }

  Widget buildItem(context, int index) {
    return Dismissible(key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
    background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
    ),
    direction: DismissDirection.startToEnd,
    child: CheckboxListTile(
    title:Text (_toDolist[index] ["title"]),
    value: _toDolist[index] ["ok"],
    secondary: CircleAvatar(child: Icon(_toDolist[index] ["ok"] ?
    Icons.check : Icons.error),),
    onChanged: (c) {
    setState(() {
    _toDolist[index]["ok"] = c;
    _saveData();
    });
    } ,
    ),
    );
  }


  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDolist);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print('Error reading data: $e');
      return '';
    } finally {}
  }
}






