import 'package:flutter/material.dart';
import 'package:untitled/screens/subquery_page.dart';
import 'autor_page.dart';
import 'livro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina){
    setState(() {
      paginaAtual = pagina;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          AutorPage(),
          LivroPage(),
          Subquery(),
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Autor'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Livro'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Livro/autor'),
        ],
        onTap: (pagina){
          pc.animateToPage(pagina, duration: Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
}