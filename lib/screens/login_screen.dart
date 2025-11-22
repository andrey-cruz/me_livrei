import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/validators.dart';
import '../widgets/custom_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final errors = AuthValidator.validateLoginForm(
      _emailController.text,
      _passwordController.text,
    );

    if (!FormUtils.isFormValid(errors)) {
      _formKey.currentState!.validate();
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      _showSuccessMessage('Login realizado com sucesso!');

    } on Exception catch (e) {
      if (!mounted) return;
      _showErrorMessage('Erro ao fazer login: $e');

    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToRegister() {
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tela de cadastro será implementada'),
        backgroundColor: AppColors.azulPetroleo,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.verdeMusgo,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.bordoLiterario,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.marfimAntigo,
              AppColors.farinhaTrigo,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Column(
                    children: [
                      Text(
                        'Que bom te ver de volta!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.carvaoSuave,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Continue sua jornada literária de onde parou.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.cinzaPoeira,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // EMAIL
                        CustomInputField(
                          label: 'E-mail*',
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          hintText: 'Insira seu endereço de e-mail',
                          validator: AuthValidator.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        // PASSWORD
                        CustomInputField(
                          label: 'Senha*',
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          hintText: 'Insira sua senha',
                          validator: AuthValidator.validatePassword,
                        ),
                        const SizedBox(height: 32),

                        // LOGIN BUTTON
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.terracotaQueimado,
                            foregroundColor: AppColors.brancoCreme,
                            disabledBackgroundColor: AppColors.cinzaPoeira,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.brancoCreme,
                              ),
                            ),
                          )
                              : const Text(
                            'Entrar no aplicativo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // REGISTER LINK
                  TextButton(
                    onPressed: _navigateToRegister,
                    child: const Text(
                      'É novo por aqui? Cadastre-se',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.terracotaQueimado,
                        color: AppColors.terracotaQueimado,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}