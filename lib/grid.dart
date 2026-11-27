import 'package:flutter/material.dart';
import 'dados.dart';
import 'prato.dart';
class PratoGrid extends StatelessWidget {
  final List<Receita> pratos;
  final void Function(Receita receita) onPratoTap;
  final void Function(Receita receita) onFavorito;
  const PratoGrid({
    super.key,
    required this.pratos,
    required this.onPratoTap,
    required this.onFavorito,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final r in pratos)
          PratoCard(
            receita: r,
            favorita: ehFavorita(r),
            onTap: () => onPratoTap(r),
            onFavorito: () => onFavorito(r),
          ),
      ],
    );
  }
}