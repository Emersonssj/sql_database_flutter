import 'package:flutter/material.dart';
import '../db/db.dart';
import '../models/livro_model.dart';

class LivroPage extends StatefulWidget {
  const LivroPage({super.key});

  @override
  State<LivroPage> createState() => _LivroPageState();
}

class _LivroPageState extends State<LivroPage> {
  int? exemplares;
  int? selectedId;
  final livroController = TextEditingController();
  final autorNomeController = TextEditingController();
  final exemplarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros'),
        backgroundColor: Colors.green,
      ),
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              TextField(
                controller: livroController,
                decoration: InputDecoration(
                    hintText: 'Nome do Livro', border: OutlineInputBorder()),
              ),
              TextField(
                controller: autorNomeController,
                decoration: InputDecoration(
                    hintText: 'Nome do Autor', border: OutlineInputBorder()),
              ),
              TextField(
                controller: exemplarController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Quantidade de exemplares',
                    border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Livro>>(
              future: DatabaseHelper.instance.getLivros(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Livro>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Carregando...'));
                }
                return snapshot.data!.isEmpty
                    ? Center(child: Text('Lista vazia.'))
                    : ListView(
                        children: snapshot.data!.map((livro) {
                          return Center(
                              child: Card(
                            color: selectedId == livro.id
                                ? Colors.white70
                                : Colors.white,
                            child: ListTile(
                                title: Container(
                                    width: 500,
                                    child: Row(
                                      children: [
                                        Text(livro.livroName),
                                        SizedBox(width: 2),
                                        Text(
                                          livro.autorName,
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(132, 0, 0, 0),
                                              fontSize: 14),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  setState(() {
                                    if (selectedId == null) {
                                      livroController.text = livro.autorName;
                                      autorNomeController.text =
                                          livro.autorName;
                                      exemplarController.text =
                                          livro.exemplares.toString();
                                      selectedId = livro.id;
                                    } else {
                                      livroController.text = '';
                                      autorNomeController.text = '';
                                      exemplarController.text = '';
                                      selectedId = null;
                                    }
                                  });
                                },
                                trailing: Wrap(
                                  spacing: 12,
                                  children: <Widget>[
                                    Text('${livro.exemplares}'),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          DatabaseHelper.instance
                                              .removeLivros(livro.id!);
                                        });
                                      },
                                    ),
                                  ],
                                )),
                          ));
                        }).toList(),
                      );
              }),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          selectedId != null
              ? await DatabaseHelper.instance.updateLivros(
                  Livro(
                      id: selectedId,
                      livroName: livroController.text,
                      autorName: autorNomeController.text,
                      exemplares: int.parse(exemplarController.text)),
                )
              : await DatabaseHelper.instance.addLivros(
                  Livro(
                      livroName: livroController.text,
                      autorName: autorNomeController.text,
                      exemplares: int.parse(exemplarController.text)),
                );
          setState(() {
            livroController.clear();
            autorNomeController.clear();
            exemplarController.clear();
            selectedId = null;
          });
        },
      ),
    );
  }
}
