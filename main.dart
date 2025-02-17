import 'package:flutter/material.dart';
import 'package:myapp/telas/tela_detalhes.dart';
import 'controles/controle_planeta.dart';
import 'modelos/planeta.dart';
import 'telas/tela_planeta.dart';
/// Função principal que inicia o aplicativo.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  
  /// Construtor da classe MyApp.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App - Planetas'),
    );
  } // Define a estrutura e o tema do app
}

class MyHomePage extends StatefulWidget {
  
  const MyHomePage({super.key, required this.title});
  /// Título da tela inicial.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  
  List<Planeta> _planetas = [];

  /// Inicializa o estado do widget.
  @override
  void initState() {
    super.initState();
    _atualizarPlanetas();
  }

  /// Atualiza a lista de planetas.
  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  /// Navega para a tela de inclusão de planeta.
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true,
          planeta: Planeta.vazio(),
          onFinalizado: () {
            _atualizarPlanetas();
          },
        )),
    );
  }

  /// Navega para a tela de alteração de planeta.
  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false,
          planeta: planeta,
          onFinalizado: () {
            _atualizarPlanetas();
          },
        )),
    );
  }

  /// Exclui um planeta da lista.
  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _atualizarPlanetas();
  }

  /// Navega para a tela de detalhes.
  void navigateToDetalhes(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const TelaDetalhes(planetas: [],)),
  );
}

  /// Constrói a interface do usuário da tela inicial.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
            title: Text(planeta.nome),
            subtitle: Text(planeta.distancia.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _alterarPlaneta(context, planeta),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _excluirPlaneta(planeta.id!),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
