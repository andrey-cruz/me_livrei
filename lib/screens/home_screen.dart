import 'package:flutter/material.dart';
import 'package:me_livrei/constants/app_colors.dart';
import 'package:me_livrei/widgets/book_card.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'add_book_screen.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.marfimAntigo,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.cinzaPoeira,
                    ),
                    hintText: 'Pesquisar por títulos, autores...',
                    hintStyle: TextStyle(color: AppColors.cinzaPoeira),
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
                  child: CircularProgressIndicator(
                    color: AppColors.terracotaQueimado,
                  ),
                ),
              )
            else if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppColors.bordoLiterario,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erro ao carregar livros',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.cinzaPoeira),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _loadBooks();
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_allBooks.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: Column(
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 60,
                          color: AppColors.cinzaPoeira,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum livro disponível',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Seja o primeiro a cadastrar um livro!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.cinzaPoeira),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                  _sectionHeader(
                    'Em destaque',
                    Icons.star_border,
                    AppColors.ambarQuente,
                    onSeeAll: () {},
                  ),
                  _buildBookCarousel(_allBooks.take(5).toList()),

                const SizedBox(height: 12),

                _sectionHeader(
                  'Todos os livros',
                  Icons.book_outlined,
                  AppColors.verdeMusgo,
                  onSeeAll: () {},
                ),
                _buildBookCarousel(_allBooks),
              ],
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.carvaoSuave,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
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
