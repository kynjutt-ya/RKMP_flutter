import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailCtrl.text.trim();
    final name = _nameCtrl.text.trim();

    // Симуляция задержки для реалистичности
    await Future.delayed(const Duration(milliseconds: 500));

    try {
    context.read<AuthCubit>().login(email, name.isEmpty ? 'Пользователь' : name);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.eco,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Добро пожаловать!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Войдите в аккаунт для продолжения',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                controller: _emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'example@mail.ru',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Введите корректный email';
                      }
                      return null;
                    },
              ),
                  const SizedBox(height: 16),
                  TextFormField(
                controller: _passwordCtrl,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      hintText: 'Введите пароль',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите пароль';
                      }
                      if (value.length < 4) {
                        return 'Пароль должен содержать минимум 4 символа';
                      }
                      return null;
                    },
              ),
                  const SizedBox(height: 16),
                  TextFormField(
                controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Ваше имя (опционально)',
                      hintText: 'Как к вам обращаться?',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(context),
              ),
                  const SizedBox(height: 32),
              ElevatedButton(
                    onPressed: _isLoading ? null : () => _login(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Войти',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Quick login для тестирования
                      _emailCtrl.text = 'test@mail.ru';
                      _passwordCtrl.text = 'test123';
                      _nameCtrl.text = 'Тестовый пользователь';
                    },
                    child: const Text('Быстрый вход (для теста)'),
              ),
            ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}