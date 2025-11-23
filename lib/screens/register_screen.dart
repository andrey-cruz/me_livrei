import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/validators.dart';
import '../../widgets/Custom_dropdowns.dart';
import '../widgets/custom_input_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Máscara de telefone
  final _phoneMask = MaskTextInputFormatter(
    mask: '55+ (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Estado
  bool _isLoading = false;
  String? _estadoId;
  String? _cidadeId;
  String? _generoId;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Remove foco dos campos
    FocusScope.of(context).unfocus();

    // Valida formulário
    if (!_formKey.currentState!.validate()) {
      _showMessage('Por favor, corrija os erros no formulário', isError: true);
      return;
    }

    // Valida dropdowns
    if (_estadoId == null || _cidadeId == null) {
      _showMessage('Selecione estado e cidade', isError: true);
      return;
    }

    if (_generoId == null) {
      _showMessage('Selecione um gênero literário', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Substituir por sua chamada de API real
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      _showMessage('Cadastro realizado com sucesso!');

      // TODO: Navegar para próxima tela
      // Navigator.pushReplacementNamed(context, '/home');
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      _showMessage('Erro ao realizar cadastro: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.bordoLiterario : AppColors.verdeMusgo,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final maxWidth = isTablet ? 500.0 : size.width * 0.9;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.marfimAntigo, AppColors.farinhaTrigo],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildFormFields(),
                      const SizedBox(height: 32),
                      _buildRegisterButton(),
                      const SizedBox(height: 12),
                      _buildLoginButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Junte-se a nós!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.carvaoSuave,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Troque livros e conecte-se com leitores como você.',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.cinzaPoeira,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomInputField(
          label: 'Nome Completo',
          controller: _nameController,
          enabled: !_isLoading,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          hintText: 'Digite seu nome completo',
          validator: AuthValidator.validateName,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Username',
          controller: _usernameController,
          enabled: !_isLoading,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          hintText: 'Digite seu username',
          validator: AuthValidator.validateUsername,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Email',
          controller: _emailController,
          enabled: !_isLoading,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hintText: 'seu@email.com',
          validator: AuthValidator.validateEmail,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Telefone',
          controller: _phoneController,
          enabled: !_isLoading,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          hintText: '55+ (48) 98888-8888',
          inputFormatters: [_phoneMask],
          validator: AuthValidator.validatePhone,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Senha',
          controller: _passwordController,
          enabled: !_isLoading,
          obscureText: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          hintText: 'Mínimo 6 caracteres',
          validator: AuthValidator.validatePassword,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'Confirme sua senha',
          controller: _confirmPasswordController,
          enabled: !_isLoading,
          obscureText: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          hintText: 'Digite a mesma senha',
          validator: (value) => AuthValidator.validateConfirmPassword(
            value,
            _passwordController.text.trim(),
          ),
        ),
        const SizedBox(height: 16),
        Dropdowns(
          onEstadoChanged: (id) => setState(() => _estadoId = id),
          onCidadeChanged: (id) => setState(() => _cidadeId = id),
          onGeneroChanged: (g) => setState(() => _generoId = g),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.terracotaQueimado,
          disabledBackgroundColor: AppColors.terracotaQueimado.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.brancoCreme,
          ),
        )
            : const Text(
          "Criar conta",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.brancoCreme,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: _isLoading ? null : () => Navigator.pop(context),
      child: const Text(
        "Já é membro? Faça login",
        style: TextStyle(
          color: AppColors.terracotaQueimado,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}