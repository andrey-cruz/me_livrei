import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/validators.dart'; // Certifique-se de ter validadores ou remova
import '../models/book.dart';
import '../services/auth_service.dart';
import '../services/book_service.dart';
import '../widgets/custom_input_field.dart';
// Se você tiver o dropdown de gênero, importe aqui:
// import '../widgets/book_genre_dropdown.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final BookService _bookService = BookService();

  // Controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _publisherController = TextEditingController();
  final _conditionController = TextEditingController(); // Ex: Novo, Usado

  // Se não tiver dropdown de genero ainda, use controller ou string
  String? _selectedGenre;
  final List<String> _genres = ['Ficção', 'Romance', 'Técnico', 'Infantil', 'Outro'];

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    _publisherController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // 1. Valida o formulário
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 2. Pega o ID do usuário logado (Dono do livro)
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.currentUserId;

      if (userId == null) {
        throw Exception('Usuário não está logado');
      }

      // 3. Cria o Objeto Book (O "Pacote")
      final newBook = Book(
        userId: userId,
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        coverUrl: _coverUrlController.text.trim(),
        publisher: _publisherController.text.trim(),
        condition: _conditionController.text.trim(),
        genre: _selectedGenre ?? 'Outro',
        status: 'available', // Começa disponível
      );

      // 4. Manda para o Serviço (Agora do jeito certo!)
      await _bookService.addBook(newBook);

      if (!mounted) return;

      // 5. Sucesso e Voltar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livro cadastrado com sucesso!'),
          backgroundColor: AppColors.verdeMusgo,
        ),
      );
      Navigator.pop(context, true); // Retorna true para atualizar a lista anterior

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar: $e'),
          backgroundColor: AppColors.bordoLiterario,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar Livro',
          style: TextStyle(color: AppColors.carvaoSuave, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.marfimAntigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.carvaoSuave),
      ),
      backgroundColor: AppColors.marfimAntigo,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // URL DA CAPA
              CustomInputField(
                label: 'URL da Capa*',
                controller: _coverUrlController,
                hintText: 'https://exemplo.com/imagem.jpg',
                enabled: !_isLoading,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obrigatório';
                  if (!value.startsWith('http')) return 'Insira um link válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // TÍTULO
              CustomInputField(
                label: 'Título do Livro*',
                controller: _titleController,
                hintText: 'Ex: O Pequeno Príncipe',
                enabled: !_isLoading,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // AUTOR
              CustomInputField(
                label: 'Autor*',
                controller: _authorController,
                hintText: 'Ex: Antoine de Saint-Exupéry',
                enabled: !_isLoading,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // EDITORA
              CustomInputField(
                label: 'Editora',
                controller: _publisherController,
                hintText: 'Ex: Agir',
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // GÊNERO (Dropdown simples)
              const Text(
                'Gênero',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.carvaoSuave,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.brancoCreme,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.carvaoSuave, width: 0.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGenre,
                    hint: const Text('Selecione um gênero'),
                    isExpanded: true,
                    onChanged: _isLoading ? null : (String? newValue) {
                      setState(() {
                        _selectedGenre = newValue;
                      });
                    },
                    items: _genres.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // CONDIÇÃO
              CustomInputField(
                label: 'Condição do Livro',
                controller: _conditionController,
                hintText: 'Ex: Usado, Novo, Com rasuras...',
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // DESCRIÇÃO
              CustomInputField(
                label: 'Descrição / Sinopse*',
                controller: _descriptionController,
                hintText: 'Conte um pouco sobre o livro...',
                enabled: !_isLoading,
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),

              // BOTÃO SALVAR
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.terracotaQueimado,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Cadastrar Livro',
                    style: TextStyle(
                      fontSize: 18,
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