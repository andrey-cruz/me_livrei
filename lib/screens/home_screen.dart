import 'package:flutter/material.dart';
import 'package:me_livrei/constants/app_colors.dart';
import 'package:me_livrei/widgets/book_card.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'books_list_screen.dart'; // Importe a nova tela

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookService _bookService = BookService();
  List<Book> _allBooks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final books = await _bookService.getAvailableBooks();
      if (mounted) {
        setState(() {
          _allBooks = books;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToBookList(String title, List<Book> books) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BooksListScreen(
          title: title,
          books: books,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.marfimAntigo,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (O código da barra de pesquisa continua igual) ...
            Padding(
              padding: const EdgeInsets.fromLTRB(31, 81, 74, 43),
              child: SizedBox(
                width: 306,
                height: 51,
                child: TextField(
                  cursorColor: AppColors.cinzaPoeira,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(width: 0.5, color: AppColors.carvaoSuave)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(width: 0.5, color: AppColors.carvaoSuave)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(width: 0.5, color: AppColors.carvaoSuave)),
                    prefixIcon:
                    const Icon(Icons.search, color: AppColors.cinzaPoeira),
                    hintText: 'Pesquisar por títulos, autores...',
                    hintStyle: const TextStyle(color: AppColors.cinzaPoeira),
                    filled: true,
                    fillColor: AppColors.brancoCreme,
                  ),
                ),
              ),
            ),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: CircularProgressIndicator(color: AppColors.terracotaQueimado),
                ),
              )
            else if (_error != null)
            // ... (O tratamento de erro continua igual) ...
              Center(
                child: Text('Erro: $_error'),
              )
            else if (_allBooks.isEmpty)
              // ... (O tratamento de lista vazia continua igual) ...
                const Center(child: Text('Nenhum livro'))
              else ...[
                  // Destaques
                  _sectionHeader(
                    'Em destaque',
                    Icons.star_border,
                    AppColors.ambarQuente,
                    onSeeAll: () {
                      // Passando apenas os 5 primeiros como destaque
                      _navigateToBookList('Em Destaque', _allBooks.take(5).toList());
                    },
                  ),
                  _buildBookCarousel(_allBooks.take(5).toList()),

                  const SizedBox(height: 12),

                  // Todos os Livros
                  _sectionHeader(
                    'Todos os livros',
                    Icons.book_outlined,
                    AppColors.verdeMusgo,
                    onSeeAll: () {
                      // Passando a lista completa
                      _navigateToBookList('Todos os Livros', _allBooks);
                    },
                  ),
                  _buildBookCarousel(_allBooks),

                  // Espaço extra no final
                  const SizedBox(height: 30),
                ],
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color,
      {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.carvaoSuave,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'Ver todos',
                style: TextStyle(
                  color: AppColors.terracotaQueimado,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookCarousel(List<Book> books) {
    return SizedBox(
      height: 308,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(
            imageUrl: book.coverUrl,
            title: book.title,
            author: book.author,
            onTap: () {},
          );
        },
      ),
    );
  }
}