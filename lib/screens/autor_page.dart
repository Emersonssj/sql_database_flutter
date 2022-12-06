import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../db/db.dart';
import '../models/autor_model.dart';


class AutorPage extends StatefulWidget {
  const AutorPage({Key? key}) : super(key: key);

  @override
  _AutorPageState createState() => _AutorPageState();
}

class _AutorPageState extends State<AutorPage> {
  int? selectedId;
  final autorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Autores')
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: autorController,
                decoration: InputDecoration(
                    hintText: 'Nome do Autor',
                    border: OutlineInputBorder()
                  ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Autor>>(
                future: DatabaseHelper.instance.getAutores(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Autor>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text('Carregando...'));
                    }
                    return snapshot.data!.isEmpty
                    ? Center(child: Text('Lista vazia.'))
                    : ListView(
                      children: snapshot.data!.map((autor) {
                        return Center(
                          child: Card(
                            color: selectedId == autor.id
                            ? Colors.white70
                            : Colors.white,
                            child: ListTile(
                              title: Text(autor.autorName),
                              onTap: () {
                                setState(() {
                                  if (selectedId == null) {
                                    autorController.text = autor.autorName;
                                    selectedId = autor.id;
                                  } else {
                                    autorController.text = '';
                                    selectedId = null;
                                  }
                                });
                              }, 
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed:() {
                                  setState(() {
                                    DatabaseHelper.instance.removeAutores(autor.id!);
                                  });
                                },                         
                              ),
                            ),
                          )
                        );
                      }).toList(),
                    );
                  } 
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? await DatabaseHelper.instance.updateAutores(
              Autor(id: selectedId, autorName: autorController.text),
            )
                : await DatabaseHelper.instance.addAutores(
              Autor(autorName: autorController.text),
            );
            setState(() {
              autorController.clear();
              selectedId = null;
            });
          },
        ),
      ),
    );
  }
}