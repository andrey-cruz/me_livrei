import 'package:flutter/material.dart';
import 'package:me_livrei/constants/app_colors.dart';
import 'package:me_livrei/widgets/book_card.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'book_detail_screen.dart';
import 'books_list_screen.dart';

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

  // Controller de busca (visual por enquanto)
  final TextEditingController _searchController = TextEditingController();

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
            // --- BARRA DE PESQUISA (Design Original) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(31, 81, 74, 43),
              child: SizedBox(
                width: 306,
                height: 51,
                child: TextField(
                  controller: _searchController,
                  cursorColor: AppColors.cinzaPoeira,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.cinzaPoeira,
                    ),
                    hintText: 'Pesquisar por títulos, autores...',
                    hintStyle: const TextStyle(color: AppColors.cinzaPoeira),
                    filled: true,
                    fillColor: AppColors.brancoCreme,
                  ),
                ),
              ),
            ),

            // --- LOADING / ERRO ---
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: CircularProgressIndicator(
                    color: AppColors.terracotaQueimado,
                  ),
                ),
              )
            else if (_error != null)
              Center(
                child: Text('Erro: $_error'),
              )
            else ...[
                // ======================================================
                // SEÇÃO 1: DESTAQUES
                // ======================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 124, 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.show_chart,
                        size: 24,
                        color: AppColors.terracotaQueimado,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Destaque do Me Livrei',
                        style: TextStyle(
                          color: AppColors.carvaoSuave,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // CARROSSEL DESTAQUES
                _buildBookCarousel(
                  _allBooks.take(5).toList(),
                  emptyMessage: 'Nenhum destaque no momento',
                ),

                // ======================================================
                // SEÇÃO 2: INTERESSES
                // ======================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 36, 124, 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bookmark_add,
                        size: 24,
                        color: AppColors.terracotaQueimado,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Meus Interesses', // Texto original
                        style: TextStyle(
                          color: AppColors.carvaoSuave,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // CARROSSEL DE TODOS (Usado aqui como exemplo)
                _buildBookCarousel(
                  _allBooks,
                  emptyMessage: 'Nenhum livro cadastrado ainda',
                ),

                const SizedBox(height: 30),
              ],
          ],
        ),
      ),
    );
  }

  // --- MÉTODO DO CARROSSEL ---
  Widget _buildBookCarousel(List<Book> books, {String emptyMessage = 'Nenhum livro'}) {

    // SE ESTIVER VAZIO: Mostra placeholder com a MESMA ALTURA do card (308)
    if (books.isEmpty) {
      return Container(
        // CORRIGIDO: Altura igual à da lista de livros
        height: 308,
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Fundo cinza claro
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cinzaPoeira.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 40, color: AppColors.cinzaPoeira),
            const SizedBox(height: 8),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.cinzaPoeira,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // SE TIVER LIVROS: Mostra a lista normal
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(
                    book: book,
                    isOwner: false, // Visitante
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}