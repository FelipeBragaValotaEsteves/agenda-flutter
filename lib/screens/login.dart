import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';
import 'lista_contatos.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    final db = DatabaseHelper();

    final user = await db.getUser(username, password);

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListaContatos()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário ou senha inválidos')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    final db = DatabaseHelper();

    bool userExists = await db.isUserExist(username);

    if (userExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário já existe!')),
      );
    } else {
      await db.insertUser(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nome de Usuário'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome de usuário';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: _login,
                          child: Text('Login'),
                        ),
                        TextButton(
                          onPressed: _register,
                          child: Text('Cadastrar'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
