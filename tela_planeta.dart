import 'package:flutter/material.dart';
import 'package:myapp/controles/controle_planeta.dart';
import '../modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late Planeta _planeta;

  // Inicializa o estado da tela e os valores dos controladores de texto.
  @override
  void initState() {
    _planeta = widget.planeta;
    _nomeController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho.toString();
    _distanciaController.text = _planeta.distancia.toString();
    _apelidoController.text = _planeta.apelido ?? '';
    super.initState();
  }

  // Libera os recursos dos controladores de texto quando a tela é descartada.
  @override
  void dispose() {
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  // Insere um novo planeta usando o controle_planeta.
  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  // Altera um planeta existente usando o controle_planeta.
  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  // Submete o formulário, validando os dados e realizando a inclusão ou alteração.
  void _submitForm() { 
    if (_formkey.currentState!.validate()) {
      //dados salvos
      _formkey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text('Dados do planeta foram ${widget.isIncluir ? 'incluidos' : 'alterados'} com sucesso!'),
      ));
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }
  
  // Constrói a interface da tela.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Planeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Por favor, insira o nome com ao menos 3 caracteres';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),

                TextFormField(
                  controller: _tamanhoController,
                  decoration: const InputDecoration(labelText: 'Tamanho'),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um tamanho';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),

                TextFormField(
                  controller: _distanciaController,
                  decoration: const InputDecoration(labelText: 'Distância'),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma distância para o planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),

                TextFormField(
                  controller: _apelidoController,
                  decoration: const InputDecoration(labelText: 'Apelido'),
                  onSaved: (value) {
                    _planeta.apelido = value!;
                  },
                ),
                const SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () =>Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),

                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
