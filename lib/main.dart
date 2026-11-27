import 'package:flutter/material.dart';
import 'abas/home.dart';
import 'abas/favoritos.dart';
import 'abas/perfil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Saborê',
      debugShowCheckedModeBanner: false,
      home: Principal(),
    );
  }
}
class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int aba = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saborê'),
      ),
      body: IndexedStack(
        index: aba,
        children: [
          HomePage(),
          FavoritosPage(
            irParaExplorar: () {
              setState(() {
                aba = 0;
              });
            },
          ),
          const PerfilPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: aba,
        onTap: (i) {
          setState(() {
            aba = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}