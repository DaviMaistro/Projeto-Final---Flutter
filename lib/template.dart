import 'package:flutter/material.dart';
class BaseTemplate extends StatelessWidget {
  final String titulo;
  final Widget body;
  const BaseTemplate({
    super.key,
    required this.titulo,
    required this.body,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: body,
    );
  }
}
class EstadoTela extends StatelessWidget {
  final IconData? icone;
  final bool carregando;
  final String titulo;
  final String texto;
  final List<Widget> botoes;

  const EstadoTela({
    super.key,
    this.icone,
    this.carregando = false,
    required this.titulo,
    this.texto = '',
    this.botoes = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        if (carregando)
          const CircularProgressIndicator()
        else if (icone != null)
          Icon(icone, size: 60),
        const SizedBox(height: 12),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
        if (texto != '') ...[
          const SizedBox(height: 8),
          Text(texto, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 16),
        for (final botao in botoes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: botao,
          ),
      ],
    );
  }
}