import 'package:flutter/material.dart';
import 'package:gerenciador_notas/services/nota_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Controller permite ler o conteudo digitado no TextField
  final TextEditingController _controller = TextEditingController();
  //instancia o service : a tela não acessa o pacote diretamente
  final NotaStorageService _storage = NotaStorageService();

  // Guarda o texto que a interface mostra abaixo do botão
  String _notaSalva = '';

  @override
  void initState() {
    super.initState();
    carregarNotas(); // recupear o valor ao abria home.
  }

  Future<void> carregarNotas() async {
    final String texto = await _storage.buscarNota();

    if (!mounted) return; // se a tela ainda esta disponivel
    setState(() {
      _notaSalva = texto; //atualiza o texto mostrado em tela
      _controller.text = texto; // preenche o campo com o valor salvo
    });
  }

  Future<void> salvarNota() async {
    final String texto = _controller.text.trim();
    if (texto.isEmpty) return;

    await _storage.salvarNotas(texto);

    if (!mounted) return; // Evita atualizar uma tela descartada

    setState(() {
      _notaSalva = texto; // mostra a versão recem salca
    });
    //informa ao usuario que a ação terminou
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('nota salva no dispositivo')));
  }

  Future<void> apagarNota() async {
    await _storage.apagarNota();
    if (!mounted) return;

    setState(() {
      _notaSalva = ''; //limpa o texto exibido
      _controller.clear(); // limpa o campo de entrada
    });
  }

  @override
  void dispose() {
    //libera o controler quando o flutter descartar a tela.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas notas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'minha primeira anotação',
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 12),

            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'escrena uma anotação ',
              ),
            ),
            SizedBox(height: 12),
            FilledButton(
              onPressed: salvarNota,
              child: const Text('salvar no dispositivo'),
            ),

            OutlinedButton(
              onPressed: apagarNota,
              child: Text('apagar nota salva'),
            ),

            const SizedBox(height: 18),

            const Text('nota recuperada no armazenamento'),

            const SizedBox(height: 8),

            Text(_notaSalva.isEmpty ? 'nenhuma nota salva.' : _notaSalva),
          ],
        ),
      ),
    );
  }
}
