import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/validators.dart';
import '../models/book.dart';
import '../widgets/custom_input_field.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/book_service.dart';
import '../widgets/book_genre_dropdown.dart';

class BookEditScreen extends StatefulWidget {
  final Book book;

  const BookEditScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookEditScreen> createState() => _BookEditScreenState();
}

class _BookEditScreenState extends State<BookEditScreen> {
  late final TextEditingController _coverUrlController;
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _publisherController;
  late final TextEditingController _conditionController;
  late final TextEditingController _descriptionController;
  final BookService _bookService = BookService();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  String? _selectedGenre;

  @override
  void initState() {
    super.initState();

    _coverUrlController = TextEditingController(text: widget.book.coverUrl);
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _publisherController = TextEditingController(text: widget.book.publisher ?? '');
    _selectedGenre = widget.book.genre;
    _conditionController = TextEditingController(text: widget.book.condition ?? '');
    _descriptionController = TextEditingController(text: widget.book.description);

    _coverUrlController.addListener(_onFieldChanged);
    _titleController.addListener(_onFieldChanged);
    _authorController.addListener(_onFieldChanged);
    _publisherController.addListener(_onFieldChanged);
    _conditionController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  Future<void> _handleSaveChanges() async {
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

      final updatedBook = widget.book;
      updatedBook.title = _titleController.text.trim();
      updatedBook.author = _authorController.text.trim();
      updatedBook.publisher = _publisherController.text.trim().isEmpty
          ? null
          : _publisherController.text.trim();
      updatedBook.genre = _selectedGenre;
      updatedBook.condition = _conditionController.text.trim().isEmpty
          ? null
          : _conditionController.text.trim();
      updatedBook.description = _descriptionController.text.trim();
      updatedBook.coverUrl = _coverUrlController.text.trim();

      await _bookService.updateBook(widget.book.id, updatedBook);

      if (!mounted) return;

      _showSuccessMessage('Livro atualizado com sucesso!');

      setState(() {
        _hasUnsavedChanges = false;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context, updatedBook);
      }

    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Erro ao atualizar livro: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDeleteBook() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir livro'),
        content: const Text(
          'Tem certeza que deseja excluir este livro permanentemente? '
              'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);

      try {
        await _bookService.deleteBook(widget.book.id);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Livro excluído com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, 'deleted');

      } catch (e) {
        if (!mounted) return;

        _showErrorMessage('Erro ao excluir livro: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.begePapel,
        title: const Text(
          'Confirmar exclusão',
          style: TextStyle(color: AppColors.carvaoSuave),
        ),
        content: const Text(
          'Tem certeza que deseja deletar este livro? Esta ação não pode ser desfeita.',
          style: TextStyle(color: AppColors.carvaoSuave),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.cinzaPoeira),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.terracotaQueimado,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    ) ?? false;
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
      body: SafeArea(
        child: Container(
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 54, right: 37),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: AppColors.carvaoSuave,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 13),

                  const Center(
                    child: Text(
                      'Editar seu livro',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // URL
                        CustomInputField(
                          label: 'URL da capa*',
                          controller: _coverUrlController,
                          enabled: !_isLoading,
                          hintText: 'http://exemplo.com/caminhoImagem.png',
                          validator: BookValidator.validateBookCoverUrl,
                        ),
                        const SizedBox(height: 16),
                        // TITULO
                        CustomInputField(
                          label: 'Título*',
                          controller: _titleController,
                          enabled: !_isLoading,
                          hintText: 'Um Titulo Exemplo',
                          validator: BookValidator.validateBookTitle,
                        ),
                        const SizedBox(height: 16),
                        // AUTOR
                        CustomInputField(
                          label: 'Autor*',
                          controller: _authorController,
                          enabled: !_isLoading,
                          hintText: 'Joãozinho da Silva',
                          validator: BookValidator.validateBookAuthor,
                        ),
                        const SizedBox(height: 16),
                        // EDITORA
                        CustomInputField(
                          label: 'Editora',
                          controller: _publisherController,
                          enabled: !_isLoading,
                          hintText: 'Exemplo LTDA',
                          validator: BookValidator.validateBookPublisher,
                        ),
                        const SizedBox(height: 16),
                        // GENERO
                        BookGenreDropdown(
                          selectedGenre: _selectedGenre,
                          onChanged: (value) {
                            setState(() {
                              _selectedGenre = value;
                              _hasUnsavedChanges = true;
                            });
                          },
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),
                        // CONDICOES
                        CustomInputField(
                          label: 'Condições do livro',
                          controller: _conditionController,
                          enabled: !_isLoading,
                          hintText: 'Em boas condições - marcas de uso minimas',
                          validator: BookValidator.validateBookCondition,
                        ),
                        const SizedBox(height: 16),
                        // DESCRICAO
                        CustomInputField(
                          label: 'Descrição*',
                          controller: _descriptionController,
                          enabled: !_isLoading,
                          maxLines: 4,
                          hintText: 'Comprei para meu filho, mas ele nao se interessou pela historia',
                          validator: BookValidator.validateBookDescription,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 51,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSaveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.terracotaQueimado,
                              foregroundColor: AppColors.brancoCreme,
                              disabledBackgroundColor: AppColors.cinzaPoeira,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                              'Salvar alterações',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 51,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _handleDeleteBook,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.begePapel,
                              side: const BorderSide(
                                color: AppColors.terracotaQueimado,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              Icons.delete,
                              size: 16,
                              color: AppColors.terracotaQueimado,
                            ),
                            label: const Text(
                              'Deletar livro',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.terracotaQueimado,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),
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
    _coverUrlController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _conditionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}