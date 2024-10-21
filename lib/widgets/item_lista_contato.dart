import 'package:flutter/material.dart';
import '../models/contato.dart';

class ContatoListItem extends StatelessWidget {
  final Contato contato;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ContatoListItem(
      {required this.contato, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contato.nome),
      subtitle: Text('${contato.telefone}\n${contato.email}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
