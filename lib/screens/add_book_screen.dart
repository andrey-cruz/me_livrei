import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/validators.dart';
import '../models/Book.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/book_genre_dropdown.dart';
import '../services/auth_service.dart';
import '../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  // Controllers
  final TextEditingController _coverUrlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form e Services
  final _formKey = GlobalKey<FormState>();
  final BookService _bookService = BookService();

  // Estado
  bool _isLoading = false;
  String? _selectedGenre;

  @override
  void dispose() {
    _coverUrlController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _conditionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveBook() async {
    // Validar formulário
    final errors = BookValidator.validateBookForm(
      title: _titleController.text,
      author: _authorController.text,
      description: _descriptionController.text,
      coverUrl: _coverUrlController.text,
      publisher: _publisherController.text,
      genre: _selectedGenre ?? '',
      condition: _conditionController.text,
    );

    if (!FormUtils.isFormValid(errors)) {
      _formKey.currentState!.validate();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final uid = authService.currentUserId;

      if (uid == null) {
        _showErrorMessage('Erro: usuário não autenticado');
        return;
      }

      final newBook = Book(
        id: '',
        userId: uid,
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        publisher: _publisherController.text.trim().isEmpty
            ? null
            : _publisherController.text.trim(),
        genre: _selectedGenre,
        condition: _conditionController.text.trim().isEmpty
            ? null
            : _conditionController.text.trim(),
        description: _descriptionController.text.trim(),
        coverUrl: _coverUrlController.text.trim(),
      );

      await _bookService.createBook(newBook);

      if (!mounted) return;

      _showSuccessMessage('Livro cadastrado com sucesso!');

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Erro ao cadastrar livro: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F1),
      appBar: AppBar(
        title: const Text('Adicionar Livro'),
        backgroundColor: const Color(0xFF622D23),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // URL DA CAPA
              CustomInputField(
                label: 'URL da Capa*',
                controller: _coverUrlController,
                enabled: !_isLoading,
                hintText: 'https://exemplo.com/capa.jpg',
                validator: BookValidator.validateBookCoverUrl,
              ),
              const SizedBox(height: 16),

              // TÍTULO
              CustomInputField(
                label: 'Título*',
                controller: _titleController,
                enabled: !_isLoading,
                hintText: 'Ex: O Pequeno Príncipe',
                validator: BookValidator.validateBookTitle,
              ),
              const SizedBox(height: 16),

              // AUTOR
              CustomInputField(
                label: 'Autor*',
                controller: _authorController,
                enabled: !_isLoading,
                hintText: 'Ex: Antoine de Saint-Exupéry',
                validator: BookValidator.validateBookAuthor,
              ),
              const SizedBox(height: 16),

              // EDITORA
              CustomInputField(
                label: 'Editora',
                controller: _publisherController,
                enabled: !_isLoading,
                hintText: 'Ex: Companhia das Letras',
                validator: BookValidator.validateBookPublisher,
              ),
              const SizedBox(height: 16),

              // GÊNERO - DROPDOWN
              BookGenreDropdown(
                selectedGenre: _selectedGenre,
                onChanged: (value) {
                  setState(() => _selectedGenre = value);
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // CONDIÇÃO
              CustomInputField(
                label: 'Condição',
                controller: _conditionController,
                enabled: !_isLoading,
                hintText: 'Ex: Novo, Usado, Bom estado',
                validator: BookValidator.validateBookCondition,
              ),
              const SizedBox(height: 16),

              // DESCRIÇÃO
              CustomInputField(
                label: 'Descrição*',
                controller: _descriptionController,
                enabled: !_isLoading,
                hintText: 'Conte um pouco sobre o livro...',
                maxLines: 5,
                validator: BookValidator.validateBookDescription,
              ),
              const SizedBox(height: 32),

              // BOTÃO SALVAR
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSaveBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC5641),
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
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Cadastrar Livro',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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