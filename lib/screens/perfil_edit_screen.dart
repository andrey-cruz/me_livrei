import 'package:flutter/material.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/Custom_dropdowns.dart';
import '../constants/validators.dart';
import '../constants/app_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../constants/delete_account_dialog.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class PerfilEditerPage extends StatefulWidget {
  final UserModel user;

  const PerfilEditerPage({super.key, required this.user});

  @override
  State<PerfilEditerPage> createState() => _PerfilEditerPageState();
}

class _PerfilEditerPageState extends State<PerfilEditerPage> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Dropdowns
  String? _estadoId;
  String? _cidadeId;
  String? _generoId;

  // Estado
  bool _isLoading = false;

  // Máscara de telefone
  final _phoneMask = MaskTextInputFormatter(
    mask: '+55 (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// Inicializa controllers com dados do usuário
  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);

    _estadoId = widget.user.state;
    _cidadeId = widget.user.city;
    _generoId = widget.user.genre;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      _showMessage('Por favor, corrija os erros no formulário', isError: true);
      return;
    }

    if (_estadoId == null || _cidadeId == null) {
      _showMessage('Selecione estado e cidade', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final uid = authService.currentUserId;

      if (uid == null) {
        _showMessage('Erro: usuário não autenticado', isError: true);
        return;
      }

      final updatedUser = widget.user.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        state: _estadoId,
        city: _cidadeId,
        genre: _generoId,
        updatedAt: DateTime.now(),
      );

      await _userService.updateUser(uid, updatedUser);

      if (!mounted) return;

      _showMessage('Alterações salvas com sucesso!');

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context, updatedUser);
      }

    } catch (e) {
      if (!mounted) return;
      _showMessage('Erro ao salvar alterações: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeleteAccountDialog(
        onConfirm: () async {
          // AQUI DELETAR A CONTA
          try {
            final authService = Provider.of<AuthService>(context, listen: false);
            final uid = authService.currentUserId;

            if (uid != null) {
              await _userService.deleteUser(uid);
              await authService.signOut();

              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                      (route) => false,
                );
              }
            }
          } catch (e) {
            if (mounted) {
              _showMessage('Erro ao deletar conta: $e', isError: true);
            }
          }
        },
      ),
    );
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
              padding: const EdgeInsets.all(32),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildFormFields(),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                      const SizedBox(height: 16),
                      _buildDeleteButton(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40),
        const Text(
          "Editar seu perfil",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.carvaoSuave,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomInputField(
          label: 'Nome Completo',
          controller: _nameController,
          enabled: !_isLoading,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          hintText: 'Digite seu nome',
          validator: AuthValidator.validateName,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'E-mail',
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
          inputFormatters: [_phoneMask],
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          hintText: '+55 (48) 98888-8888',
          validator: AuthValidator.validatePhone,
        ),
        const SizedBox(height: 16),
        Dropdowns(
          initialEstadoId: _estadoId,
          initialCidadeId: _cidadeId,
          initialGeneroId: _generoId,
          onEstadoChanged: (id) => setState(() => _estadoId = id),
          onCidadeChanged: (id) => setState(() => _cidadeId = id),
          onGeneroChanged: (g) => setState(() => _generoId = g),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSave,
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
          "Salvar alterações",
          style: TextStyle(
            color: AppColors.brancoCreme,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _handleDeleteAccount,
        icon: const Icon(
          Icons.delete_outline,
          color: AppColors.bordoLiterario,
        ),
        label: const Text(
          "Deletar meu perfil",
          style: TextStyle(
            color: AppColors.bordoLiterario,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.bordoLiterario),
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: AppColors.brancoCreme,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}