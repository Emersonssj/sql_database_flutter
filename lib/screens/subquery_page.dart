import 'package:flutter/material.dart';
import 'package:untitled/models/group_by.dart';
import '../db/db.dart';
import '../models/autor_model.dart';

class Subquery extends StatefulWidget {
  const Subquery({super.key});

  @override
  State<Subquery> createState() => _SubqueryState();
}

class _SubqueryState extends State<Subquery> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group By e Subquery'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: <Widget>[
          Text('Autores e soma de exemplares de todos os seus livros'),
          Container(
              child: Expanded(
            child: FutureBuilder<List<GroupBy>>(
                future: DatabaseHelper.instance.getLivrosPorAutor(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<GroupBy>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Carregando...'));
                  }
                  return snapshot.data!.isEmpty
                      ? Center(child: Text('Lista vazia.'))
                      : ListView(
                          children: snapshot.data!.map((groupByMap) {
                            return Center(
                                child: Card(
                              color: Colors.white,
                              child: ListTile(
                                  title: Text(groupByMap.autorName),
                                  trailing: Text('${groupByMap.totalLivros}')),
                            ));
                          }).toList(),
                        );
                }),
          )),
          Text(
              'Autores cuja soma de exemplares de todos os livros é maior que 50'),
          Container(
              child: Expanded(
            child: FutureBuilder<List<GroupBy>>(
                future: DatabaseHelper.instance.getSubQuery(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<GroupBy>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Carregando...'));
                  }
                  return snapshot.data!.isEmpty
                      ? Center(child: Text('Lista vazia.'))
                      : ListView(
                          children: snapshot.data!.map((groupByMap) {
                            return Center(
                                child: Card(
                              color: Colors.white,
                              child: ListTile(
                                  title: Text(groupByMap.autorName),
                                  trailing: Text('${groupByMap.totalLivros}')),
                            ));
                          }).toList(),
                        );
                }),
          )),
        ],
      ),
    );
  }
}
