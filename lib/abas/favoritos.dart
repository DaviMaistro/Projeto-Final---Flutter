import 'package:flutter/material.dart';
import '../dados.dart';
import '../botão.dart';
import '../grid.dart';
import '../template.dart';
import '../detalhes.dart';

class FavoritosPage extends StatefulWidget {
  final VoidCallback irParaExplorar;
  FavoritosPage({super.key, required this.irParaExplorar});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}
class _FavoritosPageState extends State<FavoritosPage> {
  Future<void> abrirDetalhes(Receita receita) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalhesPage(receita: receita)),
    );
    if (!mounted) return;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    if (favoritos.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EstadoTela(
            titulo: 'Nenhum favorito',
            botoes: [
              Botao(
                texto: 'Explorar receitas',
                onPressed: widget.irParaExplorar,
              ),
            ],
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Favoritos', style: TextStyle(fontSize: 28)),
        const Text('Receitas salvas'),
        const SizedBox(height: 10),
        PratoGrid(
          pratos: favoritos,
          onPratoTap: abrirDetalhes,
          onFavorito: (r) {
            setState(() {
              alternarFavorito(r);
            });
          },
        ),
      ],
    );
  }
}