import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'casca_navegacao.dart';

// Login com e-mail e senha. O usuário de teste está em mock_data.dart.
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  // A chave dá acesso ao Form para chamar validate()
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    // Libera os controllers quando a tela sai da memória
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // O validator devolve null quando o campo está certo, ou a mensagem de erro
  String? _validarEmail(String? valor) {
    final email = (valor ?? '').trim();
    if (email.isEmpty) {
      return 'Informe o e-mail';
    }
    // Formato simples: texto@texto.texto
    final formatoValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!formatoValido) {
      return 'Digite um e-mail válido, como nome@email.com';
    }
    return null;
  }

  String? _validarSenha(String? valor) {
    final senha = valor ?? '';
    if (senha.isEmpty) {
      return 'Informe a senha';
    }
    if (senha.length < 6) {
      return 'A senha precisa ter no mínimo 6 caracteres';
    }
    return null;
  }

  void _entrar() {
    // validate() roda os validators dos campos e mostra os erros em vermelho
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    final senha = _senhaController.text;

    if (email == usuarioTeste.email && senha == senhaTeste) {
      usuarioLogado = usuarioTeste;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bem-vinda, ${usuarioTeste.nome.split(' ').first}!'),
          backgroundColor: AppTheme.corNormal,
        ),
      );
      // Troca a pilha de telas: o botão voltar não leva de novo ao login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CascaNavegacao()),
        (rota) => rota.isFirst,
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha incorretos.'),
          backgroundColor: AppTheme.corEmergencia,
        ),
      );
    }
  }

  void _preencherUsuarioDeTeste() {
    _emailController.text = usuarioTeste.email;
    _senhaController.text = senhaTeste;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.espacoM),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Entre na sua conta',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppTheme.espacoM),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: _validarEmail,
              ),
              const SizedBox(height: AppTheme.espacoM),
              TextFormField(
                controller: _senhaController,
                obscureText: _ocultarSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  // O olho mostra ou esconde a senha
                  suffixIcon: IconButton(
                    tooltip: _ocultarSenha ? 'Mostrar senha' : 'Esconder senha',
                    icon: Icon(
                      _ocultarSenha ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _ocultarSenha = !_ocultarSenha;
                      });
                    },
                  ),
                ),
                validator: _validarSenha,
              ),
              const SizedBox(height: AppTheme.espacoG),
              ElevatedButton(onPressed: _entrar, child: const Text('Entrar')),
              const SizedBox(height: AppTheme.espacoG),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.espacoM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppTheme.azul),
                          const SizedBox(width: AppTheme.espacoP),
                          Text(
                            'Usuário de teste',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.espacoP),
                      Text('E-mail: ${usuarioTeste.email}'),
                      Text('Senha: $senhaTeste'),
                      const SizedBox(height: AppTheme.espacoP),
                      TextButton.icon(
                        onPressed: _preencherUsuarioDeTeste,
                        icon: const Icon(Icons.edit),
                        label: const Text('Preencher os campos'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
