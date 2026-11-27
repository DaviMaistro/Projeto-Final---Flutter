import 'package:flutter/material.dart';
import '../dados.dart';
import '../botão.dart';
import '../grid.dart';
import '../template.dart';
import '../detalhes.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Receita> receitas = [];
  bool carregando = true;
  String erro = '';

  @override
  void initState() {
    super.initState();
    buscarDados();
  }

  Future<void> buscarDados() async {
    try {
      final lista = await buscarReceitas();
      if (!mounted) return;
      setState(() {
        receitas = lista;
        carregando = false;
      });
    } on ErroApi catch (e) {
      if (!mounted) return;
      setState(() {
        erro = e.mensagem;
        carregando = false;
      });
    }
  }

  void tentarNovamente() {
    if (carregando) return;
    setState(() {
      carregando = true;
      erro = '';
    });
    buscarDados();
  }

  Future<void> abrirPesquisa() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PesquisaPage()),
    );
    if (!mounted) return;
    setState(() {});
  }

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
    Widget lista;

    if (carregando) {
      lista = const EstadoTela(
        carregando: true,
        titulo: 'Carregando',
      );
    } else if (erro != '') {
      lista = EstadoTela(
        titulo: 'Erro ao carregar',
        texto: erro,
        botoes: [
          Botao(texto: 'Tentar novamente', onPressed: tentarNovamente),
        ],
      );
    } else if (receitas.isEmpty) {
      lista = const EstadoTela(
        titulo: 'Nenhuma receita disponível',
        texto: 'Tente novamente mais tarde.',
      );
    } else {
      lista = PratoGrid(
        pratos: receitas,
        onPratoTap: abrirDetalhes,
        onFavorito: (r) {
          setState(() {
            alternarFavorito(r);
          });
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Receitas', style: TextStyle(fontSize: 28)),
        const Text('Pesquise uma receita'),
        const SizedBox(height: 10),
        Botao(texto: 'Buscar receitas', onPressed: abrirPesquisa),
        const SizedBox(height: 20),
        const Text('Receitas disponíveis', style: TextStyle(fontSize: 20)),
        const Text('Selecione uma receita para ver o preparo.'),
        const SizedBox(height: 10),
        lista,
      ],
    );
  }
}
class PesquisaPage extends StatefulWidget {
  const PesquisaPage({super.key});
  @override
  State<PesquisaPage> createState() => _PesquisaPageState();
}
class _PesquisaPageState extends State<PesquisaPage> {
  final TextEditingController campo = TextEditingController();
  final FocusNode foco = FocusNode();
  String estado = 'inicial';
  String termo = '';
  String aviso = '';
  String erro = '';
  List<Receita> resultados = [];

  @override
  void dispose() {
    campo.dispose();
    foco.dispose();
    super.dispose();
  }

  void pesquisar() {
    if (estado == 'carregando') return;

    String texto = campo.text.trim().replaceAll(RegExp(r'\s+'), ' ');

    if (texto.isEmpty) {
      setState(() {
        aviso = 'Pesquise pelo nome';
      });
      return;
    }

    termo = texto;
    buscar();
  }

  Future<void> buscar() async {
    setState(() {
      estado = 'carregando';
      aviso = '';
      erro = '';
    });

    try {
      final lista = await buscarReceitas(busca: termo);
      if (!mounted) return;
      setState(() {
        resultados = lista;
        estado = lista.isEmpty ? 'vazio' : 'resultados';
      });
    } on ErroApi catch (e) {
      if (!mounted) return;
      setState(() {
        erro = e.mensagem;
        estado = 'erro';
      });
    }
  }

  void tentarNovamente() {
    if (estado == 'carregando') return;
    buscar();
  }

  void limpar() {
    campo.clear();
    setState(() {
      estado = 'inicial';
      termo = '';
      aviso = '';
      erro = '';
      resultados = [];
    });
  }

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
    Widget corpo;

    if (estado == 'carregando') {
      corpo = const EstadoTela(
        carregando: true,
        titulo: 'Buscando receitas',
      );
    } else if (estado == 'erro') {
      corpo = EstadoTela(
        titulo: 'Houve um erro',
        texto: erro,
        botoes: [
          Botao(texto: 'Tentar novamente', onPressed: tentarNovamente),
        ],
      );
    } else if (estado == 'vazio') {
      corpo = EstadoTela(
        titulo: 'Nenhum resultado',
        texto: '"$termo" não foi encontrado',
        botoes: [
          Botao(
            texto: 'Alterar pesquisa',
            onPressed: () => foco.requestFocus(),
          ),
          Botao(
            texto: 'Ver todas as receitas',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    } else if (estado == 'resultados') {
      corpo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resultados para “$termo”', style: const TextStyle(fontSize: 18)),
          const Text('Toque na receita para ver o preparo.'),
          const SizedBox(height: 8),
          PratoGrid(
            pratos: resultados,
            onPratoTap: abrirDetalhes,
            onFavorito: (r) {
              setState(() {
                alternarFavorito(r);
              });
            },
          ),
          const SizedBox(height: 8),
          Botao(texto: 'Limpar pesquisa', onPressed: limpar),
        ],
      );
    } else {
      corpo = const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Qual receita você procura?', style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
        ],
      );
    }

    return BaseTemplate(
      titulo: 'Pesquisar receitas',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: campo,
            focusNode: foco,
            onSubmitted: (valor) => pesquisar(),
            onChanged: (valor) {
              if (aviso != '') {
                setState(() {
                  aviso = '';
                });
              }
            },
            decoration: InputDecoration(
              labelText: 'Nome da receita',
              hintText: 'Buscar pelo nome',
              errorText: aviso == '' ? null : aviso,
            ),
          ),
          const SizedBox(height: 10),
          Botao(
            texto: 'Pesquisar',
            onPressed: estado == 'carregando' ? null : pesquisar,
          ),
          const SizedBox(height: 20),
          corpo,
        ],
      ),
    );
  }
}