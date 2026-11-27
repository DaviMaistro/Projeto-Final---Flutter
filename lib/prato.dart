import 'package:flutter/material.dart';
import 'dados.dart';
class ImagemPrato extends StatelessWidget {
  final String? url;
  final double largura;
  final double altura;

  const ImagemPrato({
    super.key,
    required this.url,
    required this.largura,
    required this.altura,
  });

  Widget _icone() {
    return Container(
      width: largura,
      height: altura,
      color: Colors.grey[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return _icone();
    }
    return Image.network(
      url!,
      width: largura,
      height: altura,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _icone(),
    );
  }
}
class PratoCard extends StatelessWidget {
  final Receita receita;
  final bool favorita;
  final VoidCallback onTap;
  final VoidCallback onFavorito;

  const PratoCard({
    super.key,
    required this.receita,
    required this.favorita,
    required this.onTap,
    required this.onFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ImagemPrato(url: receita.imagem, largura: 56, altura: 56),
      title: Text(
        receita.nome,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: receita.resumo.isEmpty ? null : Text(receita.resumo),
      trailing: IconButton(
        icon: Icon(favorita ? Icons.favorite : Icons.favorite_border),
        tooltip: favorita ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
        onPressed: onFavorito,
      ),
      onTap: onTap,
    );
  }
}