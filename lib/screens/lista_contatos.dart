import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../repositories/repositorio_contato.dart';
import 'cadastro_contato.dart';
import 'login.dart';

class ListaContatos extends StatefulWidget {
  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  final ContatoRepository _contatoRepository = ContatoRepository();
  List<Contato> _contatos = [];

  @override
  void initState() {
    super.initState();
    _loadContatos();
  }

  Future<void> _loadContatos() async {
    final contatos = await _contatoRepository.getContatos();
    setState(() {
      _contatos = contatos;
    });
  }

  Future<void> _logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _contatos.length,
        itemBuilder: (context, index) {
          final contato = _contatos[index];
          return ListTile(
            title: Text(contato.nome),
            subtitle: Text('${contato.telefone}\n${contato.email}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroContato(
                          contato: contato,
                          onSave: (contatoEditado) async {
                            await _contatoRepository
                                .atualizarContato(contatoEditado);
                            _loadContatos();
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _contatoRepository.removerContato(contato.id!);
                    _loadContatos();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CadastroContato(
                onSave: (novoContato) async {
                  await _contatoRepository.adicionarContato(novoContato);
                  _loadContatos();
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
