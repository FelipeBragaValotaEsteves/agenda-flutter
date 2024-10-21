import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../utils/validadores.dart';

class CadastroContato extends StatefulWidget {
  final Contato? contato;
  final Function(Contato) onSave;

  CadastroContato({this.contato, required this.onSave});

  @override
  _CadastroContatoState createState() => _CadastroContatoState();
}

class _CadastroContatoState extends State<CadastroContato> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _telefone;
  late String _email;

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      _nome = widget.contato!.nome;
      _telefone = widget.contato!.telefone;
      _email = widget.contato!.email;
    } else {
      _nome = '';
      _telefone = '';
      _email = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contato == null ? 'Novo Contato' : 'Editar Contato'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nome,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: Validators.validarNome,
                onSaved: (value) => _nome = value!,
              ),
              TextFormField(
                initialValue: _telefone,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: Validators.validarTelefone,
                onSaved: (value) => _telefone = value!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: Validators.validarEmail,
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Salvar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final contato = Contato(
                      id: widget.contato?.id,
                      nome: _nome,
                      telefone: _telefone,
                      email: _email,
                    );
                    widget.onSave(contato);
                    Navigator.pop(context);
                  }
                },
              ),
              if (widget.contato != null) ...[
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  child: Text('Deletar'),
                  onPressed: () async {
                    final confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmar Deleção'),
                          content: Text('Deseja deletar este contato?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: Text('Deletar'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete == true) {
                      Navigator.pop(context, 'delete');
                    }
                  },
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
