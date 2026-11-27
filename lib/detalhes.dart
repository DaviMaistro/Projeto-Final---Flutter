import 'package:flutter/material.dart';
import 'dados.dart';
import 'botão.dart';
import 'prato.dart';
import 'template.dart';
class DetalhesPage extends StatefulWidget {
  final Receita receita;

  const DetalhesPage({super.key, required this.receita});

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final r = widget.receita;
    final favorita = ehFavorita(r);

    final info = <String>[];
    if (r.cozinha != null) info.add(r.cozinha!);
    if (r.dificuldade != null) info.add(r.dificuldade!);
    if (r.notaTexto != null) info.add(r.notaTexto!);

    return BaseTemplate(
      titulo: 'Receita',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ImagemPrato(url: r.imagem, largura: double.infinity, altura: 200),
          const SizedBox(height: 16),
          Text(
            r.nome,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (r.tempoTexto != null)
            Text('Tempo: ${r.tempoTexto}')
          else
            const Text('Tempo: não informado'),
          if (r.temPorcoes) Text('Porções: ${r.porcoes}'),
          if (r.tiposRefeicao.isNotEmpty)
            Text('Refeição: ${r.tiposRefeicao.join(', ')}'),
          const SizedBox(height: 12),
          Botao(
            texto: favorita ? 'Remover dos favoritos' : 'Salvar nos favoritos',
            onPressed: () {
              setState(() {
                alternarFavorito(r);
              });
            },
          ),
          const SizedBox(height: 20),
          const Text('Ingredientes', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          if (r.ingredientes.isEmpty) const Text('Ingredientes não informados.'),
          for (final item in r.ingredientes) Text('$item'),
          const SizedBox(height: 20),
          const Text('Modo de preparo', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          if (r.passos.isEmpty) const Text('Modo de preparo não informado.'),
          for (int i = 0; i < r.passos.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('${i + 1}. ${r.passos[i]}'),
            ),
          const SizedBox(height: 12),
          Botao(
            texto: 'Voltar',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}