import 'package:flutter/material.dart';

// Tela de detalhes dos planetas.
class TelaDetalhes extends StatefulWidget {
  final List<Map<String, dynamic>> planetas;

  // Construtor da tela de detalhes.
  const TelaDetalhes({super.key, required this.planetas});

  @override
  // Cria o estado da tela de detalhes.
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

// Estado da tela de detalhes.
class _TelaDetalhesState extends State<TelaDetalhes> {
  @override
  // Constrói a interface da tela de detalhes.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes dos Planetas'),
      ),
      body: ListView.builder(
        itemCount: widget.planetas.length,
        itemBuilder: (context, index) {
          final planeta = widget.planetas[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Nome: ${planeta['nome']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apelido: ${planeta['apelido']}'),
                  Text('Distância: ${planeta['distancia']}'),
                  Text('Tamanho: ${planeta['tamanho']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
