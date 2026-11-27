import 'dart:convert';
import 'package:http/http.dart' as http;

class Receita {
  final int id;
  final String nome;
  final List<String> ingredientes;
  final List<String> passos;
  final String? imagem;
  final int? prepMin;
  final int? cookMin;
  final int? porcoes;
  final double? nota;
  final List<String> tiposRefeicao;
  final String? dificuldade;
  final String? cozinha;

  Receita({
    required this.id,
    required this.nome,
    required this.ingredientes,
    required this.passos,
    required this.tiposRefeicao,
    this.imagem,
    this.prepMin,
    this.cookMin,
    this.porcoes,
    this.nota,
    this.dificuldade,
    this.cozinha,
  });

  factory Receita.fromJson(dynamic json) {
    if (json is! Map) {
      throw const FormatException('Receita em formato errado');
    }

    final id = json['id'];
    if (id is! int) {
      throw const FormatException('id errado');
    }
    return Receita(
      id: id,
      nome: _texto(json['name']) ?? 'Receita sem nome',
      ingredientes: _lista(json['ingredients']),
      passos: _lista(json['instructions']),
      tiposRefeicao: _lista(json['mealType']),
      imagem: _texto(json['image']),
      prepMin: _inteiro(json['prepTimeMinutes']),
      cookMin: _inteiro(json['cookTimeMinutes']),
      porcoes: _inteiro(json['servings']),
      nota: json['rating'] is num ? (json['rating'] as num).toDouble() : null,
      dificuldade: _texto(json['difficulty']),
      cozinha: _texto(json['cuisine']),
    );
  }
  String? get tempoTexto {
    if (prepMin != null && cookMin != null) {
      return '${prepMin! + cookMin!} min';
    }
    if (prepMin != null) {
      return '$prepMin min (só preparo)';
    }
    if (cookMin != null) {
      return '$cookMin min (só cozimento)';
    }
    return null;
  }

  String? get notaTexto {
    if (nota == null) return null;
    return '${nota!.toStringAsFixed(1).replaceAll('.', ',')} / 5';
  }
  bool get temPorcoes => porcoes != null && porcoes! > 0;

  String get resumo {
    final partes = <String>[];
    if (tempoTexto != null) partes.add(tempoTexto!);
    if (dificuldade != null) partes.add(dificuldade!);
    if (notaTexto != null) partes.add(notaTexto!);
    return partes.join(' • ');
  }
}

String? _texto(dynamic valor) {
  if (valor is String && valor.trim().isNotEmpty) {
    return valor.trim();
  }
  return null;
}

List<String> _lista(dynamic valor) {
  if (valor is List) {
    return valor.map((item) => item.toString()).toList();
  }
  return [];
}

int? _inteiro(dynamic valor) {
  if (valor is num) {
    return valor.toInt();
  }
  return null;
}
class ErroApi implements Exception {
  final String mensagem;
  ErroApi(this.mensagem);
}

Future<List<Receita>> buscarReceitas({String busca = ''}) async {
  Uri url;
  if (busca.isEmpty) {
    url = Uri.https('dummyjson.com', '/recipes', {'limit': '30'});
  } else {
    url = Uri.https('dummyjson.com', '/recipes/search', {'q': busca});
  }
  http.Response resposta;
  try {
    resposta = await http.get(url).timeout(const Duration(seconds: 15));
  } catch (_) {
    throw ErroApi('Sem conexão.');
  }

  if (resposta.statusCode != 200) {
    throw ErroApi(
        'Ocorreu o erro ${resposta.statusCode}');
  }

  try {
    final corpo = jsonDecode(resposta.body);
    if (corpo is! Map || corpo['recipes'] is! List) {
      throw const FormatException('Resposta sem a lista de receitas');
    }
    final lista = corpo['recipes'] as List;
    return lista.map((item) => Receita.fromJson(item)).toList();
  } catch (_) {
    throw ErroApi('Recebemos dados em um formato inesperado. Tente novamente.');
  }
}

final List<Receita> favoritos = [];

bool ehFavorita(Receita receita) {
  return favoritos.any((f) => f.id == receita.id);
}
void alternarFavorito(Receita receita) {
  if (ehFavorita(receita)) {
    favoritos.removeWhere((f) => f.id == receita.id);
  } else {
    favoritos.add(receita);
  }
}